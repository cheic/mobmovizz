import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobmovizz/core/theme/theme_bloc.dart';
import 'package:mobmovizz/core/utils/app_preferences.dart';
import 'package:mobmovizz/core/widgets/navigation/nav_bar_cubit.dart';
import 'package:mobmovizz/features/genres/movies_by_genre/bloc/movies_by_genre_bloc.dart';
import 'package:mobmovizz/features/genres/movies_by_genre/data/movies_by_genre_service.dart';
import 'package:mobmovizz/features/genres/movies_genre_list/bloc/movie_genres_bloc.dart';
import 'package:mobmovizz/features/genres/movies_genre_list/data/service/movie_genre_list_service.dart';
import 'package:mobmovizz/features/home/popular_movies/bloc/popular_movies_bloc.dart';
import 'package:mobmovizz/features/home/popular_movies/data/service/popular_movies_service.dart';
import 'package:mobmovizz/features/home/top_rated/bloc/top_rated_bloc.dart';
import 'package:mobmovizz/features/home/top_rated/data/top_rated_service.dart';
import 'package:mobmovizz/features/home/upcomings/bloc/upcomings_bloc.dart';
import 'package:mobmovizz/features/home/upcomings/data/service/upcomings_service.dart';
import 'package:mobmovizz/features/movie_details/bloc/movie_details_bloc.dart';
import 'package:mobmovizz/features/movie_details/data/movie_details_service.dart';
import 'package:mobmovizz/features/search/bloc/search_movie_bloc.dart';
import 'package:mobmovizz/features/search/data/search_movie_service.dart';
import 'package:mobmovizz/features/watchlist/bloc/watchlist_bloc.dart';
import 'package:mobmovizz/main.dart';

class MockPopularMoviesService extends Mock implements PopularMoviesService {}

class MockUpcomingService extends Mock implements UpcomingService {}

class MockTopRatedService extends Mock implements TopRatedService {}

class MockMovieGenreListService extends Mock implements MovieGenreListService {}

class MockMoviesByGenreService extends Mock implements MoviesByGenreService {}

class MockMovieDetailsService extends Mock implements MovieDetailsService {}

class MockSearchMovieService extends Mock implements SearchMovieService {}

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final sharedPreferences = await SharedPreferences.getInstance();
    final appPreferences = AppPreferences(sharedPreferences);

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ThemeBloc(appPreferences)),
          BlocProvider(create: (_) => NavigationCubit()),
          BlocProvider(
            create: (_) => PopularMoviesBloc(MockPopularMoviesService()),
          ),
          BlocProvider(
            create: (_) => UpcomingsBloc(MockUpcomingService()),
          ),
          BlocProvider(
            create: (_) => TopRatedBloc(MockTopRatedService()),
          ),
          BlocProvider(
            create: (_) => MovieGenresBloc(MockMovieGenreListService()),
          ),
          BlocProvider(
            create: (_) => MoviesByGenreBloc(MockMoviesByGenreService()),
          ),
          BlocProvider(
            create: (_) => MovieDetailsBloc(MockMovieDetailsService()),
          ),
          BlocProvider(
            create: (_) => SearchMovieBloc(MockSearchMovieService()),
          ),
          BlocProvider(create: (_) => WatchlistBloc(appPreferences)),
        ],
        child: const MyApp(),
      ),
    );

    // Verify the app builds without ProviderNotFoundException
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
