import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobmovizz/core/common/common_header.dart';
import 'package:mobmovizz/core/theme/colors.dart';
import 'package:mobmovizz/core/widgets/circular_progress.dart';
import 'package:mobmovizz/features/home/upcomings/bloc/upcomings_bloc.dart';
import 'package:mobmovizz/features/movie_details/view/movie_details_view.dart';
import 'package:mobmovizz/l10n/app_localizations.dart';

class UpcomingView extends StatelessWidget {
  const UpcomingView({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return BlocBuilder<UpcomingsBloc, UpcomingsState>(
      builder: (context, state) {
        if (state is UpcomingsLoading) {
          return Center(child: mainCircularProgress());
        } else if (state is UpcomingsLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonHeader(
                headerTitle: localizations?.upcoming ?? 'Upcoming',
                headerText: '',
                onTap: () {},
              ),
              CarouselSlider(
                options: CarouselOptions(
                  aspectRatio: 4 / 3,
                  viewportFraction: 0.52,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: false,
                  padEnds: true,
                  scrollDirection: Axis.horizontal,
                ),
                items: state.upcomingModel.results
                    ?.map(
                      (item) => GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  MovieDetailsView(movieId: item.id!),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                if (item.posterPath != null && item.posterPath!.isNotEmpty)
                                  CachedNetworkImage(
                                    progressIndicatorBuilder:
                                        (context, url, progress) => Center(
                                      child: mainCircularProgress(
                                        value: progress.progress,
                                      ),
                                    ),
                                    imageUrl:
                                        'https://image.tmdb.org/t/p/w500${item.posterPath}',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  )
                                else
                                  Container(
                                    color: Theme.of(context).colorScheme.surfaceContainer,
                                    child: Icon(
                                      Icons.photo_outlined,
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      size: 50,
                                    ),
                                  ),
                                // ── Bottom gradient with title ──
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(8, 28, 8, 8),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Colors.black.withValues(alpha: 0.8),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          item.title ?? '',
                                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (item.releaseDate != null) ...[
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              Icon(Icons.calendar_today_rounded, color: accentAmber, size: 12),
                                              const SizedBox(width: 3),
                                              Flexible(
                                                child: Text(
                                                  '${item.releaseDate!.day.toString().padLeft(2, '0')}/${item.releaseDate!.month.toString().padLeft(2, '0')}/${item.releaseDate!.year}',
                                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                                    color: Colors.white70,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          );
        } else if (state is UpcomingsError) {
          return const SizedBox.shrink();
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
