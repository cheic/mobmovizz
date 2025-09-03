import 'package:flutter/material.dart';

class RiveModel {
  final String artboard;
  final String stateMachineName;
  final String animationName;

  RiveModel({
    required this.artboard,
    required this.stateMachineName,
    required this.animationName,
  });
}

class NavItemModel {
  final String title;
  final RiveModel rive;
  final IconData icon;

  NavItemModel({
    required this.title,
    required this.rive,
    required this.icon,
  });
}