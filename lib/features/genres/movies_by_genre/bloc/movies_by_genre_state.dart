import 'package:mobmovizz/features/home/popular_movies/data/models/popular_movie_model.dart';

abstract class MoviesByGenreState {}

class MoviesByGenreInitial extends MoviesByGenreState {}

class MoviesByGenreLoading extends MoviesByGenreState {}

class MoviesByGenreLoaded extends MoviesByGenreState {
  final PopularMovieModel movies;
  MoviesByGenreLoaded(this.movies);
}

class MoviesByGenreError extends MoviesByGenreState {
  final String message;
  MoviesByGenreError(this.message);
}