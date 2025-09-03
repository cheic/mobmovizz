import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobmovizz/core/theme/colors.dart';
import 'package:mobmovizz/core/widgets/app_bar.dart';
import 'package:mobmovizz/core/widgets/circular_progress.dart';
import 'package:mobmovizz/features/watchlist/watchlist.dart';

import 'package:mobmovizz/features/movie_details/view/movie_details_view.dart';
import 'package:mobmovizz/l10n/app_localizations.dart';
import 'package:mobmovizz/core/utils/app_preferences.dart';
import 'package:mobmovizz/core/utils/notification_date_validator.dart';
import 'package:mobmovizz/core/utils/date_formatter.dart';

class WatchlistView extends StatefulWidget {
  const WatchlistView({super.key});

  @override
  State<WatchlistView> createState() => _WatchlistViewState();
}

class _WatchlistViewState extends State<WatchlistView> {
  @override
  void initState() {
    super.initState();
    context.read<WatchlistBloc>().add(LoadWatchlistEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(context: context,title: AppLocalizations.of(context)?.my_watchlist ?? "My Watchlist"),
      body: BlocBuilder<WatchlistBloc, WatchlistState>(
        builder: (context, state) {
          if (state is WatchlistLoading) {
            return Center(child: mainCircularProgress());
          } else if (state is WatchlistLoaded) {
            if (state.watchlist.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bookmark_border,
                      size: 64,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    ),
                    SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)?.your_watchlist_is_empty ?? "Your watchlist is empty",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)?.add_movies_you_want_to_watch_later ?? "Add movies you want to watch later",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: state.watchlist.length,
              itemBuilder: (context, index) {
                final item = state.watchlist[index];
                return _buildWatchlistItem(context, item);
              },
            );
          } else if (state is WatchlistError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
                  SizedBox(height: 16),
                  Text(
                    state.message,
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<WatchlistBloc>().add(LoadWatchlistEvent());
                    },
                    child: Text(AppLocalizations.of(context)?.retry ?? 'Retry'),
                  ),
                ],
              ),
            );
          }

          return Container();
        },
      ),
    );
  }

  Widget _buildWatchlistItem(BuildContext context, WatchlistItem item) {

    final bool hasReminder = item.reminderDate != null;
    final DateTime now = DateTime.now();
    final bool isUpcoming = item.reminderDate != null && 
        item.reminderDate!.isAfter(now);

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      color: Theme.of(context).colorScheme.surfaceContainer,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailsView(movieId: item.id),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Movie poster
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 80,
                  height: 120,
                  child: item.posterPath != null
                      ? CachedNetworkImage(
                          imageUrl: 'https://image.tmdb.org/t/p/w500${item.posterPath}',
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Theme.of(context).colorScheme.surfaceContainer,
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: royalBlueDerived,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Theme.of(context).colorScheme.surfaceContainer,
                            child: Icon(
                              Icons.photo_outlined,
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                        )
                      : Container(
                          color: Theme.of(context).colorScheme.surfaceContainer,
                          child: Icon(
                            Icons.photo_outlined,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                ),
              ),
              
              SizedBox(width: 16),
              
              // Movie details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    SizedBox(height: 8),
                    
                    // Release date
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                        SizedBox(width: 4),
                        Text(
                          '${AppLocalizations.of(context)?.release_label ?? 'Release'}: ${DateFormatter.formatReleaseDate(item.releaseDate, context)}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 4),
                    
                    // Added date
                    Row(
                      children: [
                        Icon(
                          Icons.bookmark_add,
                          size: 16,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                        SizedBox(width: 4),
                        Text(
                          '${AppLocalizations.of(context)?.added_label ?? 'Added'}: ${DateFormatter.formatDateTime(item.addedDate, context)}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                    
                    if (hasReminder) ...[
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            isUpcoming ? Icons.alarm : Icons.alarm_off,
                            size: 16,
                            color: isUpcoming ? royalBlueDerived : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${AppLocalizations.of(context)?.reminder_label ?? 'Reminder'}: ${DateFormatter.formatDateTime(item.reminderDate, context)}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isUpcoming ? royalBlueDerived : Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ],
                    
                    SizedBox(height: 12),
                    
                    // Action buttons
                    Row(
                      children: [
                        // Edit reminder button
                        TextButton.icon(
                          onPressed: () => _showEditReminderDialog(context, item),
                          icon: Icon(
                            Icons.edit,
                            size: 16,
                            color: royalBlueDerived,
                          ),
                          label: Text(
                            AppLocalizations.of(context)?.edit ?? 'Edit',
                            style: TextStyle(color: royalBlueDerived),
                          ),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            minimumSize: Size.zero,
                          ),
                        ),
                        
                        SizedBox(width: 8),
                        
                        // Remove from watchlist button
                        TextButton.icon(
                          onPressed: () => _showRemoveDialog(context, item),
                          icon: Icon(
                            Icons.remove_circle_outline,
                            size: 16,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          label: Text(
                            AppLocalizations.of(context)?.remove ?? 'Remove',
                            style: TextStyle(color: Theme.of(context).colorScheme.error),
                          ),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            minimumSize: Size.zero,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditReminderDialog(BuildContext context, WatchlistItem item) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return; // Early return if localization not available
    
    // Use validator to ensure the date is appropriate
    DateTime initialDate;
    if (item.reminderDate != null) {
      initialDate = item.reminderDate!;
    } else {
      initialDate = NotificationDateValidator.getInitialNotificationDate(
        item.releaseDate, 
        TimeOfDay(hour: 20, minute: 0)
      );
    }
    
    DateTime selectedDate = initialDate;
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(selectedDate);
    bool notifyAgain = item.notifyAgain;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Text(
            l10n.edit_reminder,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${l10n.set_reminder_for} "${item.title}"',
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8)),
              ),
              SizedBox(height: 20),
              
              // Date picker
              ListTile(
                leading: Icon(Icons.calendar_today, color: royalBlueDerived),
                title: Text(
                  '${l10n.date}: ${DateFormatter.formatDateTime(selectedDate, context)}',
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                ),
                onTap: () async {
                  final minimumDate = NotificationDateValidator.getMinimumNotificationDate(item.releaseDate);
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate.isBefore(minimumDate) ? minimumDate : selectedDate,
                    firstDate: minimumDate,
                    lastDate: DateTime.now().add(Duration(days: 365)),
                    helpText: item.releaseDate != null && 
                             NotificationDateValidator.getMinimumNotificationDate(item.releaseDate).isAfter(DateTime.now())
                        ? '${l10n.movie_releases_on} ${DateFormatter.formatReleaseDate(item.releaseDate, context)}'
                        : null,
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: Theme.of(context).colorScheme.copyWith(
                            primary: royalBlueDerived,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    setState(() {
                      selectedDate = DateTime(
                        picked.year,
                        picked.month,
                        picked.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );
                    });
                  }
                },
              ),
              
              // Time picker  
              ListTile(
                leading: Icon(Icons.access_time, color: royalBlueDerived),
                title: Text(
                  '${l10n.time}: ${selectedTime.format(context)}',
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                ),
                onTap: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: Theme.of(context).colorScheme.copyWith(
                            primary: royalBlueDerived,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    setState(() {
                      selectedTime = picked;
                      selectedDate = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        picked.hour,
                        picked.minute,
                      );
                    });
                  }
                },
              ),              SizedBox(height: 10),
              
              // Notify again checkbox
              CheckboxListTile(
                title: Text(
                  l10n.enable_reminder,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                ),
                value: notifyAgain,
                onChanged: (value) {
                  setState(() {
                    notifyAgain = value ?? true;
                  });
                },
                checkColor: Theme.of(context).colorScheme.onPrimary,
                activeColor: royalBlueDerived,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                l10n.cancel,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Validate the notification date before updating
                if (!NotificationDateValidator.isValidNotificationDate(selectedDate, item.releaseDate)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        NotificationDateValidator.getValidationErrorMessage(item.releaseDate),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                
                final updatedItem = WatchlistItem(
                  id: item.id,
                  title: item.title,
                  posterPath: item.posterPath,
                  releaseDate: item.releaseDate,
                  reminderDate: selectedDate,
                  notifyAgain: notifyAgain,
                  addedDate: item.addedDate,
                );
                context.read<WatchlistBloc>().add(
                  UpdateWatchlistItemEvent(
                    movieId: item.id,
                    updatedItem: updatedItem,
                  ),
                );
                Navigator.of(dialogContext).pop();
                setState(() {}); // Force le rebuild du parent
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: royalBlueDerived,
                foregroundColor: Colors.white,
              ),
              child: Text(l10n.update),
            ),
          ],
        ),
      ),
    );
  }

  void _showRemoveDialog(BuildContext context, WatchlistItem item) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Color(0xFF1E1E1E),
        title: Text(
          AppLocalizations.of(context)?.remove_from_watchlist_title ?? 'Remove from Watchlist',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to remove "${item.title}" from your watchlist?',
          style: TextStyle(color: Colors.grey[300]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              AppLocalizations.of(context)?.cancel ?? 'Cancel',
              style: TextStyle(color: Colors.grey[300]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<WatchlistBloc>().add(RemoveFromWatchlistEvent(item.id));
              Navigator.of(dialogContext).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(AppLocalizations.of(context)?.remove ?? 'Remove'),
          ),
        ],
      ),
    );
  }
}
