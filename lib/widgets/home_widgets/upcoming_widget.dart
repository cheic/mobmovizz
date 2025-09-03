import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobmovizz/features/home/upcomings/bloc/upcomings_bloc.dart';
import 'package:mobmovizz/features/movie_details/view/movie_details_view.dart';

class UpcomingWidget extends StatelessWidget {
  const UpcomingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      color: Colors.white,
      child: BlocBuilder<UpcomingsBloc, UpcomingsState>(
        builder: (context, state) {
          if (state is UpcomingsLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is UpcomingsLoaded) {
            final upcoming = state.upcomingModel.results ?? [];
            if (upcoming.isEmpty) {
              return Text('No upcoming movies');
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Upcoming Movies', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                ...upcoming.take(5).map((item) => GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MovieDetailsView(movieId: item.id!),
                          ),
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            if (item.posterPath != null)
                              Container(
                                width: 60,
                                height: 90,
                                margin: EdgeInsets.all(8),
                                child: Image.network(
                                  'https://image.tmdb.org/t/p/w200${item.posterPath}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.title ?? '', style: TextStyle(fontWeight: FontWeight.bold)),
                                    if (item.releaseDate != null)
                                      Text('Release: ${item.releaseDate!.day}/${item.releaseDate!.month}/${item.releaseDate!.year}', style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                                    if (item.overview != null && item.overview!.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4.0),
                                        child: Text(item.overview!, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13)),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
              ],
            );
          } else if (state is UpcomingsError) {
            return Text('Error: ${state.message}');
          } else {
            return Text('Loading upcoming movies...');
          }
        },
      ),
    );
  }
}
