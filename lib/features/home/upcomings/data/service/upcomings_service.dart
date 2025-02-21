import 'package:dartz/dartz.dart';
import 'package:mobmovizz/core/error/failure.dart';
import 'package:mobmovizz/core/network/api_service.dart';
import 'package:mobmovizz/features/home/upcomings/data/models/upcoming_model.dart';

class UpcomingService {
  final ApiService _apiService;

  UpcomingService(this._apiService);

    Future<Either<Failure, UpcomingModel>> getUpcomings() async {
    try {
      final response = await _apiService.get(endPoint: 'movie/upcoming');
      return Right(UpcomingModel.fromJson(response.data));
    } catch (e) {
      return  const Left(ServerFailure());
    }
  }
}
