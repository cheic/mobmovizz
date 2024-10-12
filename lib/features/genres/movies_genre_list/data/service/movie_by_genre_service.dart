import 'package:dartz/dartz.dart';
import 'package:mobmovizz/core/error/failure.dart';
import 'package:mobmovizz/core/network/api_service.dart';
import 'package:mobmovizz/features/genres/movies_genre_list/data/model/movie_genres_list_model.dart';

class MovieByGenreService {
  final ApiService _apiService;

  MovieByGenreService(this._apiService);

  Future<Either<Failure, MovieGenresListModel>> getMovieGenres(
      int genreId) async {
    var params = {"with_genres": genreId};
    try {
      final response =
          await _apiService.get(endPoint: 'genre/movie/list', params: params);
      return Right(MovieGenresListModel.fromJson(response.data));
    } catch (e) {
      return const Left(ServerFailure());
    }
  }
}
