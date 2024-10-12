import 'package:flutter/material.dart';
import 'package:mobmovizz/features/genres/movies_genre_list/view/movie_genre_list_view.dart';

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

const List<Widget> bottomNavScreen = <Widget>[
  DiscoverView(),
  MovieGenreListView(),
  Text('Index 2: Search'),
  Text('Index 3: Favourite'),
];