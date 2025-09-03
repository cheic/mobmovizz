import 'package:flutter/material.dart';
import '../common/app_dimensions.dart';
import 'app_spacing.dart';

/// Widget for displaying empty states with consistent styling
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;
  final double iconSize;
  final Color? iconColor;

  const EmptyStateWidget({
    Key? key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
    this.iconSize = AppDimensions.iconSizeXLarge,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Padding(
        padding: AppPadding.allXl,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: iconColor ?? theme.colorScheme.onSurface.withOpacity(0.5),
            ),
            AppSpacing.verticalLg,
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              AppSpacing.verticalSm,
              Text(
                subtitle!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              AppSpacing.verticalXl,
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

/// Widget for displaying error states with retry functionality
class ErrorStateWidget extends StatelessWidget {
  final String title;
  final String? message;
  final VoidCallback? onRetry;
  final IconData icon;
  final double iconSize;

  const ErrorStateWidget({
    Key? key,
    this.title = 'Oops! Something went wrong',
    this.message,
    this.onRetry,
    this.icon = Icons.error_outline,
    this.iconSize = AppDimensions.iconSizeXLarge,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Padding(
        padding: AppPadding.allXl,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: theme.colorScheme.error,
            ),
            AppSpacing.verticalLg,
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              AppSpacing.verticalSm,
              Text(
                message!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              AppSpacing.verticalXl,
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  padding: AppPadding.buttonDefault,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Widget for displaying loading states with consistent styling
class LoadingStateWidget extends StatelessWidget {
  final String? message;
  final double? value; // For determinate progress
  final bool showMessage;

  const LoadingStateWidget({
    Key? key,
    this.message,
    this.value,
    this.showMessage = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Padding(
        padding: AppPadding.allXl,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (value != null)
              CircularProgressIndicator(
                value: value,
                strokeWidth: 3,
              )
            else
              const CircularProgressIndicator(
                strokeWidth: 3,
              ),
            if (showMessage && message != null) ...[
              AppSpacing.verticalLg,
              Text(
                message!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Widget for no internet connection state
class NoInternetWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const NoInternetWidget({
    Key? key,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.wifi_off,
      title: 'No Internet Connection',
      subtitle: 'Please check your connection and try again',
      action: onRetry != null
          ? ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                padding: AppPadding.buttonDefault,
              ),
            )
          : null,
    );
  }
}

/// Widget for search results not found
class NoSearchResultsWidget extends StatelessWidget {
  final String searchTerm;
  final VoidCallback? onClearSearch;

  const NoSearchResultsWidget({
    Key? key,
    required this.searchTerm,
    this.onClearSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.search_off,
      title: 'No results found',
      subtitle: 'No movies found for "$searchTerm".\nTry a different search term.',
      action: onClearSearch != null
          ? TextButton(
              onPressed: onClearSearch,
              child: const Text('Clear Search'),
            )
          : null,
    );
  }
}
