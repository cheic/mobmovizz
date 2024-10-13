part of "movies_by_genre_bloc.dart";

abstract class MoviesByGenreEvent extends Equatable{
  const MoviesByGenreEvent();

  @override
  List<Object> get props => [];
}

class FetchMoviesByGenre extends MoviesByGenreEvent {
  final int genreId;
  const FetchMoviesByGenre(this.genreId);
}

class FetchMoreMoviesByGenre extends MoviesByGenreEvent {
  final int genreId;
  final int currentPage;

  const FetchMoreMoviesByGenre(this.genreId, this.currentPage);

  @override
  List<Object> get props => [genreId, currentPage];
}
