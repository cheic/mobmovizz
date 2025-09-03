import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:mobmovizz/core/error/failure.dart';
import 'package:mobmovizz/core/network/api_service.dart';
import 'package:mobmovizz/core/services/localization_service.dart';
import 'package:mobmovizz/features/home/upcomings/data/models/upcoming_model.dart';

class UpcomingService {
  final ApiService _apiService;

  UpcomingService(this._apiService);

    Future<Either<Failure, UpcomingModel>> getUpcomings({BuildContext? context}) async {
    try {
      final language = LocalizationService.getBestAvailableLanguage(context);
      
      final response = await _apiService.get(
        endPoint: 'movie/upcoming',
        language: language,
      );
      return Right(UpcomingModel.fromJson(response.data));
    } catch (e) {
      return  const Left(ServerFailure());
    }
  }
}
