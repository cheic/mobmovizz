import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobmovizz/core/theme/colors.dart';
import 'package:mobmovizz/core/widgets/app_bar.dart';
import 'package:mobmovizz/features/genres/movies_by_genre/bloc/movies_by_genre_bloc.dart';
import 'package:mobmovizz/features/genres/movies_genre_list/bloc/movie_genres_bloc.dart';
import 'package:mobmovizz/features/movie_details/view/movie_details_view.dart';

class MovieGenreListView extends StatefulWidget {
  const MovieGenreListView({super.key});

  @override
  _MovieGenreListViewState createState() => _MovieGenreListViewState();
}

class _MovieGenreListViewState extends State<MovieGenreListView> {
  final ScrollController _scrollController = ScrollController();
  int? _selectedGenreId;
  double _genreListHeight = 100.0;
  bool _isAtTop = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Check if the scroll position is at the top
    if (_scrollController.position.pixels == 0) {
      if (!_isAtTop) {
        setState(() {
          _isAtTop = true; // Set to true when at the top
          _genreListHeight = 100; // Show the genre list
        });
      }
    } else {
      if (_isAtTop) {
        setState(() {
          _isAtTop = false; // Set to false when scrolling down
          _genreListHeight = 0; // Hide the genre list
        });
      }
    }
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      final bloc = context.read<MoviesByGenreBloc>();
      if (bloc.state is MoviesByGenreLoaded) {
        final currentState = bloc.state as MoviesByGenreLoaded;
        if (currentState.currentPage < currentState.totalPages) {
          bloc.add(FetchMoreMoviesByGenre(
              currentState.genreId, currentState.currentPage + 1));
        }
      }
    }
  }

  void _fetchMoviesForGenre(int genreId) {
    context.read<MoviesByGenreBloc>().add(FetchMoviesByGenre(genreId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(title: "MOBMOVIZZ"),
      backgroundColor: surfaceDim,
      body: BlocBuilder<MovieGenresBloc, MovieGenresState>(
        builder: (context, state) {
          if (state is MovieGenresLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MovieGenresLoaded) {
            if (state.movieGenresListModel.genres?.isNotEmpty == true &&
                _selectedGenreId == null) {
              _selectedGenreId ??= state.movieGenresListModel.genres!.first.id!;
              _fetchMoviesForGenre(_selectedGenreId!);
            }
            return Column(
              children: [
                AnimatedContainer(
                  duration:
                      const Duration(milliseconds: 300), // Animation duration
                  height: _genreListHeight, // Height controlled by scrolling
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.movieGenresListModel.genres?.length ?? 0,
                    itemBuilder: (context, index) {
                      final genre = state.movieGenresListModel.genres![index];
                      final isSelected = genre.id == _selectedGenreId;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: ActionChip(
                          elevation: 0,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          backgroundColor: isSelected
                              ? royalBlue
                              : snow,
                          side: BorderSide.none, 
                          label: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: Text(
                              genre.name ?? "",
                              style: TextStyle(
                                color: isSelected ? Colors.white : royalBlue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          onPressed: () {
                            if (_selectedGenreId != genre.id) {
                              setState(() {
                                _selectedGenreId = genre.id;
                              });
                              _fetchMoviesForGenre(genre.id!);
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
                BlocBuilder<MoviesByGenreBloc, MoviesByGenreState>(
                  builder: (context, state) {
                    if (state is MoviesByGenreLoading) {
                      return const Center(
                        heightFactor: 16,
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is MoviesByGenreLoaded) {
                      return Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: state.movies.results?.length,
                          itemBuilder: (context, index) {
                            final movie = state.movies.results?[index];
                            return ListTile(
                              title: CachedNetworkImage(
                                maxWidthDiskCache: 1000,
                                maxHeightDiskCache: 1000,
                                progressIndicatorBuilder:
                                    (context, url, progress) => Center(
                                  child: CircularProgressIndicator(
                                    value: progress.progress,
                                  ),
                                ),
                                imageUrl:
                                    'https://image.tmdb.org/t/p/w500${movie!.posterPath}',
                                fit: BoxFit.cover,
                                
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => MovieDetailsView(
                                        movieId: movie.id!),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      );
                    } else if (state is MoviesByGenreError) {
                      return Center(child: Text('Error: ${state.message}'));
                    } else {
                      return const Center(
                          child: Text('Select a genre to see movies'));
                    }
                  },
                ),
              ],
            );
          } else if (state is MovieGenresError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: Text('Search for genres'));
          }
        },
      ),
    );
  }
}
