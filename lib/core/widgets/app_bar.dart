import 'package:flutter/material.dart';

AppBar mainAppBar({
  required String title, 
  IconThemeData? iconTheme, 
  List<Widget>? widgets, 
  bool centerTitle = false,
  required BuildContext context,
}) {
  return AppBar(
    iconTheme: iconTheme ?? IconThemeData(
      color: Theme.of(context).appBarTheme.foregroundColor,
    ),
    title: Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.w600, 
        color: Theme.of(context).appBarTheme.foregroundColor,
      ),
    ),
    centerTitle: centerTitle,
    backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
    actions: widgets,
  );
}
