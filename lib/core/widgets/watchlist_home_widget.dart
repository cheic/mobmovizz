import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobmovizz/core/widgets/circular_progress.dart';
import 'package:mobmovizz/features/watchlist/watchlist.dart';
import 'package:mobmovizz/features/movie_details/view/movie_details_view.dart';
import 'package:mobmovizz/core/utils/app_preferences.dart';
import 'package:mobmovizz/core/utils/date_formatter.dart';
import 'package:mobmovizz/l10n/app_localizations.dart';

class WatchlistHomeWidget extends StatelessWidget {
  const WatchlistHomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchlistBloc, WatchlistState>(
      builder: (context, state) {
        if (state is WatchlistLoaded) {
          if (state.watchlist.isEmpty) {
            return Container(); // Don't show anything if empty
          }

          // Show only upcoming reminders (next 7 days)
          final upcomingItems = state.watchlist
              .where((item) => item.reminderDate != null &&
                               item.reminderDate!.isAfter(DateTime.now()) && 
                               item.reminderDate!.isBefore(DateTime.now().add(Duration(days: 7))))
              .toList();

          if (upcomingItems.isEmpty) {
            return Container();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)?.coming_up_in_watchlist ?? 'Coming Up in Watchlist',
                        style: Theme.of(context).textTheme.headlineMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WatchlistView(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(AppLocalizations.of(context)?.view_all ?? 'View All'),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(
                height: 210,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: upcomingItems.length > 5 ? 5 : upcomingItems.length,
                  itemBuilder: (context, index) {
                    final item = upcomingItems[index];
                    return _buildWatchlistCard(context, item);
                  },
                ),
              ),
            ],
          );
        }

        return Container();
      },
    );
  }

  Widget _buildWatchlistCard(BuildContext context, WatchlistItem item) {
    final daysUntil = item.reminderDate?.difference(DateTime.now()).inDays ?? 0;
    final displayDate = DateFormatter.formatShortDate(item.reminderDate, context);

    return Container(
      width: 130,
      margin: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailsView(movieId: item.id),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Poster
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: item.posterPath != null
                    ? CachedNetworkImage(
                        imageUrl: 'https://image.tmdb.org/t/p/w300${item.posterPath}',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        placeholder: (context, url) => Container(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          child: Center(child: mainCircularProgress()),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          child: Icon(Icons.photo_outlined, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 40),
                        ),
                      )
                    : Container(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        child: Icon(Icons.photo_outlined, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 40),
                      ),
              ),
            ),
            
            SizedBox(height: 8),
            
            // Movie Title
            Text(
              item.title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            SizedBox(height: 4),
            
            // Reminder Info
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: daysUntil <= 1 
                    ? Theme.of(context).colorScheme.error 
                    : Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                daysUntil == 0 
                    ? AppLocalizations.of(context)?.today ?? 'Today!' 
                    : daysUntil == 1 
                        ? AppLocalizations.of(context)?.tomorrow ?? 'Tomorrow' 
                        : displayDate,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
