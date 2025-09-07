import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mobmovizz/l10n/app_localizations.dart';
import 'dart:async';

/// Enhanced AppBar with integrated internet connection status indicator
/// Shows a compact connection status banner when offline
class ConnectionStatusAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final IconThemeData? iconTheme;
  final List<Widget>? actions;
  final bool centerTitle;
  final bool showConnectionStatus;

  const ConnectionStatusAppBar({
    Key? key,
    required this.title,
    this.iconTheme,
    this.actions,
    this.centerTitle = false,
    this.showConnectionStatus = true,
  }) : super(key: key);

  @override
  State<ConnectionStatusAppBar> createState() => _ConnectionStatusAppBarState();

  @override
  Size get preferredSize {
    // Dynamic height based on connection status
    return const Size.fromHeight(kToolbarHeight + 32); // Extra space for connection banner
  }
}

class _ConnectionStatusAppBarState extends State<ConnectionStatusAppBar>
    with TickerProviderStateMixin {
  bool _isConnected = true;
  late StreamSubscription<InternetConnectionStatus> _connectivitySubscription;
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkInitialConnectivity();
    _listenToConnectivityChanges();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _checkInitialConnectivity() async {
    try {
      final hasConnection = await InternetConnectionChecker.instance.hasConnection;
      _updateConnectionStatus(hasConnection ? InternetConnectionStatus.connected : InternetConnectionStatus.disconnected);
    } catch (e) {
      // Handle error silently
    }
  }

  void _listenToConnectivityChanges() {
    _connectivitySubscription = InternetConnectionChecker.instance.onStatusChange.listen(
      _updateConnectionStatus,
    );
  }

  void _updateConnectionStatus(InternetConnectionStatus status) {
    final wasConnected = _isConnected;
    final isNowConnected = status == InternetConnectionStatus.connected;

    if (wasConnected != isNowConnected) {
      setState(() {
        _isConnected = isNowConnected;
      });

      if (!_isConnected && widget.showConnectionStatus) {
        _slideController.forward();
        _pulseController.repeat(reverse: true);
      } else {
        _slideController.reverse();
        _pulseController.stop();
      }
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Standard AppBar
        AppBar(
          iconTheme: widget.iconTheme ?? IconThemeData(
            color: theme.appBarTheme.foregroundColor,
          ),
          title: Text(
            widget.title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: theme.appBarTheme.foregroundColor,
            ),
          ),
          centerTitle: widget.centerTitle,
          backgroundColor: theme.appBarTheme.backgroundColor,
          actions: widget.actions,
          elevation: 0,
        ),

        // Connection Status Banner
        if (widget.showConnectionStatus)
          SlideTransition(
            position: _slideAnimation,
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _isConnected ? 1.0 : _pulseAnimation.value,
                  child: Container(
                    width: double.infinity,
                    height: _isConnected ? 0 : 32,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error,
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.error.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: _isConnected
                        ? const SizedBox.shrink()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.wifi_off,
                                color: theme.colorScheme.onError,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                localizations?.no_internet_connection ?? 'No internet connection',
                                style: TextStyle(
                                  color: theme.colorScheme.onError,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

/// Factory function to create a ConnectionStatusAppBar with consistent styling
ConnectionStatusAppBar connectionStatusAppBar({
  required String title,
  required BuildContext context,
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
    showConnectionStatus: showConnectionStatus,
  );
}
