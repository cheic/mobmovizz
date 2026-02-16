import 'package:dartz/dartz.dart';
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
import 'package:mobmovizz/features/home/popular_movies/data/models/popular_movie_model.dart';
import 'package:mobmovizz/features/home/popular_movies/data/service/popular_movies_service.dart';
import 'package:mobmovizz/features/home/top_rated/bloc/top_rated_bloc.dart';
import 'package:mobmovizz/features/home/top_rated/data/top_rated_service.dart';
import 'package:mobmovizz/features/home/upcomings/bloc/upcomings_bloc.dart';
import 'package:mobmovizz/features/home/upcomings/data/models/upcoming_model.dart';
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
  testWidgets('MyApp builds without ProviderNotFoundException', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final sharedPreferences = await SharedPreferences.getInstance();
    final appPreferences = AppPreferences(sharedPreferences);
    
    // Create mock services
    final mockPopularMoviesService = MockPopularMoviesService();
    final mockUpcomingService = MockUpcomingService();
    final mockTopRatedService = MockTopRatedService();
    final mockMovieGenreListService = MockMovieGenreListService();
    final mockMoviesByGenreService = MockMoviesByGenreService();
    final mockMovieDetailsService = MockMovieDetailsService();
    final mockSearchMovieService = MockSearchMovieService();
    
    // Stub the mock methods to return empty success responses
    when(() => mockPopularMoviesService.getPopularMovies(context: any(named: 'context')))
        .thenAnswer((_) async => Right(PopularMovieModel(
              page: 1,
              results: [],
              totalPages: 1,
              totalResults: 0,
            )));
    
    when(() => mockUpcomingService.getUpcomings(context: any(named: 'context')))
        .thenAnswer((_) async => Right(UpcomingModel(
              page: 1,
              results: [],
              totalPages: 1,
              totalResults: 0,
            )));
    
    when(() => mockTopRatedService.getTopRated(context: any(named: 'context')))
        .thenAnswer((_) async => Right(UpcomingModel(
              page: 1,
              results: [],
              totalPages: 1,
              totalResults: 0,
            )));

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ThemeBloc(appPreferences)),
          BlocProvider(create: (_) => NavigationCubit()),
          BlocProvider(
            create: (_) => PopularMoviesBloc(mockPopularMoviesService),
          ),
          BlocProvider(
            create: (_) => UpcomingsBloc(mockUpcomingService),
          ),
          BlocProvider(
            create: (_) => TopRatedBloc(mockTopRatedService),
          ),
          BlocProvider(
            create: (_) => MovieGenresBloc(mockMovieGenreListService),
          ),
          BlocProvider(
            create: (_) => MoviesByGenreBloc(mockMoviesByGenreService),
          ),
          BlocProvider(
            create: (_) => MovieDetailsBloc(mockMovieDetailsService),
          ),
          BlocProvider(
            create: (_) => SearchMovieBloc(mockSearchMovieService),
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
