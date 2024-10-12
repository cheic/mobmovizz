import 'package:flutter/material.dart';
import 'package:mobmovizz/core/theme/colors.dart';

AppBar mainAppBar({required String title, List<Widget>? widgets}) {
  return AppBar(
    title: Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
    ),
    centerTitle: false,
    backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
    flexibleSpace: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            surfaceDim,
            surfaceDim.withAlpha(255),
            surfaceDim.withAlpha(255),
            surfaceDim.withAlpha(230),
            surfaceDim.withAlpha(150),
            surfaceDim.withAlpha(0),
          ],
        ),
      ),
    ),
    elevation: 0,
  );
}
