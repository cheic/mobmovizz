import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:mobmovizz/core/error/failure.dart';
import 'package:mobmovizz/core/network/api_service.dart';
import 'package:mobmovizz/core/services/localization_service.dart';
import 'package:mobmovizz/features/genres/movies_by_genre/data/models/movie_by_genre_model.dart';

class MoviesByGenreService {
  final ApiService _apiService;
  final Map<String, Map<int, MovieByGenreModel>> _cache = {}; // Clé modifiée pour inclure les filtres

  MoviesByGenreService(this._apiService);

  Future<Either<Failure, MovieByGenreModel>> getMoviesByGenre({
    required int genreId,
    int page = 1,
    BuildContext? context,
  }) async {
    String cacheKey = 'genre_$genreId';
    
    // Check if this page for this genre is already in cache
    if (_cache.containsKey(cacheKey) && _cache[cacheKey]!.containsKey(page)) {
      return Right(_cache[cacheKey]![page]!);
    }

    var params = {
      "with_genres": genreId,
      "page": page,
      "sort_by": "popularity.desc", // Tri par popularité par défaut
    };

    try {
      final language = LocalizationService.getBestAvailableLanguage(context);
      
      final response = await _apiService.get(
        endPoint: 'discover/movie', 
        params: params,
        language: language,
      );
      
      // Create the model first
      final movieModel = MovieByGenreModel.fromJson(response.data);
      
      // Cache the model
      _cache.putIfAbsent(cacheKey, () => {})[page] = movieModel;
      
      return Right(movieModel);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  // NOUVELLE MÉTHODE pour le filtre par année
  Future<Either<Failure, MovieByGenreModel>> getMoviesByGenreWithYear({
    required int genreId,
    required int year,
    int page = 1,
    String sortBy = "popularity.desc",
    BuildContext? context,
  }) async {
    String cacheKey = 'genre_${genreId}_year_${year}_sort_$sortBy';
    
    // Check cache
    if (_cache.containsKey(cacheKey) && _cache[cacheKey]!.containsKey(page)) {
      return Right(_cache[cacheKey]![page]!);
    }

    var params = {
      "with_genres": genreId,
      "primary_release_year": year,
      "page": page,
      "sort_by": sortBy,
    };

    try {
      final language = LocalizationService.getBestAvailableLanguage(context);
      
      final response = await _apiService.get(
        endPoint: 'discover/movie', 
        params: params,
        language: language,
      );
      
      final movieModel = MovieByGenreModel.fromJson(response.data);
      
      // Cache the model
      _cache.putIfAbsent(cacheKey, () => {})[page] = movieModel;
      
      return Right(movieModel);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  // NOUVELLE MÉTHODE pour différents types de tri
  Future<Either<Failure, MovieByGenreModel>> getMoviesByGenreWithSort({
    required int genreId,
    required String sortBy,
    int? year,
    int page = 1,
    BuildContext? context,
  }) async {
    String cacheKey = year != null 
        ? 'genre_${genreId}_year_${year}_sort_$sortBy'
        : 'genre_${genreId}_sort_$sortBy';
    
    if (_cache.containsKey(cacheKey) && _cache[cacheKey]!.containsKey(page)) {
      return Right(_cache[cacheKey]![page]!);
    }

    var params = {
      "with_genres": genreId,
      "page": page,
      "sort_by": sortBy,
    };

    if (year != null) {
      params["primary_release_year"] = year;
    }

    try {
      final language = LocalizationService.getBestAvailableLanguage(context);
      
      final response = await _apiService.get(
        endPoint: 'discover/movie', 
        params: params,
        language: language,
      );
      
      final movieModel = MovieByGenreModel.fromJson(response.data);
      
      _cache.putIfAbsent(cacheKey, () => {})[page] = movieModel;
      
      return Right(movieModel);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}