import 'package:flutter/material.dart';
import 'package:mobmovizz/core/theme/colors.dart';
import 'package:mobmovizz/core/widgets/app_bar.dart';

class SearchMovieView extends StatefulWidget {
  const SearchMovieView({super.key});

  @override
  State<SearchMovieView> createState() => _SearchMovieViewState();
}

class _SearchMovieViewState extends State<SearchMovieView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(title: 'MOBMOVIZZ'),
      backgroundColor: surfaceDim,
      body: Center(
        child: Text("COMING SOON",  style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white)),
      ),
    );
  }
}