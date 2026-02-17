import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobmovizz/core/utils/rating.dart';
import 'package:mobmovizz/core/widgets/circular_progress.dart';
import 'package:mobmovizz/features/movie_details/view/movie_details_view.dart';
import 'package:mobmovizz/core/utils/date_formatter.dart';
import 'package:mobmovizz/l10n/app_localizations.dart';

Widget buildMovieListItem(BuildContext context, dynamic movie) {

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MovieDetailsView(movieId: movie.id!),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        elevation: Theme.of(context).cardTheme.elevation ?? 4,
        shadowColor: Theme.of(context).cardTheme.shadowColor,
        color: Theme.of(context).cardTheme.color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).cardTheme.color ?? Theme.of(context).colorScheme.surface,
                Theme.of(context).colorScheme.surfaceContainer,
              ],
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 120,
                margin: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: (movie.posterPath != null && movie.posterPath!.isNotEmpty)
                      ? CachedNetworkImage(
                          width: 120, // Adjust width as needed
                          height: 180, // Match the parent container height
                          imageUrl:
                              'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                          fit: BoxFit.fill,
                          placeholder: (context, url) => Center(
                              child: SizedBox(
                            width: 50,
                            height: 50,
                            child: mainCircularProgress(),
                          )),
                          errorWidget: (context, url, error) => Container(
                            color: Theme.of(context).colorScheme.surfaceContainer,
                            child: Icon(
                              Icons.photo_outlined,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              size: 50,
                            ),
                          ),
                        )
                      : Container(
                          width: 120,
                          height: 180,
                          color: Theme.of(context).colorScheme.surfaceContainer,
                          child: Icon(
                            Icons.photo_outlined,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            size: 50,
                          ),
                        ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        movie.title ?? 'Unknown Title',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      buildVoteAverageStars(movie.voteAverage),
                      Text(
                        '${AppLocalizations.of(context)?.vote_count_label ?? 'Vote count'}: ${movie.voteCount}',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${AppLocalizations.of(context)?.release_label ?? 'Release'}: ${DateFormatter.formatReleaseDate(movie.releaseDate, context)}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }