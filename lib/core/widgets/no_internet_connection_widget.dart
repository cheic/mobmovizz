import 'package:flutter/material.dart';
import 'package:mobmovizz/l10n/app_localizations.dart';

/// Widget pour afficher l'état "Pas de connexion internet" avec icône animée
class NoInternetConnectionWidget extends StatefulWidget {
  final VoidCallback? onRetry;
  final EdgeInsets? padding;
  final double? iconSize;

  const NoInternetConnectionWidget({
    super.key,
    this.onRetry,
    this.padding,
    this.iconSize,
  });

  @override
  State<NoInternetConnectionWidget> createState() => _NoInternetConnectionWidgetState();
}

class _NoInternetConnectionWidgetState extends State<NoInternetConnectionWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    
    // Animation de pulsation pour l'icône
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Animation de rotation pour l'icône WiFi
    _rotationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeInOut,
    ));

    // Démarrer les animations en boucle
    _pulseController.repeat(reverse: true);
    _rotationController.repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);
    
    return Padding(
      padding: widget.padding ?? const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icône WiFi animée
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: AnimatedBuilder(
                  animation: _rotationAnimation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotationAnimation.value * 0.1, // Rotation légère
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.errorContainer.withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.colorScheme.error.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.wifi_off_rounded,
                          size: widget.iconSize ?? 64,
                          color: theme.colorScheme.error,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // Titre principal
          Text(
            localizations?.no_internet_connection ?? 'Pas de connexion internet',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          // Description
          Text(
            localizations?.check_your_connection ?? 'Vérifiez votre connexion et réessayez',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // Bouton de retry si fourni
          if (widget.onRetry != null)
            ElevatedButton.icon(
              onPressed: widget.onRetry,
              icon: Icon(
                Icons.refresh_rounded,
                size: 20,
              ),
              label: Text(
                localizations?.retry ?? 'Réessayer',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
        ],
      ),
    );
  }
}

/// Widget compact pour afficher dans une AppBar ou un espace restreint
class CompactNoInternetWidget extends StatefulWidget {
  final VoidCallback? onTap;

  const CompactNoInternetWidget({
    super.key,
    this.onTap,
  });

  @override
  State<CompactNoInternetWidget> createState() => _CompactNoInternetWidgetState();
}

class _CompactNoInternetWidgetState extends State<CompactNoInternetWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _blinkController;
  late Animation<double> _blinkAnimation;

  @override
  void initState() {
    super.initState();
    
    _blinkController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _blinkAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _blinkController,
      curve: Curves.easeInOut,
    ));

    _blinkController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);
    
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: theme.colorScheme.errorContainer.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: theme.colorScheme.error.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _blinkAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _blinkAnimation.value,
                  child: Icon(
                    Icons.wifi_off_rounded,
                    size: 16,
                    color: theme.colorScheme.error,
                  ),
                );
              },
            ),
            const SizedBox(width: 6),
            Text(
              localizations?.no_internet_connection ?? 'Pas de connexion',
              style: TextStyle(
                color: theme.colorScheme.onErrorContainer,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Service utilitaire pour vérifier la connexion internet
class InternetConnectionService {
  static bool _isConnected = true;
  static final List<VoidCallback> _listeners = [];

  static bool get isConnected => _isConnected;

  static void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  static void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  static void setConnectionStatus(bool connected) {
    if (_isConnected != connected) {
      _isConnected = connected;
      for (final listener in _listeners) {
        listener();
      }
    }
  }

  static void dispose() {
    _listeners.clear();
  }
}
