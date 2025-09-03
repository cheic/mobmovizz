import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobmovizz/core/error/failure.dart';
import 'package:mobmovizz/features/genres/movies_by_genre/data/models/movie_by_genre_model.dart';
import 'package:mobmovizz/features/genres/movies_by_genre/data/movies_by_genre_service.dart';

part 'movies_by_genre_event.dart';
part 'movies_by_genre_state.dart';

class MoviesByGenreBloc extends Bloc<MoviesByGenreEvent, MoviesByGenreState> {
  final MoviesByGenreService moviesByGenreService;
  int currentPage = 1;
  int totalPages = 1;
  bool _isLoading = false;
  
  // Variables pour gérer les filtres actifs
  int? _currentYear;
  String _currentSort = "popularity.desc";

  MoviesByGenreBloc(this.moviesByGenreService) : super(MoviesByGenreInitial()) {
    on<FetchMoviesByGenre>(_onFetchMoviesByGenre);
    on<FetchMoreMoviesByGenre>(_onFetchMoreMoviesByGenre);
    on<FetchMoviesByGenreWithFilter>(_onFetchMoviesByGenreWithFilter);
    on<FetchMoviesByGenreWithSort>(_onFetchMoviesByGenreWithSort);
    on<ResetMoviesFilter>(_onResetMoviesFilter);
  }

  void _onFetchMoviesByGenre(
    FetchMoviesByGenre event,
    Emitter<MoviesByGenreState> emit,
  ) async {
    if (_isLoading) return;

    _isLoading = true;
    _currentYear = null;
    _currentSort = "popularity.desc";
    emit(MoviesByGenreLoading());

    final Either<Failure, MovieByGenreModel> failureOrMovies =
        await moviesByGenreService.getMoviesByGenre(genreId: event.genreId);

    failureOrMovies.fold(
      (failure) {
        _isLoading = false;
        emit(MoviesByGenreError(failure.message ?? 'Some error occurred'));
      },
      (movies) {
        currentPage = 1;
        totalPages = movies.totalPages!;
        _isLoading = false;
        emit(MoviesByGenreLoaded(
          movies: movies,
          genreId: event.genreId,
          currentPage: currentPage,
          totalPages: totalPages,
        ));
      },
    );
  }

  void _onFetchMoreMoviesByGenre(
    FetchMoreMoviesByGenre event, 
    Emitter<MoviesByGenreState> emit
  ) async {
    if (_isLoading || currentPage >= totalPages) return;
    if (state is! MoviesByGenreLoaded) return;

    final currentState = state as MoviesByGenreLoaded;
    _isLoading = true;
    
    try {
      currentPage++;
      
      Either<Failure, MovieByGenreModel> failureOrMovies;
      
      // Utiliser la méthode appropriée selon les filtres actifs
      if (_currentYear != null) {
        failureOrMovies = await moviesByGenreService.getMoviesByGenreWithYear(
          genreId: event.genreId, 
          year: _currentYear!,
          page: currentPage,
          sortBy: _currentSort,
        );
      } else if (_currentSort != "popularity.desc") {
        failureOrMovies = await moviesByGenreService.getMoviesByGenreWithSort(
          genreId: event.genreId,
          sortBy: _currentSort,
          page: currentPage,
        );
      } else {
        failureOrMovies = await moviesByGenreService.getMoviesByGenre(
          genreId: event.genreId, 
          page: currentPage
        );
      }

      failureOrMovies.fold(
        (failure) {
          _isLoading = false;
          emit(MoviesByGenreError(failure.message ?? ''));
        },
        (movies) {
          final updatedMovies = MovieByGenreModel(
            page: movies.page,
            totalPages: movies.totalPages,
            results: [
              ...?currentState.movies.results,
              ...?movies.results
            ],
          );
          
          _isLoading = false;
          emit(MoviesByGenreLoaded(
            movies: updatedMovies,
            genreId: event.genreId,
            currentPage: currentPage,
            totalPages: movies.totalPages ?? totalPages,
          ));
        },
      );
    } catch (e) {
      _isLoading = false;
      emit(MoviesByGenreError(e.toString()));
    }
  }

  void _onFetchMoviesByGenreWithFilter(
    FetchMoviesByGenreWithFilter event,
    Emitter<MoviesByGenreState> emit,
  ) async {
    _isLoading = true;
    _currentYear = event.year;
    _currentSort = event.sortBy;
    emit(MoviesByGenreLoading());

    try {
      final Either<Failure, MovieByGenreModel> failureOrMovies =
          await moviesByGenreService.getMoviesByGenreWithYear(
        genreId: event.genreId,
        year: event.year,
        sortBy: event.sortBy,
      );

      failureOrMovies.fold(
        (failure) {
          _isLoading = false;
          emit(MoviesByGenreError(failure.message ?? 'Error loading filtered movies'));
        },
        (movies) {
          currentPage = 1;
          totalPages = movies.totalPages ?? 1;
          _isLoading = false;
          emit(MoviesByGenreLoaded(
            genreId: event.genreId,
            movies: movies,
            currentPage: currentPage,
            totalPages: totalPages,
          ));
        },
      );
    } catch (error) {
      _isLoading = false;
      emit(MoviesByGenreError(error.toString()));
    }
  }

  void _onFetchMoviesByGenreWithSort(
    FetchMoviesByGenreWithSort event,
    Emitter<MoviesByGenreState> emit,
  ) async {
    _isLoading = true;
    _currentSort = event.sortBy;
    _currentYear = event.year;
    emit(MoviesByGenreLoading());

    try {
      final Either<Failure, MovieByGenreModel> failureOrMovies =
          await moviesByGenreService.getMoviesByGenreWithSort(
        genreId: event.genreId,
        sortBy: event.sortBy,
        year: event.year,
      );

      failureOrMovies.fold(
        (failure) {
          _isLoading = false;
          emit(MoviesByGenreError(failure.message ?? 'Error loading sorted movies'));
        },
        (movies) {
          currentPage = 1;
          totalPages = movies.totalPages ?? 1;
          _isLoading = false;
          emit(MoviesByGenreLoaded(
            genreId: event.genreId,
            movies: movies,
            currentPage: currentPage,
            totalPages: totalPages,
          ));
        },
      );
    } catch (error) {
      _isLoading = false;
      emit(MoviesByGenreError(error.toString()));
    }
  }

  void _onResetMoviesFilter(
    ResetMoviesFilter event,
    Emitter<MoviesByGenreState> emit,
  ) async {
    _currentYear = null;
    _currentSort = "popularity.desc";
    add(FetchMoviesByGenre(event.genreId));
  }
}