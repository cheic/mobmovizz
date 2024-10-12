import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobmovizz/core/theme/colors.dart';
import 'package:mobmovizz/features/home/popular_movies/bloc/popular_movies_bloc.dart';
import 'package:mobmovizz/features/home/upcomings/view/upcomings_screen.dart';

class DiscoverView extends StatefulWidget {
  const DiscoverView({super.key});

  @override
  State<StatefulWidget> createState() => _DiscoverViewState();
}

class _DiscoverViewState extends State<DiscoverView> {
  final PageController _pageController = PageController(initialPage: 0);
  int currentPageIndex = 0;
  double currentPage = 0.0;
  List items = List.generate(10, (index) => 'Index $index');

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
        backgroundColor: surfaceDim,
        appBar: AppBar(
          title: const Text(
            'MOBMOVIZZ',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          centerTitle: false,
          backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  surfaceDim,
                  surfaceDim.withAlpha(255),
                  surfaceDim.withAlpha(255),
                  surfaceDim.withAlpha(230),
                  surfaceDim.withAlpha(150),
                  surfaceDim.withAlpha(0),
                ],
              ),
            ),
          ),
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: BlocBuilder<PopularMoviesBloc, PopularMoviesState>(
            builder: (context, state) {
          if (state is PopularMoviesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PopularMoviesLoaded) {
            List<Widget> buildPageIndicator() {
              List<Widget> list = [];
              for (int i = 0;
                  i < state.popularMovieModel.results.length;
                  i++) {
                list.add(i == currentPageIndex
                    ? _indicator(true)
                    : _indicator(false));
              }
              return list;
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.only(top: 50, bottom: 50),
              child: Column(
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
                                child: CircularProgressIndicator(
                                  value: progress.progress,
                                ),
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
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: buildPageIndicator(),
                        ),
                      )),
                  const UpcomingScreen(),
                ],
              ),
            );
          } else if (state is PopularMoviesError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: Text('Search for movies'));
          }
        }));
  }

  Widget _indicator(bool isActive) {
    return SizedBox(
      height: 10,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        height: isActive ? 10 : 8.0,
        width: isActive ? 12 : 8.0,
        decoration: BoxDecoration(
          boxShadow: [
            isActive
                ? BoxShadow(
                    color: royalBlue.withOpacity(0.72),
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
          color: isActive ? royalBlue : const Color(0XFFEAEAEA).withAlpha(80),
        ),
      ),
    );
  }
}
