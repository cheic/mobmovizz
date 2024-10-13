import 'package:flutter/material.dart';
import 'package:mobmovizz/core/theme/colors.dart';
import 'package:mobmovizz/core/widgets/app_bar.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
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