import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mobmovizz/core/common/common_header.dart';
import 'package:mobmovizz/core/theme/colors.dart';
import 'package:mobmovizz/core/utils/app_preferences.dart';
import 'package:mobmovizz/core/widgets/circular_progress.dart';
import 'package:mobmovizz/core/widgets/list_movie_item.dart';
import 'package:mobmovizz/features/home/upcomings/data/models/upcoming_model.dart';
import 'package:mobmovizz/features/home/upcomings/data/service/upcomings_service.dart';
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
                headerText: localizations?.view_all ?? 'View All',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => UpcomingAllView(
                        initialMovies: state.upcomingModel.results ?? [],
                        initialPage: state.upcomingModel.page ?? 1,
                        totalPages: state.upcomingModel.totalPages ?? 1,
                      ),
                    ),
                  );
                },
              ),
              CarouselSlider(
                options: CarouselOptions(
                  aspectRatio: MediaQuery.of(context).orientation == Orientation.landscape ? 16 / 9 : 4 / 3,
                  viewportFraction: MediaQuery.of(context).orientation == Orientation.landscape ? 0.65 : 0.52,
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

class UpcomingAllView extends StatelessWidget {
  final List<Result> initialMovies;
  final int initialPage;
  final int totalPages;

  const UpcomingAllView({
    super.key,
    required this.initialMovies,
    required this.initialPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return _UpcomingAllBody(
      initialMovies: initialMovies,
      initialPage: initialPage,
      totalPages: totalPages,
    );
  }
}

class _UpcomingAllBody extends StatefulWidget {
  final List<Result> initialMovies;
  final int initialPage;
  final int totalPages;

  const _UpcomingAllBody({
    required this.initialMovies,
    required this.initialPage,
    required this.totalPages,
  });

  @override
  State<_UpcomingAllBody> createState() => _UpcomingAllBodyState();
}

class _UpcomingAllBodyState extends State<_UpcomingAllBody> {
  late final UpcomingService _upcomingService;
  late final AppPreferences _appPreferences;
  late final ScrollController _scrollController;

  late List<Result> _movies;
  late int _currentPage;
  late int _totalPages;

  bool _isLoadingMore = false;
  bool _isGridView = true;
  String? _loadMoreError;

  @override
  void initState() {
    super.initState();
    _upcomingService = GetIt.I<UpcomingService>();
    _appPreferences = GetIt.I<AppPreferences>();
    _scrollController = ScrollController()..addListener(_onScroll);

    _movies = List<Result>.from(widget.initialMovies);
    _currentPage = widget.initialPage;
    _totalPages = widget.totalPages;
    _isGridView = _appPreferences.getGridView();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients || _isLoadingMore) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || _currentPage >= _totalPages) return;

    setState(() => _isLoadingMore = true);

    final result = await _upcomingService.getUpcomings(page: _currentPage + 1);

    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() {
          _loadMoreError = 'Failed to load more movies. Please try again.';
          _isLoadingMore = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_loadMoreError!),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: _loadMore,
            ),
          ),
        );
      },
      (data) {
        setState(() {
          _loadMoreError = null;
          _currentPage = data.page ?? (_currentPage + 1);
          _totalPages = data.totalPages ?? _totalPages;
          _movies.addAll(data.results ?? []);
          _isLoadingMore = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.upcoming ?? 'Upcoming'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
              _appPreferences.setGridView(_isGridView);
            },
            icon: Icon(_isGridView ? Icons.list : Icons.grid_on),
          ),
        ],
      ),
      body: _isGridView
          ? GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 180,
                childAspectRatio: 0.7,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              itemCount: _movies.length + (_isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= _movies.length) {
                  return Center(child: mainCircularProgress());
                }
                final movie = _movies[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MovieDetailsView(movieId: movie.id!),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: (movie.posterPath != null && movie.posterPath!.isNotEmpty)
                        ? CachedNetworkImage(
                            imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: Theme.of(context).colorScheme.surfaceContainer,
                            child: Icon(
                              Icons.image_outlined,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.5),
                              size: 50,
                            ),
                          ),
                  ),
                );
              },
            )
          : ListView.builder(
              controller: _scrollController,
              itemCount: _movies.length + (_isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= _movies.length) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(child: mainCircularProgress()),
                  );
                }
                return buildMovieListItem(context, _movies[index]);
              },
            ),
    );
  }
}
