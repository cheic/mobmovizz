part of 'movies_by_genre_bloc.dart';

abstract class MoviesByGenreEvent extends Equatable {
  const MoviesByGenreEvent();

  @override
  List<Object?> get props => [];
}

class FetchMoviesByGenre extends MoviesByGenreEvent {
  final int genreId;

  const FetchMoviesByGenre(this.genreId);

  @override
  List<Object> get props => [genreId];
}

class FetchMoreMoviesByGenre extends MoviesByGenreEvent {
  final int genreId;
  final int page;

  const FetchMoreMoviesByGenre(this.genreId, this.page);

  @override
  List<Object> get props => [genreId, page];
}

class FetchMoviesByGenreWithFilter extends MoviesByGenreEvent {
  final int genreId;
  final int year;
  final String sortBy;

  const FetchMoviesByGenreWithFilter({
    required this.genreId,
    required this.year,
    this.sortBy = "popularity.desc",
  });

  @override
  List<Object> get props => [genreId, year, sortBy];
}

class FetchMoviesByGenreWithSort extends MoviesByGenreEvent {
  final int genreId;
  final String sortBy;
  final int? year;

  const FetchMoviesByGenreWithSort({
    required this.genreId,
    required this.sortBy,
    this.year,
  });

  @override
  List<Object?> get props => [genreId, sortBy, year];
}

class ResetMoviesFilter extends MoviesByGenreEvent {
  final int genreId;

  const ResetMoviesFilter(this.genreId);

  @override
  List<Object> get props => [genreId];
}