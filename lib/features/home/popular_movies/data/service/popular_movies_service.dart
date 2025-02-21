import 'package:dartz/dartz.dart';
import 'package:mobmovizz/core/error/failure.dart';
import 'package:mobmovizz/core/network/api_service.dart';
import 'package:mobmovizz/features/home/popular_movies/data/models/popular_movie_model.dart';

class PopularMoviesService {
  final ApiService _apiService;

  PopularMoviesService(this._apiService);

  Future<Either<Failure, PopularMovieModel>> getPopularMovies() async {
    try {
      final response = await _apiService.get(endPoint: 'movie/popular');
      return Right(PopularMovieModel.fromJson(response.data));
    } catch (e) {
      return  const Left(ServerFailure());
    }
  }
}
