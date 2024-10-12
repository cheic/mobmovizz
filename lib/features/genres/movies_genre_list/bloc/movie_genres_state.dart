part of 'movie_genres_bloc.dart';

sealed class MovieGenresState extends Equatable {
  const MovieGenresState();

  @override
  List<Object> get props => [];
}

final class MovieGenresInitial extends MovieGenresState {}

final class MovieGenresLoading extends MovieGenresState {}

final class MovieGenresLoaded extends MovieGenresState {
  final MovieGenresListModel movieGenresListModel;

  const MovieGenresLoaded(this.movieGenresListModel);

  @override
  List<Object> get props => [movieGenresListModel];
}

class MovieGenresError extends MovieGenresState {
  final String message;

  const MovieGenresError(this.message);

  @override
  List<Object> get props => [message];
}