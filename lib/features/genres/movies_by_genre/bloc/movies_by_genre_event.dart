abstract class MoviesByGenreEvent {}

class FetchMoviesByGenre extends MoviesByGenreEvent {
  final int genreId;
  FetchMoviesByGenre(this.genreId);
}