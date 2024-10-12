import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobmovizz/core/error/failure.dart';
import 'package:mobmovizz/features/genres/movies_by_genre/bloc/movies_by_genre_event.dart';
import 'package:mobmovizz/features/genres/movies_by_genre/bloc/movies_by_genre_state.dart';
import 'package:mobmovizz/features/genres/movies_by_genre/data/movies_by_genre_service.dart';
import 'package:mobmovizz/features/home/popular_movies/data/models/popular_movie_model.dart';

class MoviesByGenreBloc extends Bloc<MoviesByGenreEvent, MoviesByGenreState> {
  final MoviesByGenreService moviesByGenreService;

  MoviesByGenreBloc(this.moviesByGenreService) : super(MoviesByGenreInitial()) {
    on<FetchMoviesByGenre>(_onFetchMoviesByGenre);
  }

  void _onFetchMoviesByGenre(
    FetchMoviesByGenre event,
    Emitter<MoviesByGenreState> emit,
  ) async {
    emit(MoviesByGenreLoading());
   
      final Either<Failure, PopularMovieModel> failureOrMovies = await moviesByGenreService.getMoviesByGenre(event.genreId);
      emit(failureOrMovies.fold((failure) => MoviesByGenreError(failure.message ?? 'Some error occurs'), (datas) => MoviesByGenreLoaded(datas)));
  }
}