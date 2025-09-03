import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mobmovizz/core/error/failure.dart';
import 'package:mobmovizz/features/home/popular_movies/data/service/popular_movies_service.dart';
import 'package:mobmovizz/features/home/popular_movies/data/models/popular_movie_model.dart';

part 'popular_movies_event.dart';
part 'popular_movies_state.dart';

class PopularMoviesBloc extends Bloc<PopularMoviesEvent, PopularMoviesState> {
  final PopularMoviesService discoverService;
  PopularMoviesBloc(this.discoverService) : super(PopularMoviesInitial()) {
    on<PopularMoviesEvent>(_onFetchMovies);
  }

  void _onFetchMovies(PopularMoviesEvent discoverEvent,
      Emitter<PopularMoviesState> emit) async {
    emit(PopularMoviesLoading());
    
    BuildContext? context;
    if (discoverEvent is FetchPopularMovies) {
      context = discoverEvent.context;
    }
    
    final Either<Failure, PopularMovieModel> failureOrMovies =
        await discoverService.getPopularMovies(context: context);
    emit(failureOrMovies.fold(
        (failure) => PopularMoviesError(failure.message ?? ""),
        (data) => PopularMoviesLoaded(data)));
  }
}
