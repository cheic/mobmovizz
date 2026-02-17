import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobmovizz/core/widgets/circular_progress.dart';
import 'package:mobmovizz/features/genres/movies_by_genre/bloc/movies_by_genre_bloc.dart';
import 'package:mobmovizz/features/genres/movies_by_genre/data/movies_by_genre_service.dart';
import 'package:mobmovizz/features/genres/movies_genre_list/view/movie_grid_view.dart';
import 'package:mobmovizz/features/movie_details/view/movie_details_view.dart';
import 'package:mobmovizz/l10n/app_localizations.dart';

class GenreSection extends StatelessWidget {
  final int genreId;
  final String genreName;
  const GenreSection(
      {super.key, required this.genreId, required this.genreName});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6), // Réduit le padding horizontal et vertical
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MoviesGridViewPage(
                        genreId: genreId,
                        genreName: genreName,
                      ),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      genreName,
                      style: const TextStyle(
                        fontSize: 18,
                        
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.double_arrow,
                     
                      size: 17,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        BlocProvider(
          create: (context) =>
              MoviesByGenreBloc(GetIt.I<MoviesByGenreService>())
                ..add(FetchMoviesByGenre(genreId)),
          child: BlocBuilder<MoviesByGenreBloc, MoviesByGenreState>(
            buildWhen: (previous, current) => current is MoviesByGenreLoaded,
            builder: (context, state) {
              if (state is MoviesByGenreLoading) {
                return Center(
                    child: SizedBox(
                  width: 50,
                  height: 50,
                  child: mainCircularProgress(),
                ));
              } else if (state is MoviesByGenreLoaded) {
                return SizedBox(
                  height: 200,
                  child: ListView.builder(
                    key: PageStorageKey<String>('genre_$genreId'),
                    scrollDirection: Axis.horizontal,
                    itemCount: state.movies.results?.length ?? 0,
                    itemBuilder: (context, index) {
                      final movie = state.movies.results![index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  MovieDetailsView(movieId: movie.id!),
                            ),
                          );
                        },
                        child: Container(
                          width: 140,
                          height: 200,
                          margin: index == 0 
                              ? const EdgeInsets.only(left: 16, right: 8) // Premier élément : 16 à gauche, 8 à droite
                              : const EdgeInsets.symmetric(horizontal: 8), // Autres éléments : 8 de chaque côté
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: (movie.posterPath != null && movie.posterPath!.isNotEmpty)
                                ? CachedNetworkImage(
                                    key: Key(movie.id.toString()),
                                    imageUrl:
                                        'https://image.tmdb.org/t/p/w500${movie.posterPath}',
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
                        ),
                      );
                    },
                  ),
                );
              } else if (state is MoviesByGenreError) {
                return Center(child: Text("${AppLocalizations.of(context)?.error ?? "Error"}: ${state.message}"));
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ],
    );
  }
}
