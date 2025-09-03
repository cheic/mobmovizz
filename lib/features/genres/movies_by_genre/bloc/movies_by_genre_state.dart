
part of "movies_by_genre_bloc.dart";

abstract class MoviesByGenreState  extends Equatable{
  const MoviesByGenreState();
  @override
  List<Object> get props => [];
}

class MoviesByGenreInitial extends MoviesByGenreState {}

class MoviesByGenreLoading extends MoviesByGenreState {}

class MoviesByGenreLoaded extends MoviesByGenreState {
  final MovieByGenreModel movies;
  final int genreId;
  final int currentPage;
  final int totalPages; 

  const MoviesByGenreLoaded({
    required this.movies,
    required this.genreId, 
    required this.currentPage,
    required this.totalPages,
  });

  @override
  List<Object> get props => [movies, genreId, currentPage, totalPages];
}

class MoviesByGenreError extends MoviesByGenreState {
  final String message;
 const MoviesByGenreError(this.message);
}