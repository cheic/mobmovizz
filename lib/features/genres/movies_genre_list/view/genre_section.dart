import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobmovizz/core/widgets/circular_progress.dart';
import 'package:mobmovizz/features/genres/movies_by_genre/bloc/movies_by_genre_bloc.dart';
import 'package:mobmovizz/features/genres/movies_by_genre/data/movies_by_genre_service.dart';
import 'package:mobmovizz/features/genres/movies_genre_list/view/movie_grid_view.dart';
import 'package:mobmovizz/features/movie_details/view/movie_details_view.dart';


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
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MoviesGridViewPage(
                    genreId: genreId,
                    genreName: genreName,
                  ),
                ),
              );
            },
            child: Row(
              children: [
                Text(
                  genreName,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
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
                  height: 210,
                  child: ListView.builder(
                    key: PageStorageKey<String>('genre_$genreId'),
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
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
                          margin: const EdgeInsets.only(right: 12),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
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
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                );
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
