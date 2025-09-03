import 'package:get_it/get_it.dart';
import 'package:mobmovizz/core/network/api_service.dart';
import 'package:mobmovizz/core/network/dio_factory.dart';
import 'package:mobmovizz/core/theme/theme_bloc.dart';
import 'package:mobmovizz/core/utils/app_preferences.dart';
import 'package:mobmovizz/features/watchlist/watchlist.dart';

import 'package:mobmovizz/features/genres/movies_by_genre/data/movies_by_genre_service.dart';
import 'package:mobmovizz/features/genres/movies_genre_list/data/service/movie_genre_list_service.dart';
import 'package:mobmovizz/features/home/popular_movies/bloc/popular_movies_bloc.dart';
import 'package:mobmovizz/features/home/popular_movies/data/service/popular_movies_service.dart';
import 'package:mobmovizz/features/home/top_rated/data/top_rated_service.dart';
import 'package:mobmovizz/features/home/upcomings/data/service/upcomings_service.dart';
import 'package:mobmovizz/features/movie_details/data/movie_details_service.dart';
import 'package:mobmovizz/features/search/data/search_movie_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt sl = GetIt.instance;

void setupSingleton() {
  sl.allowReassignment = true;
}

Future<void> initInjection() async {
  //SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // AppPreferences instance
  final appPreferences = AppPreferences(sharedPreferences);
  sl.registerLazySingleton<AppPreferences>(() => appPreferences);

  // Blocs
  sl.registerFactory(() => ThemeBloc(sl<AppPreferences>()));
  sl.registerFactory(() => WatchlistBloc(sl<AppPreferences>()));

  // Core
  sl.registerFactory<DioFactory>(() => DioFactory());

  //Dio
  final dio = await sl<DioFactory>().getDio();
  sl.registerLazySingleton<ApiService>(() => ApiService(dio));

  sl.registerLazySingleton(() => PopularMoviesService(sl<ApiService>()));
  sl.registerLazySingleton(() => UpcomingService(sl<ApiService>()));
  sl.registerLazySingleton(() => TopRatedService(sl<ApiService>()));
  sl.registerLazySingleton(() => MovieGenreListService(sl<ApiService>()));
  sl.registerLazySingleton(() => PopularMoviesBloc(sl<PopularMoviesService>()));
  sl.registerLazySingleton(() => MoviesByGenreService(sl<ApiService>()));
  sl.registerLazySingleton(() => MovieDetailsService(sl<ApiService>()));
  sl.registerLazySingleton(() => SearchMovieService(sl<ApiService>()));
}

void resetAppModule() {
  sl.reset();
}
