import 'package:get_it/get_it.dart';
import 'package:mobmovizz/core/network/api_service.dart';
import 'package:mobmovizz/core/network/dio_factory.dart';
import 'package:mobmovizz/core/utils/app_preferences.dart';
import 'package:mobmovizz/features/genres/movies_genre_list/data/service/movie_genre_list_service.dart';
import 'package:mobmovizz/features/home/popular_movies/bloc/popular_movies_bloc.dart';
import 'package:mobmovizz/features/home/popular_movies/data/service/popular_movies_service.dart';
import 'package:mobmovizz/features/home/upcomings/data/service/upcomings_service.dart';
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

  // Core
  sl.registerFactory<DioFactory>(() => DioFactory());

  //Dio
  final dio = await sl<DioFactory>().getDio();
  sl.registerLazySingleton<ApiService>(() => ApiService(dio));

  sl.registerLazySingleton(() => PopularMoviesService(sl<ApiService>()));
  sl.registerLazySingleton(() => UpcomingService(sl<ApiService>()));
   sl.registerLazySingleton(() => MovieGenreListService(sl<ApiService>()));
  sl.registerLazySingleton(() => PopularMoviesBloc(sl<PopularMoviesService>()));

}

void resetAppModule() {
  sl.reset();
}
