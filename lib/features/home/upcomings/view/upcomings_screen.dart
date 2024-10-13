import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobmovizz/features/home/upcomings/bloc/upcomings_bloc.dart';

class UpcomingScreen extends StatelessWidget {
  const UpcomingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpcomingsBloc, UpcomingsState>(
      builder: (context, state) {
        if (state is UpcomingsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UpcomingsLoaded) {
          return CarouselSlider(
            options: CarouselOptions(
              aspectRatio: 4 / 3,
              viewportFraction: 0.5,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              enlargeFactor: 0.3,
              scrollDirection: Axis.horizontal,
            ),
            items: state.upcomingModel.results
                ?.map(
                  (item) => Container(
                    margin: const EdgeInsets.all(5.0),
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(5.0)),
                      child: Stack(
                        children: <Widget>[
                          CachedNetworkImage(
                            progressIndicatorBuilder:
                                (context, url, progress) => Center(
                              child: CircularProgressIndicator(
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
                )
                .toList(),
          );
        } else if (state is UpcomingsError) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return const Center(child: Text('Search for upcomings'));
        }
      },
    );
  }
}
