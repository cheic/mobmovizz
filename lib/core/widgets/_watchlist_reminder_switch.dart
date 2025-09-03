import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WatchlistReminderSwitch extends StatefulWidget {
  @override
  State<WatchlistReminderSwitch> createState() => WatchlistReminderSwitchState();
}

class WatchlistReminderSwitchState extends State<WatchlistReminderSwitch> {
  static const String _key = 'watchlist_reminder_enabled';
  bool _enabled = true;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _enabled = prefs.getBool(_key) ?? true;
      _loading = false;
    });
  }

  Future<void> _save(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Watchlist Reminders'),
      subtitle: Text('Get notified about movies to watch'),
      trailing: _loading
          ? SizedBox(width: 48, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
          : Switch(
              value: _enabled,
              onChanged: (value) {
                setState(() {
                  _enabled = value;
                });
                _save(value);
              },
            ),
    );
  }
}