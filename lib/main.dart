import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mobmovizz/core/di/injection.dart';
import 'package:mobmovizz/core/theme/colors.dart';
import 'package:mobmovizz/features/genres/movies_by_genre/bloc/movies_by_genre_bloc.dart';
import 'package:mobmovizz/features/genres/movies_by_genre/data/movies_by_genre_service.dart';
import 'package:mobmovizz/features/genres/movies_genre_list/bloc/movie_genres_bloc.dart';
import 'package:mobmovizz/features/genres/movies_genre_list/data/service/movie_genre_list_service.dart';
import 'package:mobmovizz/features/home/popular_movies/bloc/popular_movies_bloc.dart';
import 'package:mobmovizz/core/widgets/bottom_nav_items.dart';
import 'package:mobmovizz/core/widgets/navigation/nav_bar_cubit.dart';
import 'package:mobmovizz/core/widgets/navigation/nav_bar_items.dart';
import 'package:mobmovizz/core/widgets/navigation/nav_bar_state.dart';
import 'package:mobmovizz/features/home/upcomings/bloc/upcomings_bloc.dart';
import 'package:mobmovizz/features/home/upcomings/data/service/upcomings_service.dart';
import 'package:mobmovizz/features/movie_details/bloc/movie_details_bloc.dart';
import 'package:mobmovizz/features/movie_details/data/movie_details_service.dart';

import 'core/theme/text_theme.dart';
import 'core/theme/theme.dart';
import 'features/home/popular_movies/data/service/popular_movies_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initInjection();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    TextTheme textTheme = createTextTheme(context, "Roboto", "Roboto");
    MaterialTheme theme = MaterialTheme(textTheme);
    return MultiBlocProvider(
      providers: [
        BlocProvider<PopularMoviesBloc>(
          create: (context) => PopularMoviesBloc(GetIt.I<PopularMoviesService>())
            ..add(FetchPopularMovies()),
        ),
        BlocProvider<UpcomingsBloc>(
          create: (context) => UpcomingsBloc(GetIt.I<UpcomingService>())
            ..add(FetchUpcomings()),
        ),
        BlocProvider<NavigationCubit>(create: (BuildContext context) => NavigationCubit(),),
        BlocProvider(
          create: (context) => MovieGenresBloc(GetIt.I<MovieGenreListService>())
            ..add(FetchGenres()),
        ),
        BlocProvider(
          create: (context) => MoviesByGenreBloc(GetIt.I<MoviesByGenreService>()),
        ),
         BlocProvider(
          create: (context) => MovieDetailsBloc(GetIt.I<MovieDetailsService>()),
        ),
      ],
      child: MaterialApp(
        title: 'MobMovizz',
        debugShowCheckedModeBanner: false,
        theme: theme.light() ,
        darkTheme: theme.dark(),
        home:  const MyHomePage(title: '',),
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
      body: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          // Return the appropriate screen based on the selected navbar item
          return bottomNavScreen[state.index];
        },
      ),
        bottomNavigationBar: BlocConsumer<NavigationCubit, NavigationState>(
            builder: (context, state) {
              return BottomNavigationBar(
                items: bottomNavItems,
                currentIndex: state.index,
                selectedItemColor: Theme.of(context).colorScheme.primary,
                unselectedItemColor: Colors.grey,
                type: BottomNavigationBarType.fixed,
                backgroundColor: surfaceDim,
                elevation: 0,
                onTap: (index) => _onNavItemTapped(context, index),
              );
            },
            listener: (context, state) {}),
    );
  }

  // Handle tap logic in one place
  void _onNavItemTapped(BuildContext context, int index) {
    NavbarItem item = NavbarItem.values[index]; // Get NavbarItem from index
    BlocProvider.of<NavigationCubit>(context).getNavBarItem(item);
  }
}
