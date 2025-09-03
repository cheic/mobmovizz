part of 'top_rated_bloc.dart';

sealed class TopRatedState extends Equatable {
  const TopRatedState();
  
  @override
  List<Object> get props => [];
}

final class TopRatedInitial extends TopRatedState {}

final class TopRatedLoading extends TopRatedState {}

final class TopRatedLoaded extends TopRatedState {
  final UpcomingModel upcomingModel;

  const TopRatedLoaded(this.upcomingModel);

  @override
  List<Object> get props => [upcomingModel];
}


class TopRatedError extends TopRatedState {
  final String message;

  const TopRatedError(this.message);

  @override
  List<Object> get props => [message];
}
