import 'package:dartz/dartz.dart';
import 'package:mobmovizz/core/error/failure.dart';
import 'package:mobmovizz/core/network/api_service.dart';
import 'package:mobmovizz/features/movie_details/data/models/movie_details_model.dart';

class MovieDetailsService {
  final ApiService _apiService;

  MovieDetailsService(this._apiService);

  Future<Either<Failure, MovieDetailsModel>> getMovieDetails(int movieId) async {
    try {
      final response = await _apiService.get(endPoint: 'movie/$movieId');
      return Right(MovieDetailsModel.fromJson(response.data));
    } catch (e) {
      return  const Left(ServerFailure());
    }
  }
}