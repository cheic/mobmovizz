import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mobmovizz/core/di/injection.dart';
import 'package:mobmovizz/core/theme/app_themes.dart';
import 'package:mobmovizz/core/theme/theme_bloc.dart';
import 'package:mobmovizz/core/services/notification_service.dart';
import 'package:mobmovizz/core/utils/app_preferences.dart';
import 'package:mobmovizz/core/widgets/navigation/bottom_nav_screens.dart';
import 'package:mobmovizz/core/widgets/navigation/nav_bar_cubit.dart';
import 'package:mobmovizz/core/widgets/navigation/nav_bar_items.dart';
import 'package:mobmovizz/core/widgets/navigation/nav_items.dart';
import 'package:mobmovizz/core/widgets/navigation/rive_bottom_nav_bar.dart';
import 'package:mobmovizz/features/genres/movies_by_genre/bloc/movies_by_genre_bloc.dart';
import 'package:mobmovizz/features/genres/movies_by_genre/data/movies_by_genre_service.dart';
import 'package:mobmovizz/features/genres/movies_genre_list/bloc/movie_genres_bloc.dart';
import 'package:mobmovizz/features/genres/movies_genre_list/data/service/movie_genre_list_service.dart';
import 'package:mobmovizz/features/home/popular_movies/bloc/popular_movies_bloc.dart';
import 'package:mobmovizz/features/home/popular_movies/data/service/popular_movies_service.dart';
import 'package:mobmovizz/features/home/top_rated/data/top_rated_service.dart';
import 'package:mobmovizz/features/home/upcomings/bloc/upcomings_bloc.dart';
import 'package:mobmovizz/features/home/top_rated/bloc/top_rated_bloc.dart';
import 'package:mobmovizz/features/home/upcomings/data/service/upcomings_service.dart';
import 'package:mobmovizz/features/movie_details/bloc/movie_details_bloc.dart';
import 'package:mobmovizz/features/movie_details/data/movie_details_service.dart';
import 'package:mobmovizz/features/search/bloc/search_movie_bloc.dart';
import 'package:mobmovizz/features/search/data/search_movie_service.dart';
import 'package:mobmovizz/features/watchlist/bloc/watchlist_bloc.dart';
import 'package:mobmovizz/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notification service
  try {
    await NotificationService.init();
    await NotificationService.requestPermissions();
  } catch (e) {
    // Handle notification initialization errors silently in production
  }

  await initInjection();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => GetIt.I<ThemeBloc>()),
        BlocProvider(create: (_) => NavigationCubit()),
           BlocProvider<PopularMoviesBloc>(
          create: (context) =>
              PopularMoviesBloc(GetIt.I<PopularMoviesService>())
                ..add(FetchPopularMovies()),
        ),
        BlocProvider<UpcomingsBloc>(
          create: (context) =>
              UpcomingsBloc(GetIt.I<UpcomingService>())..add(FetchUpcomings()),
        ),
        BlocProvider<TopRatedBloc>(
          create: (context) =>
              TopRatedBloc(GetIt.I<TopRatedService>())..add(FetchTopRated()),
        ),
        BlocProvider<NavigationCubit>(
          create: (BuildContext context) => NavigationCubit(),
        ),
        BlocProvider(
          create: (context) => MovieGenresBloc(GetIt.I<MovieGenreListService>())
            ..add(FetchGenres()),
        ),
        BlocProvider(
          create: (context) =>
              MoviesByGenreBloc(GetIt.I<MoviesByGenreService>()),
        ),
        BlocProvider(
          create: (context) => MovieDetailsBloc(GetIt.I<MovieDetailsService>()),
        ),
        BlocProvider(
          create: (context) => SearchMovieBloc(GetIt.I<SearchMovieService>()),
        ),
        BlocProvider(create: (context) => WatchlistBloc(GetIt.I<AppPreferences>())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) => MaterialApp(
        title: 'MobMovizz',
        theme: AppThemes.lightTheme,
        darkTheme: AppThemes.darkTheme,
        themeMode: state.mode,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const MyHomePage(
          title: '',
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: context.watch<NavigationCubit>().state.index,
        children: bottomNavScreen,
      ),
      bottomNavigationBar: RiveBottomNavBar(
        currentIndex: context.watch<NavigationCubit>().state.index,
        onTap: (index) {
          context.read<NavigationCubit>().getNavBarItem(NavbarItem.values[index]);
        },
        items: getNavItems(context),
      ),
    );
  }
}
