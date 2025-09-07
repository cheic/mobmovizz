import 'package:flutter/material.dart';
import 'package:mobmovizz/core/widgets/connection_status_app_bar.dart';
import 'package:mobmovizz/core/widgets/no_internet_connection_widget.dart';
import 'package:mobmovizz/core/widgets/state_widgets.dart';
import 'package:mobmovizz/l10n/app_localizations.dart';

/// Example screen demonstrating various internet connection status widgets
/// This screen shows how to integrate connection status indicators throughout the app
class ConnectionStatusExampleScreen extends StatelessWidget {
  const ConnectionStatusExampleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      // AppBar avec indicateur de connexion intégré
      appBar: connectionStatusAppBar(
        context: context,
        title: 'Connection Status Demo',
        showConnectionStatus: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Simulate refresh action
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(localizations.check_your_connection),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Title
            Text(
              'Internet Connection Widgets',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),

            // Example 1: Full NoInternetConnectionWidget
            _buildExampleSection(
              context,
              title: '1. Full Connection Widget',
              description: 'Complete widget with animations and detailed messaging',
              child: const NoInternetConnectionWidget(),
            ),

            const SizedBox(height: 32),

            // Example 2: Compact Version
            _buildExampleSection(
              context,
              title: '2. Compact Connection Widget',
              description: 'Space-efficient version for limited UI space',
              child: const CompactNoInternetWidget(),
            ),

            const SizedBox(height: 32),

            // Example 3: Enhanced NoInternetWidget
            _buildExampleSection(
              context,
              title: '3. Enhanced State Widget',
              description: 'Improved version of the original widget with animations',
              child: const NoInternetWidget(),
            ),

            const SizedBox(height: 32),

            // Example 4: Custom Implementation
            _buildExampleSection(
              context,
              title: '4. Custom Connection Banner',
              description: 'Custom implementation using InternetConnectionService',
              child: _buildCustomConnectionBanner(context),
            ),

            const SizedBox(height: 32),

            // Usage Instructions
            _buildUsageSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleSection(
    BuildContext context, {
    required String title,
    required String description,
    required Widget child,
  }) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: child,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomConnectionBanner(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    // Utilise un StatefulWidget simple pour démonstration
    return StatefulBuilder(
      builder: (context, setState) {
        final isConnected = InternetConnectionService.isConnected;

        if (isConnected) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.wifi,
                  color: Colors.green,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Connected',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.error.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.colorScheme.error.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.wifi_off,
                color: theme.colorScheme.error,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                localizations.no_internet_connection,
                style: TextStyle(
                  color: theme.colorScheme.error,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUsageSection(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Usage Instructions',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            _buildUsageItem(
              context,
              icon: Icons.app_settings_alt,
              title: 'ConnectionStatusAppBar',
              description: 'Replace regular AppBar with this enhanced version for automatic connection status display',
            ),
            const SizedBox(height: 12),
            _buildUsageItem(
              context,
              icon: Icons.widgets,
              title: 'NoInternetConnectionWidget',
              description: 'Use in error states or empty screens when internet connection is required',
            ),
            const SizedBox(height: 12),
            _buildUsageItem(
              context,
              icon: Icons.compress,
              title: 'CompactNoInternetWidget',
              description: 'Perfect for limited space areas like bottom sheets or small cards',
            ),
            const SizedBox(height: 12),
            _buildUsageItem(
              context,
              icon: Icons.stream,
              title: 'InternetConnectionService',
              description: 'Use the service for custom implementations and real-time connection monitoring',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsageItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
