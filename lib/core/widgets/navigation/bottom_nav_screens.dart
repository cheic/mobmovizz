import 'package:flutter/material.dart';
import 'package:mobmovizz/features/watchlist/view/watchlist_view.dart';
import 'package:mobmovizz/features/genres/movies_genre_list/view/movie_genre.dart';
import 'package:mobmovizz/features/home/popular_movies/view/overview_view.dart';
import 'package:mobmovizz/features/search/view/search_movie.dart';

List<Widget> bottomNavScreen = <Widget>[
  const DiscoverView(),
  const MovieGenre(),
  const SearchMovieView(),
  const WatchlistView(),
];