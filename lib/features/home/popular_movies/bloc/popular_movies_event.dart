part of 'popular_movies_bloc.dart';

abstract class PopularMoviesEvent extends Equatable {
  const PopularMoviesEvent();

  @override
  List<Object?> get props => [];
}

class FetchPopularMovies extends PopularMoviesEvent {
  final BuildContext? context;
  
  const FetchPopularMovies({this.context});
  
  @override
  List<Object?> get props => [context];
}
