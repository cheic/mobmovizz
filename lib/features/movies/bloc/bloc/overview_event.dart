part of 'overview_bloc.dart';

abstract class DiscoverEvent extends Equatable {
  const DiscoverEvent();

  @override
  List<Object> get props => [];
}

class FetchDiscover extends DiscoverEvent {}
