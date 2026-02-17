import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobmovizz/core/common/info.dart';
import 'package:mobmovizz/core/theme/colors.dart';
import 'package:mobmovizz/core/utils/constants.dart';
import 'package:mobmovizz/core/widgets/circular_progress.dart';
import 'package:mobmovizz/core/widgets/error_handler_widget.dart';
import 'package:mobmovizz/core/widgets/section_error_wrapper.dart';
import 'package:mobmovizz/core/widgets/settings_view.dart';
import 'package:mobmovizz/core/widgets/watchlist_home_widget.dart';
import 'package:mobmovizz/features/home/popular_movies/bloc/popular_movies_bloc.dart';
import 'package:mobmovizz/features/home/top_rated/view/top_rated_view.dart';
import 'package:mobmovizz/features/home/upcomings/view/upcomings_view.dart';
import 'package:mobmovizz/features/movie_details/view/movie_details_view.dart';
import 'package:mobmovizz/l10n/app_localizations.dart';

class DiscoverView extends StatefulWidget {
  const DiscoverView({super.key});

  @override
  State<StatefulWidget> createState() => _DiscoverViewState();
}

class _DiscoverViewState extends State<DiscoverView> {
  final PageController _pageController = PageController(
    viewportFraction: 0.88,
    initialPage: 0,
  );
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<PopularMoviesBloc>().add(FetchPopularMovies());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Constants.mobmovizz),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const TMDBDisclaimerPage()),
            ),
            icon: const Icon(Icons.info_outline_rounded),
            tooltip: 'TMDB',
          ),
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsView()),
            ),
            icon: const Icon(Icons.settings_outlined),
            tooltip:
                AppLocalizations.of(context)?.settings ?? 'Settings',
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: BlocBuilder<PopularMoviesBloc, PopularMoviesState>(
        builder: (context, state) {
          if (state is PopularMoviesError) {
            return Center(
              child: ErrorHandlerWidget(
                errorMessage: state.message,
                onRetry: () {
                  context
                      .read<PopularMoviesBloc>()
                      .add(FetchPopularMovies());
                },
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPopularMoviesSection(state),
                const SizedBox(height: 8),
                _buildSafeWidget(
                  child: const WatchlistHomeWidget(),
                  sectionTitle:
                      AppLocalizations.of(context)?.my_watchlist ?? 'My Watchlist',
                ),
                _buildSafeWidget(
                  child: const UpcomingView(),
                  sectionTitle:
                      AppLocalizations.of(context)?.upcoming ?? 'Upcoming',
                ),
                _buildSafeWidget(
                  child: const TopRatedView(),
                  sectionTitle:
                      AppLocalizations.of(context)?.top_rated ?? 'Top Rated',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPopularMoviesSection(PopularMoviesState state) {
    if (state is PopularMoviesLoading) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Center(child: mainCircularProgress()),
      );
    } else if (state is PopularMoviesLoaded) {
      return _buildLoadedPopularMovies(state);
    } else {
      return SizedBox(
        height: 200,
        child: Center(
          child: Text(
            AppLocalizations.of(context)?.search_for_movies_text ??
                'Search for movies',
          ),
        ),
      );
    }
  }

  Widget _buildLoadedPopularMovies(PopularMoviesLoaded state) {
    final movies = state.popularMovieModel.results;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section Title ──
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
          child: Text(
            AppLocalizations.of(context)?.popular ?? 'Popular',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),

        // ── Hero Carousel ──
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.58,
          child: PageView.builder(
            controller: _pageController,
            itemCount: movies.length,
            onPageChanged: (page) =>
                setState(() => currentPageIndex = page),
            itemBuilder: (context, index) {
              final movie = movies[index];
              final posterPath = movie.posterPath;

              return GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        MovieDetailsView(movieId: movie.id),
                  ),
                ),
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // ── Poster Image ──
                        if (posterPath != null && posterPath.isNotEmpty)
                          CachedNetworkImage(
                            imageUrl:
                                'https://image.tmdb.org/t/p/w500$posterPath',
                            fit: BoxFit.cover,
                            progressIndicatorBuilder:
                                (_, __, progress) => Center(
                              child: mainCircularProgress(
                                  value: progress.progress),
                            ),
                            errorWidget: (_, __, ___) =>
                                _posterPlaceholder(context),
                          )
                        else
                          _posterPlaceholder(context),

                        // ── Bottom Gradient + Title ──
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding:
                                const EdgeInsets.fromLTRB(16, 32, 16, 12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withValues(alpha: 0.85),
                                  Colors.black.withValues(alpha: 0.4),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (movie.voteAverage > 0) ...[
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(Icons.star_rounded,
                                          color: accentAmber, size: 18),
                                      const SizedBox(width: 4),
                                      Text(
                                        movie.voteAverage
                                            .toStringAsFixed(1),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(
                                              color: Colors.white,
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
              );
            },
          ),
        ),

        // ── Page Indicator ──
        const SizedBox(height: 16),
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
                movies.length, (i) => _indicator(i == currentPageIndex)),
          ),
        ),
      ],
    );
  }

  Widget _posterPlaceholder(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: Center(
        child: Icon(
          Icons.movie_outlined,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          size: 60,
        ),
      ),
    );
  }

  Widget _buildSafeWidget({
    required Widget child,
    required String sectionTitle,
  }) {
    return Builder(
      builder: (context) {
        try {
          return child;
        } catch (error) {
          return CompactSectionError(
            title: sectionTitle,
            errorMessage: error.toString(),
            height: 150,
          );
        }
      },
    );
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      height: 4,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: isActive
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context)
                .colorScheme
                .onSurface
                .withValues(alpha: 0.2),
      ),
    );
  }
}
