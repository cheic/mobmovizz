import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobmovizz/core/common/common_header.dart';
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
            children: [
              CommonHeader(
                headerTitle: localizations?.upcoming ?? 'Upcoming',
                headerText: '',
                onTap: () {},
              ),
              CarouselSlider(
                options: CarouselOptions(
                  aspectRatio: 4 / 3,
                  viewportFraction: 0.45,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: false,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 1000),
                  autoPlayCurve: Curves.fastOutSlowIn,
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
                          margin: const EdgeInsets.all(5.0),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5.0)),
                            child: Stack(
                              children: <Widget>[
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
                                    height: 200,
                                    width: double.infinity,
                                    color: Theme.of(context).colorScheme.surfaceContainer,
                                    child: Icon(
                                      Icons.photo_outlined,
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      size: 50,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              )
            ],
          );
        } else if (state is UpcomingsError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 60,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Oups !',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(child: Text('Search for upcomings'));
        }
      },
    );
  }
}
