import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mobmovizz/core/theme/colors.dart';
import 'package:mobmovizz/core/widgets/app_bar.dart';
import 'package:mobmovizz/features/genres/movies_genre_list/bloc/movie_genres_bloc.dart';
import 'package:mobmovizz/features/genres/movies_genre_list/data/service/movie_genre_list_service.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MovieGenresBloc(GetIt.I<MovieGenreListService>())..add(FetchGenres()),
      child: Scaffold(
        appBar: mainAppBar(title: "MOBMOVIZZ"),
        backgroundColor: surfaceDim,
        body: SingleChildScrollView(
          child: BlocBuilder<MovieGenresBloc, MovieGenresState>(
              builder: (context, state) {
            if (state is MovieGenresLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is MovieGenresLoaded) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            state.movieGenresListModel.genres?.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: SizedBox(
                              width: 160,
                              height: 30,
                              child: Center(
                                child: ListTile(
                                  tileColor: royalBlue.withOpacity(0.72),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  title: Text(
                                    state.movieGenresListModel.genres?[index]
                                            .name ??
                                        "",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight
                                            .w600), // Prevent text from overflowing
                                  ),
                                  onTap: () {
                                    
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const Text('Other content below the ListView'),
                  ],
                ),
              );
            } else if (state is MovieGenresError) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return const Center(child: Text('Search for genres'));
            }
          }),
        ),
      ),
    );
  }
}
