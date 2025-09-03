part of 'movie_details_bloc.dart';

sealed class MovieDetailsState extends Equatable {
  const MovieDetailsState();
  
  @override
  List<Object> get props => [];
}

final class MovieDetailsInitial extends MovieDetailsState {}

final class MovieDetailsLoading extends MovieDetailsState {}

final class MovieDetailsLoaded extends MovieDetailsState {
  final MovieDetailsModel movieDetailsModel;
  final VideoResultsModel videoResultsModel;
  final MovieProvider movieProvider;
  const MovieDetailsLoaded(this.movieDetailsModel, this.videoResultsModel, this.movieProvider);

  @override
  List<Object> get props => [movieDetailsModel, videoResultsModel, movieProvider];
}

class MovieDetailsError extends MovieDetailsState {
  final String message;

  const MovieDetailsError(this.message);

  @override
  List<Object> get props => [message];
}