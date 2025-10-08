import 'package:flutter/material.dart';

/// Enhanced AppBar with integrated internet connection status indicator
class ConnectionStatusAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconThemeData? iconTheme;
  final List<Widget>? actions;
  final bool centerTitle;

  const ConnectionStatusAppBar({
    Key? key,
    required this.title,
    this.iconTheme,
    this.actions,
    this.centerTitle = false,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      iconTheme: this.iconTheme,
      title: Text(this.title),
      centerTitle: this.centerTitle,
      backgroundColor: theme.appBarTheme.backgroundColor,
      actions: this.actions,
      elevation: 0,
    );
  }
}

/// Factory function to create a ConnectionStatusAppBar with consistent styling
ConnectionStatusAppBar connectionStatusAppBar({
  required BuildContext context,
  required String title,
  IconThemeData? iconTheme,
  List<Widget>? actions,
  bool centerTitle = false,
  bool showConnectionStatus = true,
}) {
  return ConnectionStatusAppBar(
    title: title,
    iconTheme: iconTheme,
    actions: actions,
    centerTitle: centerTitle,
  );
}