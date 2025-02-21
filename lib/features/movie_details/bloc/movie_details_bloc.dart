import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mobmovizz/core/error/failure.dart';
import 'package:mobmovizz/features/movie_details/data/models/movie_details_model.dart';
import 'package:mobmovizz/features/movie_details/data/movie_details_service.dart';

part 'movie_details_event.dart';
part 'movie_details_state.dart';

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  final MovieDetailsService movieDetailsService;

  MovieDetailsBloc(this.movieDetailsService) : super(MovieDetailsInitial()) {
    on<FetchMovieDetails>(_onFetchMovieDetails);
  }

  void _onFetchMovieDetails(
      FetchMovieDetails event, Emitter<MovieDetailsState> emit) async {
    emit(MovieDetailsLoading());
    final Either<Failure, MovieDetailsModel> failureOrData =
        await movieDetailsService.getMovieDetails(event.movieId);

    failureOrData.fold(
        (failure) =>
            emit(MovieDetailsError(failure.message ?? "Something went wrong")),
        (data) => emit(MovieDetailsLoaded(data)));
  }
}
