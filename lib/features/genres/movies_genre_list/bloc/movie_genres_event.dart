part of 'movie_genres_bloc.dart';

abstract class MovieGenresEvent extends Equatable {
  const MovieGenresEvent();

  @override
  List<Object> get props => [];
}

class FetchGenres extends MovieGenresEvent {}
