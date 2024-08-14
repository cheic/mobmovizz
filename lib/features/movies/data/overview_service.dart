import 'package:dartz/dartz.dart';
import 'package:mobmovizz/core/error/failure.dart';
import 'package:mobmovizz/core/network/api_service.dart';
import 'package:mobmovizz/features/movies/data/models/discover_model.dart';

class DiscoverService {
  final ApiService _apiService;

  DiscoverService(this._apiService);

  Future<Either<Failure, DiscoverModel>> discover() async {
    try {
      final response = await _apiService.get(endPoint: 'discover/movie');
      return Right(DiscoverModel.fromJson(response.data));
    } catch (e) {
      return  const Left(ServerFailure());
    }
  }
}
