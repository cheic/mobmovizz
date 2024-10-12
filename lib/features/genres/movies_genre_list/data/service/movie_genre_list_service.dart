import 'package:dartz/dartz.dart';
import 'package:mobmovizz/core/error/failure.dart';
import 'package:mobmovizz/core/network/api_service.dart';
import 'package:mobmovizz/features/genres/movies_genre_list/data/model/movie_genres_list_model.dart';

class MovieGenreListService {
  final ApiService _apiService;

  MovieGenreListService(this._apiService);

  Future<Either<Failure, MovieGenresListModel>> getMovieGenres() async {
    try {
      final response = await _apiService.get(endPoint: 'genre/movie/list');
      return Right(MovieGenresListModel.fromJson(response.data));
    } catch (e) {
      return  const Left(ServerFailure());
    }
  }
}
