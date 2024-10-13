part of 'search_movie_bloc.dart';

sealed class SearchMovieState extends Equatable {
  const SearchMovieState();
  
  @override
  List<Object> get props => [];
}

final class SearchMovieInitial extends SearchMovieState {}
