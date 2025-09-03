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
import 'package:mobmovizz/core/widgets/app_bar.dart';
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
  String countryCode = 'FR'; // Default to FR

  @override
  void initState() {
    super.initState();
    _initializeCountryCode();
  }

  void _initializeCountryCode() async {
    try {
      // Code pays par défaut
      if (mounted) {
        setState(() {
          countryCode = _getDeviceCountryCode();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          countryCode = _getDeviceCountryCode();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => MovieDetailsBloc(GetIt.I<MovieDetailsService>())
        ..add(FetchMovieDetails(widget.movieId)),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: mainAppBar(
          context: context,
          iconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          title: AppLocalizations.of(context)?.details ?? "Details",
          ),
        body: BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
          builder: (context, state) {
            if (state is MovieDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MovieDetailsError) {
              return Center(
                child: Text(
                  state.message,
                
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
                          Container(
                            height: 280,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(24),
                                bottomRight: Radius.circular(24),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(24),
                                bottomRight: Radius.circular(24),
                              ),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: 'https://image.tmdb.org/t/p/w500${movie.backdropPath}',
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      color: Theme.of(context).colorScheme.surfaceContainer,
                                      child: Center(child: CircularProgressIndicator()),
                                    ),
                                  ),
                                  // Gradient overlay pour améliorer la lisibilité
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Theme.of(context).colorScheme.surface.withValues(alpha: 0.3),
                                          Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
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
                          if (state.videoResultsModel.results.isNotEmpty)
                            Positioned(
                              bottom: 10,
                              right: 10,
                              child: GestureDetector(
                                onTap: () {
                                  showYouTubePlayerDialog(
                                      context,
                                      state
                                          .videoResultsModel.results.first.key);
                                },
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.play_arrow,
                                    color: Colors.black,
                                    size: 40,
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
                            movie.title ?? AppLocalizations.of(context)?.no_title ?? 'No Title',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  
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
                              
                                ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            AppLocalizations.of(context)?.overview ?? 'Overview',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                 
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            movie.overview ?? AppLocalizations.of(context)?.no_overview_available ?? 'No overview available',
                            
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            runSpacing: 10,
                            spacing: 8,
                            children: movie.genres
                                    ?.map((genre) => Container(
                                          margin: EdgeInsets.only(right: 8, bottom: 4),
                                          child: Chip(
                                            elevation: 2,
                                            materialTapTargetSize:
                                                MaterialTapTargetSize.shrinkWrap,
                                            side: BorderSide.none,
                                            backgroundColor: Theme.of(context).colorScheme.primary,
                                            shadowColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                                            label: Text(
                                              genre.name ?? '',
                                              style: TextStyle(
                                                color: Theme.of(context).colorScheme.onPrimary,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ))
                                    .toList() ??
                                [],
                          ),
                          const SizedBox(height: 16),
                          _buildInfoRow(
                              AppLocalizations.of(context)?.release_date ?? 'Release Date',
                              DateFormatter.formatReleaseDate(
                                      movie.releaseDate?.toString(), context)),
                          _buildInfoRow(
                              AppLocalizations.of(context)?.runtime ?? 'Runtime', formatRuntime(movie.runtime!) ?? ""),
                          _buildVoteAverageInfo(AppLocalizations.of(context)?.vote_average ?? 'Vote Average',
                              buildVoteAverageStars(movie.voteAverage)),
                          _buildInfoRow(
                              AppLocalizations.of(context)?.vote_count ?? 'Vote Count', '${movie.voteCount ?? 'N/A'}'),
                          _buildInfoRow(AppLocalizations.of(context)?.budget ?? 'Budget',
                              CurrencyFormatter.formatCurrency(movie.budget)),
                          _buildInfoRow(AppLocalizations.of(context)?.revenue ?? 'Revenue',
                              CurrencyFormatter.formatCurrency(movie.revenue)),
                          const SizedBox(height: 24),
                          // Section provider cachée
                          // Espacement pour éviter que le FloatingActionButton cache le contenu
                          const SizedBox(height: 80),
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
          builder: (context, state) {
            if (state is MovieDetailsLoaded) {
              final movie = state.movieDetailsModel;
              return BlocBuilder<WatchlistBloc, WatchlistState>(
                builder: (context, watchlistState) {
                  // Check if movie is in watchlist
                  bool isInWatchlist = false;
                  if (watchlistState is WatchlistLoaded) {
                    isInWatchlist = watchlistState.watchlist.any((item) => item.id == movie.id);
                  }
                  
                  return BlocListener<WatchlistBloc, WatchlistState>(
                    listener: (context, favState) {
                      if (favState is WatchlistError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(favState.message),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else if (favState is WatchlistLoaded) {
                        final isNowInWatchlist = favState.watchlist.any((item) => item.id == movie.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(isNowInWatchlist 
                                ? AppLocalizations.of(context)?.added_to_watchlist ?? 'Added to watchlist!' 
                                : AppLocalizations.of(context)?.removed_from_watchlist ?? 'Removed from watchlist!'),
                            backgroundColor: isNowInWatchlist ? Colors.green : Colors.orange,
                          ),
                        );
                      }
                    },
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        if (isInWatchlist) {
                          // Remove from watchlist
                          context.read<WatchlistBloc>().add(RemoveFromWatchlistEvent(movie.id!));
                        } else {
                          // Add to watchlist
                          showDialog(
                            context: context,
                            builder: (context) => AddToWatchlistDialog(
                              movieId: movie.id!,
                              title: movie.title ?? AppLocalizations.of(context)?.unknown ?? 'Unknown',
                              posterPath: movie.posterPath,
                              releaseDate: movie.releaseDate?.toString(),
                            ),
                          );
                        }
                      },
                      backgroundColor: isInWatchlist ? Colors.orange : royalBlueDerived,
                 
                      icon: Icon(isInWatchlist ? Icons.bookmark_remove : Icons.bookmark_add),
                      label: Text(isInWatchlist 
                        ? AppLocalizations.of(context)?.remove_from_watchlist ?? 'Remove from Watchlist' 
                        : AppLocalizations.of(context)?.add_to_watchlist_button ?? 'Add to Watchlist'),
                    ),
                  );
                },
              );
            }
            return SizedBox.shrink();
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
                  fontWeight: FontWeight.bold)),
          Text(
            value,
            
          ),
        ],
      ),
    );
  }

  Widget _buildVoteAverageInfo(String label, Widget stars) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.bold)),
          stars
        ],
      ),
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
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude);

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

