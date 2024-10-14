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
  SearchMovieBloc(this.searchMovieService) : super(SearchMovieInitial()) {
    on<FetchMovieEvent>(_onSearchMovie);
  }

  void _onSearchMovie(
      FetchMovieEvent event, Emitter<SearchMovieState> emit) async {
    emit(SearchMovieLoading());

    final Either<Failure, SearchMovieModel> failureOrData =
        await searchMovieService.getMoviesFromKeyword(event.keyword);

    failureOrData.fold(
        (failure) =>
            emit(SearchMovieError(failure.message ?? "Some error occurs")),
        (data) => emit(SearchMovieLoaded(data)));
  }
}
