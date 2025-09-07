import 'package:flutter/material.dart';
import 'package:mobmovizz/l10n/app_localizations.dart';
import 'package:mobmovizz/core/widgets/state_widgets.dart';

/// Widget intelligent pour gérer différents types d'erreurs
/// avec des messages et icônes appropriés selon le contexte
class ErrorHandlerWidget extends StatelessWidget {
  final String? errorMessage;
  final VoidCallback? onRetry;
  final String? customTitle;
  final IconData? customIcon;

  const ErrorHandlerWidget({
    Key? key,
    this.errorMessage,
    this.onRetry,
    this.customTitle,
    this.customIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    // Détermine le message d'erreur approprié
    String displayMessage;
    IconData errorIcon;
    
    if (customTitle != null && customIcon != null) {
      // Utilise les valeurs personnalisées si fournies
      displayMessage = customTitle!;
      errorIcon = customIcon!;
    } else if (errorMessage == null || errorMessage!.isEmpty) {
      // Erreur générique
      displayMessage = localizations?.some_error_occurs ?? 'Some error occurs';
      errorIcon = Icons.error_outline;
    } else if (_isNetworkError(errorMessage!)) {
      // Erreur de connexion réseau
      displayMessage = localizations?.no_internet_connection ?? 'No internet connection';
      errorIcon = Icons.wifi_off;
    } else if (_isServerError(errorMessage!)) {
      // Erreur serveur
      displayMessage = localizations?.error ?? 'Server error';
      errorIcon = Icons.dns_outlined;
    } else {
      // Autre erreur avec message spécifique
      displayMessage = '${localizations?.error ?? 'Error'}: $errorMessage';
      errorIcon = Icons.error_outline;
    }

    return ErrorStateWidget(
      icon: errorIcon,
      title: displayMessage,
      message: errorMessage?.isNotEmpty == true ? errorMessage : null,
      onRetry: onRetry,
    );
  }

  /// Vérifie si l'erreur est liée au réseau
  bool _isNetworkError(String errorMessage) {
    final networkKeywords = [
      'network',
      'connection',
      'internet',
      'timeout',
      'unreachable',
      'offline',
      'connectivity',
      'dns',
      'host',
    ];
    
    final lowerMessage = errorMessage.toLowerCase();
    return networkKeywords.any((keyword) => lowerMessage.contains(keyword));
  }

  /// Vérifie si l'erreur est liée au serveur
  bool _isServerError(String errorMessage) {
    final serverKeywords = [
      'server',
      'internal',
      '500',
      '502',
      '503',
      '504',
      'gateway',
      'service unavailable',
      'bad gateway',
    ];
    
    final lowerMessage = errorMessage.toLowerCase();
    return serverKeywords.any((keyword) => lowerMessage.contains(keyword));
  }
}

/// Widget spécialisé pour les erreurs d'images
class ImageErrorWidget extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  final VoidCallback? onRetry;

  const ImageErrorWidget({
    Key? key,
    this.url,
    this.width,
    this.height,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Container(
      width: width,
      height: height,
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 8),
          Text(
            localizations?.error ?? 'Image error',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(localizations?.retry ?? 'Retry'),
            ),
          ],
        ],
      ),
    );
  }
}

/// Widget compact pour les erreurs dans les listes
class CompactErrorWidget extends StatelessWidget {
  final String? errorMessage;
  final VoidCallback? onRetry;

  const CompactErrorWidget({
    Key? key,
    this.errorMessage,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations?.error ?? 'Error',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                if (errorMessage?.isNotEmpty == true)
                  Text(
                    errorMessage!,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          if (onRetry != null)
            IconButton(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              tooltip: localizations?.retry ?? 'Retry',
            ),
        ],
      ),
    );
  }
}
