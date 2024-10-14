import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobmovizz/core/theme/colors.dart';
import 'package:mobmovizz/core/widgets/app_bar.dart';
import 'package:mobmovizz/core/widgets/circular_progress.dart';
import 'package:mobmovizz/features/movie_details/view/movie_details_view.dart';
import 'package:mobmovizz/features/search/bloc/search_movie_bloc.dart';


class SearchMovieView extends StatelessWidget {
  SearchMovieView({super.key});

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(title: "Movie Search"),
      backgroundColor: surfaceDim,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search for movies...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    if (_searchController.text.isNotEmpty) {
                      context.read<SearchMovieBloc>().add(
                            FetchMovieEvent(_searchController.text),
                          );
                    }
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  
                  context.read<SearchMovieBloc>().add(FetchMovieEvent(value));
                }
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchMovieBloc, SearchMovieState>(
              builder: (context, state) {
                if (state is SearchMovieInitial) {
                  return const Center(child: Text('Search for a movie'));
                } else if (state is SearchMovieLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SearchMovieLoaded) {
                  return ListView.builder(
                    itemCount: state.searchMovieModel.results?.length,
                    itemBuilder: (context, index) {
                      final movie = state.searchMovieModel.results![index];
                      return ListTile(
                        title: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          child: CachedNetworkImage(
                            maxWidthDiskCache: 1000,
                            maxHeightDiskCache: 1000,
                            progressIndicatorBuilder:
                                (context, url, progress) => Center(
                              child: mainCircularProgress(
                                value: progress.progress,
                              ),
                            ),
                            imageUrl:
                                'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => const Icon(Icons.error)
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  MovieDetailsView(movieId: movie.id),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else if (state is SearchMovieError) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
