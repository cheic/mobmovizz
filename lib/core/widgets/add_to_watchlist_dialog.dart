import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobmovizz/features/watchlist/watchlist.dart';
import 'package:mobmovizz/core/utils/notification_date_validator.dart';
import 'package:mobmovizz/core/utils/date_formatter.dart';
import 'package:mobmovizz/l10n/app_localizations.dart';
import 'package:mobmovizz/core/services/notification_service.dart';

class AddToWatchlistDialog extends StatefulWidget {
  final int movieId;
  final String title;
  final String? posterPath;
  final String? releaseDate;

  const AddToWatchlistDialog({
    super.key,
    required this.movieId,
    required this.title,
    this.posterPath,
    this.releaseDate,
  });

  @override
  State<AddToWatchlistDialog> createState() => _AddToWatchlistDialogState();
}

class _AddToWatchlistDialogState extends State<AddToWatchlistDialog> {
  late DateTime selectedDate;
  late TimeOfDay selectedTime;
  bool notifyAgain = true;

  @override
  void initState() {
    super.initState();
    
    selectedTime = TimeOfDay(hour: 20, minute: 0); // Default to 8 PM
    
    // Use the validator to get the appropriate initial date
    selectedDate = NotificationDateValidator.getInitialNotificationDate(
      widget.releaseDate, 
      selectedTime
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return AlertDialog(
        title: Text(AppLocalizations.of(context)?.add_to_watchlist ?? 'Add to Watchlist'),
        content: const Center(child: CircularProgressIndicator()),
      );
    }
    
    return AlertDialog(
      title: Text(l10n.add_to_watchlist),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${l10n.movie}: ${widget.title}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          
          if (widget.releaseDate != null) ...[
            SizedBox(height: 8),
            Text(
              '${l10n.release_date}: ${DateFormatter.formatReleaseDate(widget.releaseDate, context)}',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
          
          SizedBox(height: 16),
          
          Text(
            l10n.reminder_question,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          
          SizedBox(height: 8),
          
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.date),
            subtitle: Text(DateFormatter.formatDateTime(selectedDate, context)),
            trailing: Icon(Icons.calendar_today),
            onTap: () async {
              final minimumDate = NotificationDateValidator.getMinimumNotificationDate(widget.releaseDate);
              final date = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: minimumDate,
                lastDate: DateTime.now().add(Duration(days: 365 * 2)),
                helpText: widget.releaseDate != null && 
                         NotificationDateValidator.getMinimumNotificationDate(widget.releaseDate).isAfter(DateTime.now())
                    ? '${l10n.movie_releases_on} ${DateFormatter.formatReleaseDate(widget.releaseDate, context)}'
                    : null,
              );
              if (date != null) {
                setState(() {
                  selectedDate = DateTime(
                    date.year,
                    date.month,
                    date.day,
                    selectedTime.hour,
                    selectedTime.minute,
                  );
                });
              }
            },
          ),
          
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.time),
            subtitle: Text(selectedTime.format(context)),
            trailing: Icon(Icons.access_time),
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: selectedTime,
              );
              if (time != null) {
                setState(() {
                  selectedTime = time;
                  selectedDate = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                    time.hour,
                    time.minute,
                  );
                });
              }
            },
          ),
          
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.notify_again),
            subtitle: Text(l10n.additional_reminders),
            value: notifyAgain,
            onChanged: (value) {
              setState(() {
                notifyAgain = value ?? true;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: () async {
            // Request notification permissions if not already granted
            final hasPermission = await NotificationService.hasPermissions();
            if (!hasPermission) {
              final granted = await NotificationService.requestPermissions();
              if (!granted) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.permission_denied),
                    ),
                  );
                }
                return;
              }
            }
            
            // Validate the notification date before adding
            if (!NotificationDateValidator.isValidNotificationDate(selectedDate, widget.releaseDate)) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      NotificationDateValidator.getValidationErrorMessage(widget.releaseDate),
                    ),
                  ),
                );
              }
              return;
            }
            
            if (context.mounted) {
              context.read<WatchlistBloc>().add(
                AddToWatchlistEvent(
                  movieId: widget.movieId,
                  title: widget.title,
                  posterPath: widget.posterPath,
                  releaseDate: widget.releaseDate,
                  reminderDate: selectedDate,
                  notifyAgain: notifyAgain,
                  notificationTitle: l10n.notification_title,
                  notificationBody: l10n.notification_body(widget.title),
                ),
              );
              Navigator.pop(context);
            }
          },
          child: Text(l10n.add_to_watchlist),
        ),
      ],
    );
  }
}
