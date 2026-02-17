import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobmovizz/core/utils/constants.dart';
import 'package:mobmovizz/core/widgets/app_bar.dart';
import 'package:mobmovizz/core/widgets/circular_progress.dart';
import 'package:mobmovizz/features/genres/movies_genre_list/bloc/movie_genres_bloc.dart';
import 'package:mobmovizz/features/genres/movies_genre_list/view/genre_section.dart';
import 'package:mobmovizz/l10n/app_localizations.dart';

class MovieGenre extends StatefulWidget {
  const MovieGenre({super.key});

  @override
  _MovieGenreState createState() => _MovieGenreState();
}

class _MovieGenreState extends State<MovieGenre>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: mainAppBar(context: context, title: Constants.mobmovizz),
      body: BlocBuilder<MovieGenresBloc, MovieGenresState>(
        builder: (context, state) {
          if (state is MovieGenresLoading) {
            return Center(
                child: Center(
                    child: SizedBox(
              width: 50,
              height: 50,
              child: mainCircularProgress(),
            )));
          } else if (state is MovieGenresLoaded) {
            if (state.movieGenresListModel.genres?.isEmpty ?? true) {
              return Center(child: Text(AppLocalizations.of(context)?.no_genres_available ?? "No genres available.")); 
            }
            return ListView.builder(
              // Add a key to preserve scroll position
              key: const PageStorageKey<String>('movie_genres_list'),
              cacheExtent: 1000,
              itemCount: state.movieGenresListModel.genres!.length,
              itemBuilder: (context, index) {
                final genre = state.movieGenresListModel.genres![index];
                return Padding(
                  padding: EdgeInsets.only(
                      bottom:
                          index == state.movieGenresListModel.genres!.length - 1
                              ? 0
                              : 8.0), // Réduit de 16.0 à 8.0
                  child: GenreSection(
                    key: Key('genre_${genre.id}'),
                    genreId: genre.id!,
                    genreName: genre.name!,
                  ),
                );
              },
            );
          } else if (state is MovieGenresError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 60,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Oups !',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Search for genres'));
          }
        },
      ),
    );
  }
}
