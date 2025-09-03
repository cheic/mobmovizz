import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:mobmovizz/l10n/app_localizations.dart';

class QuickAddWidget extends StatefulWidget {
  const QuickAddWidget({super.key});

  @override
  State<QuickAddWidget> createState() => _QuickAddWidgetState();
}

class _QuickAddWidgetState extends State<QuickAddWidget> {
  final TextEditingController _controller = TextEditingController();
  bool _loading = false;

  Future<void> _addToWatchlist(String title) async {
    if (title.trim().isEmpty) return;
    setState(() => _loading = true);
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('watchlist') ?? '[]';
    final List list = jsonDecode(jsonString);
    final newItem = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'title': title,
      'addedDate': DateTime.now().toIso8601String(),
      'notifyAgain': true,
    };
    list.add(newItem);
    await prefs.setString('watchlist', jsonEncode(list));
    setState(() => _loading = false);
    _controller.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Film ajouté à la watchlist')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Ajouter un film à la watchlist', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            TextField(
              controller: _controller,
              decoration: InputDecoration(hintText: AppLocalizations.of(context)?.quick_add_title ?? 'Titre du film'),
              onSubmitted: _addToWatchlist,
            ),
            SizedBox(height: 8),
            _loading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () => _addToWatchlist(_controller.text),
                    child: Text(AppLocalizations.of(context)?.add_button ?? 'Ajouter'),
                  ),
          ],
        ),
      ),
    );
  }
}
