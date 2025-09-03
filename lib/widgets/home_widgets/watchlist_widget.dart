import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WatchlistWidget extends StatefulWidget {
  const WatchlistWidget({super.key});

  @override
  State<WatchlistWidget> createState() => _WatchlistWidgetState();
}

class _WatchlistWidgetState extends State<WatchlistWidget> {
  List<Map<String, dynamic>> _watchlist = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadWatchlist();
  }

  Future<void> _loadWatchlist() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('watchlist') ?? '[]';
    final List list = jsonDecode(jsonString);
    setState(() {
      _watchlist = List<Map<String, dynamic>>.from(list);
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: _loading
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ma Watchlist', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  if (_watchlist.isEmpty)
                    Text('Aucun film dans la watchlist'),
                  ..._watchlist.map((item) => ListTile(
                        title: Text(item['title'] ?? ''),
                        subtitle: item['reminderDate'] != null
                            ? Text('Rappel: ${item['reminderDate']}')
                            : null,
                      )),
                ],
              ),
      ),
    );
  }
}
