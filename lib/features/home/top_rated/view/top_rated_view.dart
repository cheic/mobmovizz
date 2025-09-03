import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobmovizz/core/common/common_header.dart';
import 'package:mobmovizz/core/widgets/circular_progress.dart';
import 'package:mobmovizz/features/home/top_rated/bloc/top_rated_bloc.dart';
import 'package:mobmovizz/features/movie_details/view/movie_details_view.dart';
import 'package:mobmovizz/l10n/app_localizations.dart';

class TopRatedView extends StatelessWidget {
  const TopRatedView({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return BlocBuilder<TopRatedBloc, TopRatedState>(
      builder: (context, state) {
        if (state is TopRatedLoading) {
          return Center(child: mainCircularProgress());
        } else if (state is TopRatedLoaded) {
          return Column(
            children: [
              CommonHeader(
                headerTitle: localizations?.top_rated ?? 'Top Rated',
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
                            child: Column(
                              children: <Widget>[
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
        } else if (state is TopRatedError) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return const Center(child: Text('Search for Top rated'));
        }
      },
    );
  }
}
