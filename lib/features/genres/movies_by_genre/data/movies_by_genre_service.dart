import 'package:dartz/dartz.dart';
import 'package:mobmovizz/core/error/failure.dart';
import 'package:mobmovizz/core/network/api_service.dart';
import 'package:mobmovizz/features/genres/movies_by_genre/data/models/movie_by_genre_model.dart';

class MoviesByGenreService {
  final ApiService _apiService;

  MoviesByGenreService(this._apiService);

  Future<Either<Failure, MovieByGenreModel>> getMoviesByGenre(
      int genreId, {int page = 1}) async {
    var params = {"with_genres": genreId, "page": page,};
    try {
      final response =
          await _apiService.get(endPoint: 'discover/movie', params: params);
      return Right(MovieByGenreModel.fromJson(response.data));
    } catch (e) {
      return const Left(ServerFailure());
    }
  }
}
