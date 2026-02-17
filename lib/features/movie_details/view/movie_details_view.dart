import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:mobmovizz/core/theme/colors.dart';
import 'package:mobmovizz/core/utils/date_formatter.dart';
import 'package:mobmovizz/core/utils/format_minutes.dart';
import 'package:mobmovizz/core/utils/rating.dart';
import 'package:mobmovizz/core/utils/currency_formatter.dart';
import 'package:mobmovizz/core/widgets/youtube_palyer_view.dart';
import 'package:mobmovizz/core/widgets/add_to_watchlist_dialog.dart';
import 'package:mobmovizz/l10n/app_localizations.dart';
import 'package:mobmovizz/features/watchlist/watchlist.dart';
import 'package:mobmovizz/features/movie_details/bloc/movie_details_bloc.dart';
import 'package:mobmovizz/features/movie_details/data/movie_details_service.dart';

class MovieDetailsView extends StatefulWidget {
  final int movieId;

  const MovieDetailsView({super.key, required this.movieId});

  @override
  State<MovieDetailsView> createState() => _MovieDetailsViewState();
}

class _MovieDetailsViewState extends State<MovieDetailsView> {
  String countryCode = 'FR';

  @override
  void initState() {
    super.initState();
    _initializeCountryCode();
  }

  void _initializeCountryCode() async {
    try {
      if (mounted) {
        setState(() => countryCode = _getDeviceCountryCode());
      }
    } catch (e) {
      if (mounted) {
        setState(() => countryCode = _getDeviceCountryCode());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovieDetailsBloc(GetIt.I<MovieDetailsService>())
        ..add(FetchMovieDetails(widget.movieId)),
      child: Scaffold(
        body: BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
          builder: (context, state) {
            if (state is MovieDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MovieDetailsError) {
              return _buildErrorState(state.message);
            } else if (state is MovieDetailsLoaded) {
              return _buildDetailsBody(context, state);
            }
            return const SizedBox.shrink();
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: _buildWatchlistFAB(),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          leading: const BackButton(),
          title: Text(AppLocalizations.of(context)?.details ?? 'Details'),
        ),
        SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline_rounded, size: 64,
                    color: Theme.of(context).colorScheme.error),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(message, textAlign: TextAlign.center),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsBody(BuildContext context, MovieDetailsLoaded state) {
    final movie = state.movieDetailsModel;
    final hasBackdrop = movie.backdropPath != null;

    return CustomScrollView(
      slivers: [
        // ── Immersive SliverAppBar ──
        SliverAppBar(
          expandedHeight: hasBackdrop ? 320 : 0,
          pinned: true,
          stretch: true,
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
            child: const BackButton(color: Colors.white),
          ),
          flexibleSpace: hasBackdrop
              ? FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl:
                            'https://image.tmdb.org/t/p/w780${movie.backdropPath}',
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          color: Theme.of(context).colorScheme.surfaceContainer,
                          child: const Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (_, __, ___) => Container(
                          color: Theme.of(context).colorScheme.surfaceContainer,
                          child: Icon(Icons.image_outlined,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.5),
                              size: 50),
                        ),
                      ),
                      // Gradient overlay
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        height: 160,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Theme.of(context).scaffoldBackgroundColor,
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Play button
                      if (state.videoResultsModel.results.isNotEmpty)
                        Positioned(
                          bottom: 20,
                          right: 20,
                          child: GestureDetector(
                            onTap: () => showYouTubePlayerDialog(
                                context,
                                state.videoResultsModel.results.first.key),
                            child: Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).colorScheme.primary,
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withValues(alpha: 0.4),
                                    blurRadius: 16,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.play_arrow_rounded,
                                color: Theme.of(context).colorScheme.onPrimary,
                                size: 32,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                )
              : null,
        ),

        // ── Content ──
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  movie.title ??
                      AppLocalizations.of(context)?.no_title ?? 'No Title',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),

                // Tagline
                if (movie.tagline != null && movie.tagline!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    movie.tagline!,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.6),
                        ),
                  ),
                ],

                // ── Quick Stats Row ──
                const SizedBox(height: 16),
                _buildQuickStats(context, movie),

                // ── Genre Chips ──
                if (movie.genres != null && movie.genres!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: movie.genres!
                        .map((genre) => Chip(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              label: Text(genre.name ?? ''),
                            ))
                        .toList(),
                  ),
                ],

                // ── Overview ──
                const SizedBox(height: 24),
                Text(
                  AppLocalizations.of(context)?.overview ?? 'Overview',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  movie.overview ??
                      AppLocalizations.of(context)?.no_overview_available ??
                      'No overview available',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.6,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.85),
                      ),
                ),

                // ── Details Card ──
                const SizedBox(height: 24),
                _buildDetailsCard(context, movie),

                // Bottom spacing for FAB
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats(BuildContext context, dynamic movie) {
    return Row(
      children: [
        // Rating
        if (movie.voteAverage != null) ...[
          Icon(Icons.star_rounded, color: accentAmber, size: 20),
          const SizedBox(width: 4),
          Text(
            movie.voteAverage!.toStringAsFixed(1),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          _statDivider(context),
        ],
        // Runtime
        if (movie.runtime != null && movie.runtime! > 0) ...[
          Icon(Icons.schedule_rounded,
              size: 18,
              color:
                  Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
          const SizedBox(width: 4),
          Text(
            formatRuntime(movie.runtime!) ?? '',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          _statDivider(context),
        ],
        // Release Date
        if (movie.releaseDate != null) ...[
          Icon(Icons.calendar_today_rounded,
              size: 16,
              color:
                  Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              DateFormatter.formatReleaseDate(
                  movie.releaseDate?.toString(), context),
              style: Theme.of(context).textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );
  }

  Widget _statDivider(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        width: 1,
        height: 16,
        color: Theme.of(context).colorScheme.outlineVariant,
      ),
    );
  }

  Widget _buildDetailsCard(BuildContext context, dynamic movie) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        children: [
          _buildDetailRow(
            context,
            Icons.how_to_vote_outlined,
            l10n?.vote_average ?? 'Vote Average',
            child: buildVoteAverageStars(movie.voteAverage),
          ),
          _divider(context),
          _buildDetailRow(
            context,
            Icons.people_outline_rounded,
            l10n?.vote_count ?? 'Vote Count',
            value: '${movie.voteCount ?? 'N/A'}',
          ),
          _divider(context),
          _buildDetailRow(
            context,
            Icons.account_balance_wallet_outlined,
            l10n?.budget ?? 'Budget',
            value: CurrencyFormatter.formatCurrency(movie.budget),
          ),
          _divider(context),
          _buildDetailRow(
            context,
            Icons.trending_up_rounded,
            l10n?.revenue ?? 'Revenue',
            value: CurrencyFormatter.formatCurrency(movie.revenue),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String label,
      {String? value, Widget? child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon,
              size: 20,
              color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          if (child != null) child,
          if (value != null)
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
            ),
        ],
      ),
    );
  }

  Widget _divider(BuildContext context) {
    return Divider(
      height: 1,
      color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3),
    );
  }

  Widget _buildWatchlistFAB() {
    return BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
      builder: (context, state) {
        if (state is MovieDetailsLoaded) {
          final movie = state.movieDetailsModel;
          return BlocBuilder<WatchlistBloc, WatchlistState>(
            builder: (context, watchlistState) {
              bool isInWatchlist = false;
              if (watchlistState is WatchlistLoaded) {
                isInWatchlist = watchlistState.watchlist
                    .any((item) => item.id == movie.id);
              }

              return BlocListener<WatchlistBloc, WatchlistState>(
                listener: (context, favState) {
                  if (favState is WatchlistError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(favState.message)),
                    );
                  } else if (favState is WatchlistLoaded) {
                    final isNowInWatchlist = favState.watchlist
                        .any((item) => item.id == movie.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isNowInWatchlist
                            ? AppLocalizations.of(context)
                                    ?.added_to_watchlist ??
                                'Added to watchlist!'
                            : AppLocalizations.of(context)
                                    ?.removed_from_watchlist ??
                                'Removed from watchlist!'),
                      ),
                    );
                  }
                },
                child: FloatingActionButton.extended(
                  onPressed: () {
                    if (isInWatchlist) {
                      context
                          .read<WatchlistBloc>()
                          .add(RemoveFromWatchlistEvent(movie.id!));
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => AddToWatchlistDialog(
                          movieId: movie.id!,
                          title: movie.title ??
                              AppLocalizations.of(context)?.unknown ??
                              'Unknown',
                          posterPath: movie.posterPath,
                          releaseDate: movie.releaseDate?.toString(),
                        ),
                      );
                    }
                  },
                  icon: Icon(isInWatchlist
                      ? Icons.bookmark_remove_rounded
                      : Icons.bookmark_add_rounded),
                  label: Text(isInWatchlist
                      ? AppLocalizations.of(context)
                              ?.remove_from_watchlist ??
                          'Remove from Watchlist'
                      : AppLocalizations.of(context)
                              ?.add_to_watchlist_button ??
                          'Add to Watchlist'),
                ),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

Future<String> getPhoneRegionByLocation() async {
  try {
    // Check and request location permission
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception("Location permissions are denied");
    }

    // Get the device's current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Reverse geocode to find the country code
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    // Extract and return the country code
    return placemarks.first.isoCountryCode ?? _getDeviceCountryCode();
  } catch (e) {
    return _getDeviceCountryCode();
  }
}

String _getDeviceCountryCode() {
  try {
    // Try to get country code from device locale
    String? localeCountry = Platform.localeName.split('_').last;
    if (localeCountry.length == 2) {
      return localeCountry;
    }

    // Absolute last resort
    return 'US';
  } catch (e) {
    return 'US';
  }
}
