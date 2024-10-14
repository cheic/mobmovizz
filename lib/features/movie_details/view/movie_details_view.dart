import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get_it/get_it.dart';
import 'package:mobmovizz/core/theme/colors.dart';
import 'package:mobmovizz/core/utils/format_date.dart';
import 'package:mobmovizz/core/utils/format_minutes.dart';
import 'package:mobmovizz/core/widgets/circular_progress.dart';
import 'package:mobmovizz/features/movie_details/bloc/movie_details_bloc.dart';
import 'package:mobmovizz/features/movie_details/data/movie_details_service.dart';

class MovieDetailsView extends StatelessWidget {
  final int movieId;

  const MovieDetailsView({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovieDetailsBloc(GetIt.I<MovieDetailsService>())
        ..add(FetchMovieDetails(movieId)),
      child: Scaffold(
        backgroundColor: surfaceDim,
        appBar: AppBar(
          backgroundColor: surfaceDim,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          title: const Text(
            "Details",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
          builder: (context, state) {
            if (state is MovieDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MovieDetailsError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            } else if (state is MovieDetailsLoaded) {
              final movie = state.movieDetailsModel;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (movie.backdropPath != null)
                      Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl:
                                'https://image.tmdb.org/t/p/w500${movie.backdropPath}',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 230,
                            progressIndicatorBuilder:
                                (context, url, progress) => Center(
                              child: mainCircularProgress(
                                value: progress.progress,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.5),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.7),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.title ?? 'No Title',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            movie.tagline ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.white70,
                                ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Overview',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            movie.overview ?? 'No overview available',
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            runSpacing: 10,
                            spacing: 8,
                            children: movie.genres
                                    ?.map((genre) => Chip(
                                          elevation: 0,
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          side: BorderSide.none,
                                          backgroundColor: royalBlue,
                                          label: Text(
                                            genre.name ?? '',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ))
                                    .toList() ??
                                [],
                          ),
                          const SizedBox(height: 16),
                          _buildInfoRow(
                              'Release Date',
                              formatReleaseDateWithMonthName(
                                      movie.releaseDate?.toString()) ??
                                  'Unknown'),
                          _buildInfoRow(
                              'Runtime', formatRuntime(movie.runtime!) ?? ""),
                          _buildInfoRow(
                              'Vote Average',
                              '${movie.voteAverage?.toStringAsFixed(1) ?? 'N/A'}/10'),
                          _buildInfoRow('Budget',
                              '\$${movie.budget?.toString() ?? 'N/A'}'),
                          _buildInfoRow('Revenue',
                              '\$${movie.revenue?.toString() ?? 'N/A'}'),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white)),
          Text(
            value,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
