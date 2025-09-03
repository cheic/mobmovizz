import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mobmovizz/core/error/failure.dart';
import 'package:mobmovizz/features/genres/movies_genre_list/data/model/movie_genres_list_model.dart';
import 'package:mobmovizz/features/genres/movies_genre_list/data/service/movie_genre_list_service.dart';


part 'movie_genres_event.dart';
part 'movie_genres_state.dart';

class MovieGenresBloc extends Bloc<MovieGenresEvent, MovieGenresState> {
  final MovieGenreListService movieGenresService;
  MovieGenresBloc(this.movieGenresService) : super(MovieGenresInitial()) {
    on<MovieGenresEvent>(_onFetchMovieGenres);
  }

  void _onFetchMovieGenres(
      MovieGenresEvent movieGenresEvent, Emitter<MovieGenresState> emit) async {
    emit(MovieGenresLoading());
    final Either<Failure, MovieGenresListModel> failureOrGenres =
        await movieGenresService.getMovieGenres();
    emit(failureOrGenres.fold(
        (failure) => MovieGenresError(failure.message ?? "Some error occured when fetching genres"),
        (datas) => MovieGenresLoaded(datas)));
  }
}
