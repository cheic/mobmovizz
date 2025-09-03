part of 'search_movie_bloc.dart';

sealed class SearchMovieState extends Equatable {
  const SearchMovieState();

  @override
  List<Object> get props => [];
}

final class SearchMovieInitial extends SearchMovieState {}

final class SearchMovieLoading extends SearchMovieState {}

final class SearchMovieLoaded extends SearchMovieState {
  final SearchMovieModel searchMovieModel;
  final String keyword;
  final int currentPage;
  final int totalPages;

  const SearchMovieLoaded(
    this.searchMovieModel,
    this.keyword,
    this.currentPage,
    this.totalPages,
  );

  @override
  List<Object> get props => [
        searchMovieModel,
        keyword,
        currentPage,
        totalPages,
      ];
}

final class SearchMovieError extends SearchMovieState {
  final String message;
  const SearchMovieError(this.message);

  @override
  List<Object> get props => [message];
}
