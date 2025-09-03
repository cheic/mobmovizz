part of 'top_rated_bloc.dart';

sealed class TopRatedEvent extends Equatable {
  const TopRatedEvent();

  @override
  List<Object?> get props => [];
}

class FetchTopRated extends TopRatedEvent{
  final BuildContext? context;
  
  const FetchTopRated({this.context});
  
  @override
  List<Object?> get props => [context];
}
