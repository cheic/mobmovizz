part of 'search_movie_bloc.dart';

sealed class SearchMovieEvent extends Equatable {
  const SearchMovieEvent();

  @override
  List<Object> get props => [];
}


class FetchMovieEvent extends SearchMovieEvent {
  final String keyword;
  const FetchMovieEvent(this.keyword);
}