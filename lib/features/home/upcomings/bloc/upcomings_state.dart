part of 'upcomings_bloc.dart';

sealed class UpcomingsState extends Equatable {
  const UpcomingsState();

  @override
  List<Object> get props => [];
}

final class UpcomingsInitial extends UpcomingsState {}

final class UpcomingsLoading extends UpcomingsState {}

final class UpcomingsLoaded extends UpcomingsState {
  final UpcomingModel upcomingModel;

  const UpcomingsLoaded(this.upcomingModel);

  @override
  List<Object> get props => [upcomingModel];
}


class UpcomingsError extends UpcomingsState {
  final String message;

  const UpcomingsError(this.message);

  @override
  List<Object> get props => [message];
}
