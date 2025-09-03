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

class FetchMoreMovieEvent extends SearchMovieEvent {
  final String keyword;
  final int currentPage;
  
  const FetchMoreMovieEvent(this.keyword, this.currentPage);
}

class FetchMovieWithFilterEvent extends SearchMovieEvent {
  final String keyword;
  final String sortBy;
  final int? year;

  const FetchMovieWithFilterEvent(this.keyword, this.sortBy, this.year);

  @override
  List<Object> get props => [keyword, sortBy, year ?? ''];
}