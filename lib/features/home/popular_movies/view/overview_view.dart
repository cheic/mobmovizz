import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobmovizz/core/common/info.dart';
import 'package:mobmovizz/core/theme/colors.dart';
import 'package:mobmovizz/core/utils/constants.dart';
import 'package:mobmovizz/core/widgets/connection_status_app_bar.dart';
import 'package:mobmovizz/core/widgets/circular_progress.dart';
import 'package:mobmovizz/core/widgets/error_handler_widget.dart';
import 'package:mobmovizz/core/widgets/section_error_wrapper.dart';
import 'package:mobmovizz/core/widgets/settings_view.dart';
import 'package:mobmovizz/core/widgets/watchlist_home_widget.dart';
import 'package:mobmovizz/features/home/popular_movies/bloc/popular_movies_bloc.dart';
import 'package:mobmovizz/features/home/top_rated/view/top_rated_view.dart';
import 'package:mobmovizz/features/home/upcomings/view/upcomings_view.dart';
import 'package:mobmovizz/l10n/app_localizations.dart';

class DiscoverView extends StatefulWidget {
  const DiscoverView({super.key});

  @override
  State<StatefulWidget> createState() => _DiscoverViewState();
}

class _DiscoverViewState extends State<DiscoverView> {
  final PageController _pageController = PageController(initialPage: 0);
  int currentPageIndex = 0;
  double currentPage = 0.0;

  @override
  initState() {
    super.initState();
    context.read<PopularMoviesBloc>().add(FetchPopularMovies());
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        
        appBar: connectionStatusAppBar(
          context: context, 
          title: Constants.mobmovizz, 
          actions: [
          IconButton(
              onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TMDBDisclaimerPage()),
                  ),
              icon: Icon(Icons.info_outline_rounded,)),
          IconButton(
              onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsView()),
                  ),
              icon: Icon(Icons.settings_outlined,)),
        ],),
        extendBodyBehindAppBar: false,
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 50),
          child: Column(
            children: [
              // Section des films populaires avec gestion d'erreur séparée
              _buildPopularMoviesSection(),
              
              // Les autres widgets restent toujours visibles avec gestion d'erreur
              _buildSafeWidget(
                child: const WatchlistHomeWidget(),
                sectionTitle: AppLocalizations.of(context)?.my_watchlist ?? 'My Watchlist',
              ),
              _buildSafeWidget(
                child: const UpcomingView(),
                sectionTitle: AppLocalizations.of(context)?.upcoming ?? 'Upcoming',
              ),
              _buildSafeWidget(
                child: const TopRatedView(),
                sectionTitle: AppLocalizations.of(context)?.top_rated ?? 'Top Rated',
              ),
            ],
          ),
        ));
  }

  Widget _buildPopularMoviesSection() {
    return BlocBuilder<PopularMoviesBloc, PopularMoviesState>(
      builder: (context, state) {
        if (state is PopularMoviesLoading) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.65,
            child: Center(child: mainCircularProgress()),
          );
        } else if (state is PopularMoviesLoaded) {
          return _buildLoadedPopularMovies(state);
        } else if (state is PopularMoviesError) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: ErrorHandlerWidget(
              errorMessage: state.message,
              onRetry: () {
                context.read<PopularMoviesBloc>().add(FetchPopularMovies());
              },
            ),
          );
        } else {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Center(
              child: Text(
                AppLocalizations.of(context)?.search_for_movies_text ?? 'Search for movies'
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildLoadedPopularMovies(PopularMoviesLoaded state) {
    List<Widget> buildPageIndicator() {
      List<Widget> list = [];
      for (int i = 0; i < state.popularMovieModel.results.length; i++) {
        list.add(i == currentPageIndex
            ? _indicator(true)
            : _indicator(false));
      }
      return list;
    }

    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.65,
          child: PageView.builder(
            controller: _pageController,
            itemCount: state.popularMovieModel.results.length,
            itemBuilder: (context, index) {
              final movie = state.popularMovieModel.results[index];
              return Stack(
                children: [
                  CachedNetworkImage(
                    progressIndicatorBuilder:
                        (context, url, progress) => Center(
                      child: mainCircularProgress(
                        value: progress.progress,
                      ),
                    ),
                    errorWidget: (context, url, error) => ImageErrorWidget(
                      url: url,
                      width: double.infinity,
                    ),
                    imageUrl:
                        'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: <Color>[
                            surfaceDim.withAlpha(255),
                            surfaceDim.withAlpha(50),
                            surfaceDim.withAlpha(0),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
            onPageChanged: (int page) {
              setState(() {
                currentPageIndex = page;
              });
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: DecoratedBox(
            decoration: BoxDecoration(color: surfaceDim),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: buildPageIndicator(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Widget wrapper qui capture les erreurs des widgets enfants
  /// et affiche un message d'erreur compact sans bloquer les autres sections
  Widget _buildSafeWidget({
    required Widget child,
    required String sectionTitle,
  }) {
    return Builder(
      builder: (context) {
        try {
          return child;
        } catch (error) {
          // Si le widget enfant génère une erreur, afficher un widget d'erreur compact
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
    return SizedBox(
      height: 10,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        height: isActive ? 6 : 4.0,
        width: isActive ? 6 : 4.0,
        decoration: BoxDecoration(
          boxShadow: [
            isActive
                ? BoxShadow(
                    color: royalBlueDerived,
                    blurRadius: 4.0,
                    spreadRadius: 1.0,
                    offset: const Offset(
                      0.0,
                      0.0,
                    ),
                  )
                : const BoxShadow(
                    color: Colors.transparent,
                  )
          ],
          shape: BoxShape.circle,
          color: isActive
              ? royalBlueDerived
              : const Color(0XFFEAEAEA).withAlpha(80),
        ),
      ),
    );
  }
}
