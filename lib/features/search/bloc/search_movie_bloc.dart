import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mobmovizz/core/error/failure.dart';
import 'package:mobmovizz/features/search/data/model/search_movie_model.dart';
import 'package:mobmovizz/features/search/data/search_movie_service.dart';

part 'search_movie_event.dart';
part 'search_movie_state.dart';

class SearchMovieBloc extends Bloc<SearchMovieEvent, SearchMovieState> {
  final SearchMovieService searchMovieService;
  int currentPage = 1;
  int totalPages = 1;
  SearchMovieBloc(this.searchMovieService) : super(SearchMovieInitial()) {
    on<FetchMovieEvent>(_onSearchMovie);
    on<FetchMoreMovieEvent>(_onFetchMoreMoviesBySearch);
    on<FetchMovieWithFilterEvent>(_onSearchMovieWithFilter);


  }

    void _onSearchMovieWithFilter(
      FetchMovieWithFilterEvent event, Emitter<SearchMovieState> emit) async {
    emit(SearchMovieLoading());

    final Either<Failure, SearchMovieModel> failureOrData =
        await searchMovieService.getMoviesFromKeyword(
          event.keyword,
          sortBy: event.sortBy,
          year: event.year,
        );

    failureOrData.fold(
        (failure) =>
            emit(SearchMovieError(failure.message ?? "Some error occurs")),
        (data) {
      currentPage = 1;
      totalPages = data.totalPages!;
      emit(SearchMovieLoaded(
        data,
        event.keyword,
        currentPage,
        totalPages,
      ));
    });
  }

  void _onSearchMovie(
      FetchMovieEvent event, Emitter<SearchMovieState> emit) async {
    emit(SearchMovieLoading());

    final Either<Failure, SearchMovieModel> failureOrData =
        await searchMovieService.getMoviesFromKeyword(event.keyword);

    failureOrData.fold(
        (failure) =>
            emit(SearchMovieError(failure.message ?? "Some error occurs")),
        (data) {
      currentPage = 1;
      totalPages = data.totalPages!;
      emit(SearchMovieLoaded(
        data,
        event.keyword,
        currentPage,
        totalPages,
      ));
    });
  }

  void _onFetchMoreMoviesBySearch(
      FetchMoreMovieEvent event, Emitter<SearchMovieState> emit) async {
    if (currentPage < totalPages) {
      currentPage++;

      final Either<Failure, SearchMovieModel> failureOrMovies =
          await searchMovieService.getMoviesFromKeyword(event.keyword,
              page: currentPage);

      failureOrMovies.fold(
        (failure) => emit(SearchMovieError(failure.message ?? '')),
        (movies) {
          if (state is SearchMovieLoaded) {
            final currentState = state as SearchMovieLoaded;
            final updatedMovies = SearchMovieModel(
              page: movies.page,
              totalPages: movies.totalPages,
              results: [
                ...?currentState.searchMovieModel.results,
                ...?movies.results
              ],
            );
            emit(SearchMovieLoaded(
              updatedMovies,
              currentState.keyword,
              currentPage,
              totalPages,
            ));
          }
        },
      );
    }
  }
}
