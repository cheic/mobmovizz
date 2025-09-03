import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:mobmovizz/core/error/failure.dart';
import 'package:mobmovizz/core/network/api_service.dart';
import 'package:mobmovizz/core/services/localization_service.dart';
import 'package:mobmovizz/features/movie_details/data/models/movie_details_model.dart';
import 'package:mobmovizz/features/movie_details/data/models/movie_provider_model.dart';
import 'package:mobmovizz/features/movie_details/data/models/video_model.dart';

class MovieDetailsService {
  final ApiService _apiService;

  MovieDetailsService(this._apiService);

  Future<Either<Failure, MovieDetailsModel>> getMovieDetails(
      int movieId, {BuildContext? context}) async {
    try {
      final language = LocalizationService.getBestAvailableLanguage(context);
      
      final response = await _apiService.get(
        endPoint: 'movie/$movieId',
        language: language,
      );
      return Right(MovieDetailsModel.fromJson(response.data));
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  Future<Either<Failure, VideoResultsModel>> getMovieVideo(int movieId, {BuildContext? context}) async {
    try {
      final language = LocalizationService.getBestAvailableLanguage(context);
      
      final response = await _apiService.get(
        endPoint: 'movie/$movieId/videos',
        language: language,
      );
      return Right(VideoResultsModel.fromJson(response.data));
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

    Future<Either<Failure, MovieProvider>> getProviders(int movieId, {BuildContext? context}) async {
    try {
      final language = LocalizationService.getBestAvailableLanguage(context);
      
      final response = await _apiService.get(
        endPoint: 'movie/$movieId/watch/providers',
        language: language,
      );
      return Right(MovieProvider.fromJson(response.data));
    } catch (e) {
      return const Left(ServerFailure());
    }
  }
}
