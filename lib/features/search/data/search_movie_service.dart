import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:mobmovizz/core/error/failure.dart';
import 'package:mobmovizz/core/network/api_service.dart';
import 'package:mobmovizz/core/services/localization_service.dart';
import 'package:mobmovizz/features/search/data/model/search_movie_model.dart';

class SearchMovieService {
  final ApiService _apiService;

  SearchMovieService(this._apiService);

  Future<Either<Failure, SearchMovieModel>> getMoviesFromKeyword(
      String keyword, {int page = 1, String? sortBy, int? year, BuildContext? context}) async {
    try {
      final params = {'query': keyword, 'page': page};
      if (sortBy != null) params['sort_by'] = sortBy;
      if (year != null) params['year'] = year.toString();
      
      final language = LocalizationService.getBestAvailableLanguage(context);
      
      final response = await _apiService.get(
        endPoint: 'search/movie', 
        params: params,
        language: language,
      );
      return Right(SearchMovieModel.fromJson(response.data));
    } catch (e) {
      return const Left(ServerFailure());
    }
  }
}
