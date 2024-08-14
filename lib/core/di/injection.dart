import 'package:get_it/get_it.dart';
import 'package:mobmovizz/core/network/api_service.dart';
import 'package:mobmovizz/core/network/dio_factory.dart';
import 'package:mobmovizz/core/utils/app_preferences.dart';
import 'package:mobmovizz/features/movies/bloc/bloc/overview_bloc.dart';
import 'package:mobmovizz/features/movies/data/overview_service.dart';
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

  sl.registerLazySingleton(() => DiscoverService(sl<ApiService>()));
  sl.registerLazySingleton(() => DiscoverBloc(sl<DiscoverService>()));
  print('ALL IS REGISTRED');
}

void resetAppModule() {
  sl.reset();
}
