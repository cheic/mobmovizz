part of 'upcomings_bloc.dart';

abstract class UpcomingsEvent extends Equatable {
  const UpcomingsEvent();

  @override
  List<Object?> get props => [];
}

class FetchUpcomings extends UpcomingsEvent {
  final BuildContext? context;
  
  const FetchUpcomings({this.context});
  
  @override
  List<Object?> get props => [context];
}
