import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:mobmovizz/core/theme/theme_bloc.dart';
import 'package:mobmovizz/core/widgets/app_bar.dart';
import 'package:mobmovizz/core/widgets/_watchlist_reminder_switch.dart';
import 'package:mobmovizz/core/services/notification_service.dart';
import 'package:mobmovizz/l10n/app_localizations.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() => _packageInfo = info);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(context: context, title: AppLocalizations.of(context)?.settings ?? 'Settings'),
      body: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return ListView(
            padding: EdgeInsets.all(16),
            children: [
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.palette_outlined),
                      title: Text(AppLocalizations.of(context)?.theme ?? 'Theme'),
                      subtitle: Text(AppLocalizations.of(context)?.choose_your_preferred_theme ?? 'Choose your preferred theme'),
                    ),
                    
                    RadioListTile<int>(
                      title: Text(AppLocalizations.of(context)?.system_default ?? 'System Default'),
                      subtitle: Text(AppLocalizations.of(context)?.follow_system_theme ?? 'Follow system theme'),
                      value: 0,
                      groupValue: state.themeMode,
                      onChanged: (value) {
                        if (value != null) {
                          context.read<ThemeBloc>().add(ThemeChanged(value));
                        }
                      },
                    ),
                    
                    RadioListTile<int>(
                      title: Text(AppLocalizations.of(context)?.light_theme ?? 'Light Theme'),
                      subtitle: Text(AppLocalizations.of(context)?.always_use_light_theme ?? 'Always use light theme'),
                      value: 1,
                      groupValue: state.themeMode,
                      onChanged: (value) {
                        if (value != null) {
                          context.read<ThemeBloc>().add(ThemeChanged(value));
                        }
                      },
                    ),
                    
                    RadioListTile<int>(
                      title: Text(AppLocalizations.of(context)?.dark_theme ?? 'Dark Theme'),
                      subtitle: Text(AppLocalizations.of(context)?.always_use_dark_theme ?? 'Always use dark theme'),
                      value: 2,
                      groupValue: state.themeMode,
                      onChanged: (value) {
                        if (value != null) {
                          context.read<ThemeBloc>().add(ThemeChanged(value));
                        }
                      },
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 16),
              
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.notifications_outlined),
                      title: Text(AppLocalizations.of(context)?.notifications ?? 'Notifications'),
                      subtitle: Text(AppLocalizations.of(context)?.manage_notification_settings ?? 'Manage notification settings'),
                    ),
                    
                    WatchlistReminderSwitch(),
                    
                    // Vérifier permissions
                    ListTile(
                      leading: Icon(Icons.security),
                      title: Text(AppLocalizations.of(context)?.check_permissions ?? 'Check Permissions'),
                      subtitle: Text(AppLocalizations.of(context)?.check_permissions_status ?? 'Check permissions status'),
                      onTap: () async {
                        try {
                          final hasPerms = await NotificationService.hasPermissions();
                          
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(hasPerms 
                                  ? '✅ ${AppLocalizations.of(context)?.permissions_granted ?? "Permissions granted"}' 
                                  : '❌ ${AppLocalizations.of(context)?.permissions_missing ?? "Permissions missing"}'),
                                backgroundColor: hasPerms ? Colors.green : Colors.orange,
                              ),
                            );
                          }
                          
                          if (!hasPerms) {
                            final granted = await NotificationService.requestPermissions();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(granted 
                                    ? '✅ ${AppLocalizations.of(context)?.permissions_granted_now ?? "Permissions granted now"}' 
                                    : '❌ ${AppLocalizations.of(context)?.permissions_still_denied ?? "Permissions still denied"}'),
                                  backgroundColor: granted ? Colors.green : Colors.red,
                                ),
                              );
                            }
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('❌ ${AppLocalizations.of(context)?.error_occurred(e.toString()) ?? "Error: $e"}'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 16),
              
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.info_outline),
                      title: Text(AppLocalizations.of(context)?.about ?? 'About'),
                      subtitle: Text(AppLocalizations.of(context)?.app_information ?? 'App information'),
                    ),
                    
                    ListTile(
                      title: Text(AppLocalizations.of(context)?.version ?? 'Version'),
                      subtitle: Text(_packageInfo?.version ?? '...'),
                    ),
                    
                    ListTile(
                      title: Text(AppLocalizations.of(context)?.build ?? 'Build'),
                      subtitle: Text(_packageInfo?.buildNumber ?? '...'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
