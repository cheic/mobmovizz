import 'package:flutter/material.dart';
import 'package:mobmovizz/features/favorites/view/favorites_view.dart';
import 'package:mobmovizz/features/genres/movies_genre_list/view/movie_genre_list_view.dart';
import 'package:mobmovizz/features/search/view/seach_movie.dart';

import '../../features/home/popular_movies/view/overview_view.dart';


class NavItemModel{
  final String title;
  final RiveModel rive;

  NavItemModel({
    required this.title,
    required this.rive
  });
}

class RiveModel {
}
List<BottomNavigationBarItem> bottomNavItems = const <BottomNavigationBarItem>[
  BottomNavigationBarItem(
    icon: Icon(Icons.home_outlined),
    label: 'Home',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.grid_3x3),
    label: 'Genre',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.search_outlined),
    label: 'Search',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.favorite_outline),
    label: 'Favourite',
  ),
];

List<Widget> bottomNavScreen = <Widget>[
  const DiscoverView(),
  const MovieGenreListView(),
  SearchMovieView(),
  const FavoritesView(),
];