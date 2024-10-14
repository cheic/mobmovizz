import 'package:dartz/dartz.dart';
import 'package:mobmovizz/core/error/failure.dart';
import 'package:mobmovizz/core/network/api_service.dart';
import 'package:mobmovizz/features/search/data/model/search_movie_model.dart';

class SearchMovieService {
  final ApiService _apiService;

  SearchMovieService(this._apiService);

  Future<Either<Failure, SearchMovieModel>> getMoviesFromKeyword(
      String keyword) async {
    try {
      final response = await _apiService
          .get(endPoint: 'search/movie', params: {'query': keyword});
      return Right(SearchMovieModel.fromJson(response.data));
    } catch (e) {
      return const Left(ServerFailure());
    }
  }
}
