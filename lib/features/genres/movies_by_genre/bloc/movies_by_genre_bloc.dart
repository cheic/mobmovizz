import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobmovizz/core/error/failure.dart';
import 'package:mobmovizz/features/genres/movies_by_genre/data/models/movie_by_genre_model.dart';
import 'package:mobmovizz/features/genres/movies_by_genre/data/movies_by_genre_service.dart';

part 'movies_by_genre_event.dart';
part 'movies_by_genre_state.dart';

class MoviesByGenreBloc extends Bloc<MoviesByGenreEvent, MoviesByGenreState> {
  final MoviesByGenreService moviesByGenreService;
  int currentPage = 1;
  int totalPages = 1;

  MoviesByGenreBloc(this.moviesByGenreService) : super(MoviesByGenreInitial()) {
    on<FetchMoviesByGenre>(_onFetchMoviesByGenre);
    on<FetchMoreMoviesByGenre>(_onFetchMoreMoviesByGenre);
  }

  void _onFetchMoviesByGenre(
    FetchMoviesByGenre event,
    Emitter<MoviesByGenreState> emit,
  ) async {
    emit(MoviesByGenreLoading());

    final Either<Failure, MovieByGenreModel> failureOrMovies =
        await moviesByGenreService.getMoviesByGenre(event.genreId, page: 1);

    failureOrMovies.fold( 
      (failure) =>
          emit(MoviesByGenreError(failure.message ?? 'Some error occurred')),
      (movies) {
        currentPage = 1;
        totalPages = movies.totalPages!; // Set total pages
        emit(MoviesByGenreLoaded(
          movies: movies,
          genreId: event.genreId,
          currentPage: currentPage,
          totalPages: totalPages,
        ));
      },
    );
  }

  void _onFetchMoreMoviesByGenre(
      FetchMoreMoviesByGenre event, Emitter<MoviesByGenreState> emit) async {
    if (currentPage < totalPages) {
      currentPage++; // Increment current page for next load

      final Either<Failure, MovieByGenreModel> failureOrMovies =
          await moviesByGenreService.getMoviesByGenre(event.genreId,
              page: currentPage);

      failureOrMovies.fold(
        (failure) => emit(MoviesByGenreError(failure.message ?? '')),
        (movies) {
          if (state is MoviesByGenreLoaded) {
            final currentState = state as MoviesByGenreLoaded;
            final updatedMovies = MovieByGenreModel(
              page: movies.page,
              totalPages: movies.totalPages,
              results: [
                ...?currentState.movies.results,
                ...?movies.results
              ], // Append new movies
            );
            emit(MoviesByGenreLoaded(
              movies: updatedMovies,
              genreId: currentState.genreId, // Keep track of genreId
              currentPage: currentPage,
              totalPages: totalPages,
            ));
          }
        },
      );
    }
  }
}
