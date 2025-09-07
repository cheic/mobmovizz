import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobmovizz/core/common/filter_grid_list_controller.dart';
import 'package:mobmovizz/core/theme/colors.dart';
import 'package:mobmovizz/core/utils/constants.dart';
import 'package:mobmovizz/core/widgets/app_bar.dart';
import 'package:mobmovizz/core/widgets/circular_progress.dart';
import 'package:mobmovizz/core/widgets/filter_dialog.dart';
import 'package:mobmovizz/core/widgets/filter_header.dart';
import 'package:mobmovizz/core/widgets/list_movie_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mobmovizz/features/movie_details/view/movie_details_view.dart';
import 'package:mobmovizz/features/search/bloc/search_movie_bloc.dart';
import 'package:mobmovizz/l10n/app_localizations.dart';

class SearchMovieView extends StatefulWidget {
  const SearchMovieView({super.key});

  @override
  _SearchMovieView createState() => _SearchMovieView();
}

class _SearchMovieView extends State<SearchMovieView> {
  final ScrollController _scrollController = ScrollController();
  bool _isAtTop = true;
  final TextEditingController _searchController = TextEditingController();
  late FilterGridListController _filterController;
  
  Map<String, String> _getSortOptions(BuildContext context) {
    return {
      "popularity.desc": AppLocalizations.of(context)?.popularity_desc ?? "Popularity ↓",
      "popularity.asc": AppLocalizations.of(context)?.popularity_asc ?? "Popularity ↑",
      "release_date.desc": AppLocalizations.of(context)?.release_date_desc ?? "Newest First",
      "release_date.asc": AppLocalizations.of(context)?.release_date_asc ?? "Oldest First",
      "vote_average.desc": AppLocalizations.of(context)?.vote_average_desc ?? "Highest Rated",
      "vote_average.asc": AppLocalizations.of(context)?.vote_average_asc ?? "Lowest Rated",
      "title.asc": AppLocalizations.of(context)?.title_asc ?? "Title A-Z",
      "title.desc": AppLocalizations.of(context)?.title_desc ?? "Title Z-A",
    };
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _filterController = FilterGridListController();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == 0) {
      if (!_isAtTop) {
        setState(() {
          _isAtTop = true;
        });
      }
    } else {
      if (_isAtTop) {
        setState(() {
          _isAtTop = false;
        });
      }
    }
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      final bloc = context.read<SearchMovieBloc>();
      if (bloc.state is SearchMovieLoaded) {
        final currentState = bloc.state as SearchMovieLoaded;
        if (currentState.currentPage < currentState.totalPages) {
          bloc.add(FetchMoreMovieEvent(
              currentState.keyword, currentState.currentPage + 1));
        }
      }
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(
        context: context,
        title: Constants.mobmovizz,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onSurface),
        widgets: [
          FilterHeader(
            isGridView: _filterController.isGridView,
            isFiltered: _filterController.isFiltered,
            onFilter: () {
              FilterDialog.show(
                context: context,
                sortOptions: _getSortOptions(context),
                initialSort: _filterController.selectedSort,
                initialYear: _filterController.selectedYear,
                onApply: (String sortBy, int? year) {
                  setState(() {
                    _filterController.setFilter(sort: sortBy, year: year);
                  });
                  // Déclenche la recherche filtrée
                  final keyword = _searchController.text;
                  if (keyword.isNotEmpty) {
                    context.read<SearchMovieBloc>().add(
                      FetchMovieWithFilterEvent(keyword, sortBy, year)
                    );
                  }
                },
                onReset: () {
                  setState(() {
                    _filterController.resetFilter();
                  });
                  // Reset la recherche filtrée
                  final keyword = _searchController.text;
                  if (keyword.isNotEmpty) {
                    context.read<SearchMovieBloc>().add(
                      FetchMovieEvent(keyword)
                    );
                  }
                },
              );
            },
            onToggleView: () {
              setState(() {
                _filterController.toggleView();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 16),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)?.search_for_movies ?? 'Search for movies...',
                hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6), fontSize: 16),
                prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainer,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.outline, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                ),
              ),
              onChanged: (value) {
                setState(() {}); // Pour mettre à jour l'icône clear
              },
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
                  return Center(child: Text(AppLocalizations.of(context)?.search_for_a_movie ?? 'Search for a movie'));
                } else if (state is SearchMovieLoading) {
                  return Center(child: mainCircularProgress());
                } else if (state is SearchMovieLoaded) {
                  if (_filterController.isGridView) {
                    return GridView.builder(
                      controller: _scrollController,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                      ),
                      itemCount: state.searchMovieModel.results?.length,
                      itemBuilder: (context, index) {
                        final movie = state.searchMovieModel.results![index];
                        return GestureDetector(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                            child: movie.posterPath == null || movie.posterPath!.isEmpty
                                ? Container(
                                    color: Theme.of(context).colorScheme.surfaceContainer,
                                    child: Icon(
                                      Icons.image_outlined,
                                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                                      size: 50,
                                    ),
                                  )
                                : CachedNetworkImage(
                                    maxWidthDiskCache: 1000,
                                    maxHeightDiskCache: 1000,
                                    progressIndicatorBuilder: (context, url, progress) => Center(
                                          child: mainCircularProgress(
                                            value: progress.progress,
                                          ),
                                        ),
                                    imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) => Container(
                                      color: Theme.of(context).colorScheme.surfaceContainer,
                                      child: Icon(
                                        Icons.image_outlined,
                                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                                        size: 50,
                                      ),
                                    )),
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => MovieDetailsView(movieId: movie.id),
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else {
                    // Vue liste inspirée de movie_grid_view.dart
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: state.searchMovieModel.results?.length ?? 0,
                      itemBuilder: (context, index) {
                        final movie = state.searchMovieModel.results![index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => MovieDetailsView(movieId: movie.id),
                              ),
                            );
                          },
                          child: buildMovieListItem(context, movie),
                        );
                      },
                    );
                  }
                } else if (state is SearchMovieError) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                return Container();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: AnimatedOpacity(
        opacity: _isAtTop ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: FloatingActionButton(
          onPressed: _scrollToTop,
          backgroundColor: royalBlueDerived,
          child: const Icon(
            Icons.arrow_upward,
            color: snow,
          ),
        ),
      ),
    );
  }
}
