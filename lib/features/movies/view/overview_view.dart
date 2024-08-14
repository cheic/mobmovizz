import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobmovizz/core/common/button_tab.dart';
import 'package:mobmovizz/core/theme/colors.dart';
import 'package:mobmovizz/features/movies/bloc/bloc/overview_bloc.dart';

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
    context.read<DiscoverBloc>().add(FetchDiscover());
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page!;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'MOBMOVIZZ',
                style:
                    TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
              ),
              centerTitle: false,
              backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
              bottom: ButtonsTabBar(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                radius: 32,
                backgroundColor: royalBlue,
                unselectedBackgroundColor: Colors.transparent,
                unselectedLabelStyle: const TextStyle(color: Colors.white),
                labelStyle: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
                tabs: const [
                  Tab(
                    child: Text(
                      'OK TEST',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Tab(
                    text: "Tab 2",
                  ),
                  Tab(
                    text: "Tab 3",
                  ),
                ],
              ),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      const Color(0xff111318),
                      const Color.fromARGB(255, 17, 19, 24),
                      const Color.fromARGB(150, 17, 19, 24),
                      const Color.fromARGB(130, 17, 19, 24),
                      const Color.fromARGB(110, 17, 19, 24),
                      const Color.fromARGB(80, 17, 19, 24),
                      const Color(0xff111318).withAlpha(0),
                    ],
                  ),
                ),
              ),
              elevation: 0,
            ),
            extendBodyBehindAppBar: true,
            body: BlocBuilder<DiscoverBloc, DiscoverState>(
                builder: (context, state) {
              if (state is DiscoverLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is DiscoverLoaded) {
                List<Widget> buildPageIndicator() {
                  List<Widget> list = [];
                  for (int i = 0; i < state.discoverModel.results.length; i++) {
                    list.add(i == currentPageIndex
                        ? _indicator(true)
                        : _indicator(false));
                  }
                  return list;
                }

                return Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      SizedBox(
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: state.discoverModel.results.length,
                          itemBuilder: (context, index) {
                            final movie = state.discoverModel.results[index];
                            return Padding(
                              padding: const EdgeInsets.all(0),
                              child: Column(
                                children: [
                                  Image.network(
                                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                    height: MediaQuery.of(context).size.height,
                                    width: double.infinity,
                                    fit: BoxFit.fill,
                                  ),

                                  /*Text(
                                    movie.title,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),*/
                                  // Text(movie.overview),
                                ],
                              ),
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
                    ],
                  ),
                );
              } else if (state is DiscoverError) {
                return Center(child: Text('Error: ${state.message}'));
              } else {
                return const Center(child: Text('Search for movies'));
              }
            })));
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
          color: isActive ? royalBlue : const Color(0XFFEAEAEA),
        ),
      ),
    );
  }
}

/*
ListTile(
              title: Text(movie.title),
              subtitle: Text(movie.overview),
              leading: movie.posterPath.isNotEmpty
                  ? Image.network(
                      'https://image.tmdb.org/t/p/w500${movie.posterPath}')
                  : null,
            );*/ 
