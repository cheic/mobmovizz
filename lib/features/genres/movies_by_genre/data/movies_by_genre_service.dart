import 'package:dartz/dartz.dart';
import 'package:mobmovizz/core/error/failure.dart';
import 'package:mobmovizz/core/network/api_service.dart';
import 'package:mobmovizz/features/home/popular_movies/data/models/popular_movie_model.dart';

class MoviesByGenreService {
  final ApiService _apiService;

  MoviesByGenreService(this._apiService);

  Future<Either<Failure, PopularMovieModel>> getMoviesByGenre(
      int genreId) async {
    var params = {"with_genres": genreId};
    try {
      final response =
          await _apiService.get(endPoint: 'movie', params: params);
      return Right(PopularMovieModel.fromJson(response.data));
    } catch (e) {
      return const Left(ServerFailure());
    }
  }
}
