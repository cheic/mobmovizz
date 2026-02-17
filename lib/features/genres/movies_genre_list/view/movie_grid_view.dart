import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobmovizz/core/widgets/app_bar.dart';
import 'package:mobmovizz/core/widgets/circular_progress.dart';
import 'package:mobmovizz/core/widgets/list_movie_item.dart';
import 'package:get_it/get_it.dart';
import 'package:mobmovizz/l10n/app_localizations.dart';
import 'package:mobmovizz/core/utils/app_preferences.dart';
import 'package:mobmovizz/core/widgets/filter_dialog.dart';
import 'package:mobmovizz/core/widgets/filter_header.dart';
import 'package:mobmovizz/core/common/filter_grid_list_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mobmovizz/features/genres/movies_by_genre/bloc/movies_by_genre_bloc.dart';
import 'package:mobmovizz/features/movie_details/view/movie_details_view.dart';

class MoviesGridViewPage extends StatefulWidget {
  final int genreId;
  final String genreName;

  const MoviesGridViewPage(
      {super.key, required this.genreId, required this.genreName});

  @override
  State<MoviesGridViewPage> createState() => _MoviesGridViewPageState();
}

class _MoviesGridViewPageState extends State<MoviesGridViewPage> {
  bool _isAtTop = true;
  final ScrollController _scrollController = ScrollController();
  late FilterGridListController _filterController;

  late AppPreferences _appPreferences;

  // Options de tri disponibles
  Map<String, String> _getSortOptions(BuildContext context) {
    return {
      'popularity.desc': AppLocalizations.of(context)?.popularity_desc ?? "Popularity Descending",
      'release_date.desc': AppLocalizations.of(context)?.release_date_desc ?? "Release Date Descending", 
      'vote_average.desc': AppLocalizations.of(context)?.vote_average_desc ?? "Rating Descending",
      'title.asc': AppLocalizations.of(context)?.title_asc ?? "Title Ascending",
    };
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<MoviesByGenreBloc>().add(FetchMoviesByGenre(widget.genreId));
    _appPreferences = GetIt.I<AppPreferences>();
    _filterController = FilterGridListController(
      isGridView: _appPreferences.getGridView(),
    );
    // Vérifier la position du scroll après le build initial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkScrollPosition();
    });
  }

  void _checkScrollPosition() {
    if (_scrollController.hasClients) {
      final isAtTop = _scrollController.position.pixels == 0;
      if (_isAtTop != isAtTop) {
        setState(() {
          _isAtTop = isAtTop;
        });
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Re-vérifier la position du scroll quand on revient sur la page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkScrollPosition();
    });
  }

  void _onScroll() {
    try {
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
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        final bloc = context.read<MoviesByGenreBloc>();
        if (bloc.state is MoviesByGenreLoaded) {
          final currentState = bloc.state as MoviesByGenreLoaded;
          if (currentState.currentPage < currentState.totalPages) {
            bloc.add(FetchMoreMoviesByGenre(
                widget.genreId, currentState.currentPage + 1));
          }
        }
      }
    } catch (e) {
      // Scroll error handled silently
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }


  void _applyFilters(String sortBy, int? year) {
  // L'état du filtre est géré par le contrôleur

    if (year != null) {
      // Filtre par année avec tri
      context.read<MoviesByGenreBloc>().add(
        FetchMoviesByGenreWithFilter(
          genreId: widget.genreId,
          year: year,
          sortBy: sortBy,
        ),
      );
    } else if (sortBy != "popularity.desc") {
      // Tri seulement
      context.read<MoviesByGenreBloc>().add(
        FetchMoviesByGenreWithSort(
          genreId: widget.genreId,
          sortBy: sortBy,
        ),
      );
    } else {
      // Reset aux valeurs par défaut
      context.read<MoviesByGenreBloc>().add(
        ResetMoviesFilter(widget.genreId),
      );
    }
  }

    void _resetFilters() {
     context.read<MoviesByGenreBloc>().add(
       ResetMoviesFilter(widget.genreId),
     );
  }

   @override
  Widget build(BuildContext context) {
    String title = widget.genreName;
    if (_filterController.selectedYear != null) {
      title += ' (${_filterController.selectedYear})';
    }
    if (_filterController.selectedSort != "popularity.desc") {
      title += ' • ${_getSortOptions(context)[_filterController.selectedSort]}';
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: mainAppBar(
        title: title,
        context: context,
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
                  _applyFilters(sortBy, year);
                },
                onReset: () {
                  setState(() {
                    _filterController.resetFilter();
                  });
                  _resetFilters();
                },
              );
            },
            onToggleView: () {
              setState(() {
                _filterController.toggleView();
                _appPreferences.setGridView(_filterController.isGridView);
              });
            },
          ),
        ],
      ),
      body: BlocBuilder<MoviesByGenreBloc, MoviesByGenreState>(
        builder: (context, state) {
          if (state is MoviesByGenreLoading) {
            return Center(
                child: SizedBox(
              width: 50,
              height: 50,
              child: mainCircularProgress(),
            ));
          } else if (state is MoviesByGenreLoaded) {
            return Padding(
              padding: const EdgeInsets.only(left: 8, right: 8), // Réduit le padding latéral
              child:
                  _filterController.isGridView ? _buildGridView(state) : _buildListView(state),
            );
          } else if (state is MoviesByGenreError) {
            return Center(child: Text("${AppLocalizations.of(context)?.error ?? "Error"}: ${state.message}", style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 16),));
          } else {
            return Center(child: Text(AppLocalizations.of(context)?.no_movies_available ?? "No movies available.", style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 16)));
          }
        },
      ),
      floatingActionButton: AnimatedScale(
        scale: _isAtTop ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: _isAtTop
            ? const SizedBox.shrink()
            : FloatingActionButton(
                onPressed: _scrollToTop,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Icon(
                  Icons.arrow_upward,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
      ),
    );
  }
 

 Widget _buildGridView(MoviesByGenreLoaded state) {
    return GridView.builder(
      controller: _scrollController,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: state.movies.results?.length ?? 0,
      itemBuilder: (context, index) {
        final movie = state.movies.results![index];
        return _buildMovieItem(movie);
      },
    );
  }

  Widget _buildListView(MoviesByGenreLoaded state) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: state.movies.results?.length ?? 0,
      itemBuilder: (context, index) {
        final movie = state.movies.results![index];
        return buildMovieListItem(context, movie);
      },
    );
  }

  Widget _buildMovieItem(dynamic movie) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MovieDetailsView(movieId: movie.id!),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: (movie.posterPath != null && movie.posterPath!.isNotEmpty)
            ? CachedNetworkImage(
                imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                placeholder: (context, url) => Center(
                    child: SizedBox(
                  width: 50,
                  height: 50,
                  child: mainCircularProgress(),
                )),
                errorWidget: (context, url, error) => Container(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  child: Icon(
                    Icons.image_outlined,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                    size: 50,
                  ),
                ),
                fit: BoxFit.cover,
              )
            : Container(
                color: Theme.of(context).colorScheme.surfaceContainer,
                child: Icon(
                  Icons.image_outlined,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                  size: 50,
                ),
              ),
      ),
    );
  }


}

