import 'package:flutter/material.dart';
import 'package:mobmovizz/l10n/app_localizations.dart';

/// Widget wrapper pour gérer les erreurs de section de manière cohérente
/// Permet d'afficher un widget d'erreur compact sans bloquer le reste de l'interface
class SectionErrorWrapper extends StatelessWidget {
  final Widget child;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final String? sectionTitle;
  final double? height;

  const SectionErrorWrapper({
    Key? key,
    required this.child,
    this.errorMessage,
    this.onRetry,
    this.sectionTitle,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (errorMessage != null) {
      return Container(
        height: height ?? 200,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.error.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              size: 32,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 8),
            if (sectionTitle != null) ...[
              Text(
                sectionTitle!,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
            ],
            Text(
              errorMessage!.isNotEmpty 
                ? errorMessage! 
                : AppLocalizations.of(context)?.some_error_occurs ?? 'Some error occurred',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 16),
                label: Text(
                  AppLocalizations.of(context)?.retry ?? 'Retry',
                  style: const TextStyle(fontSize: 12),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.error,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
            ],
          ],
        ),
      );
    }

    return child;
  }
}

/// Widget d'erreur compact pour les sections individuelles
class CompactSectionError extends StatelessWidget {
  final String? errorMessage;
  final VoidCallback? onRetry;
  final String? title;
  final double height;

  const CompactSectionError({
    Key? key,
    this.errorMessage,
    this.onRetry,
    this.title,
    this.height = 120,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.error.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 24,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 4),
            if (title != null) ...[
              Text(
                title!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
            ],
            Text(
              errorMessage?.isNotEmpty == true 
                ? errorMessage! 
                : AppLocalizations.of(context)?.error ?? 'Error',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 6),
              TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 14),
                label: Text(
                  AppLocalizations.of(context)?.retry ?? 'Retry',
                  style: const TextStyle(fontSize: 11),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
