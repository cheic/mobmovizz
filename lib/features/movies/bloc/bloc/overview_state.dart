part of 'overview_bloc.dart';

sealed class DiscoverState extends Equatable {
  const DiscoverState();

  @override
  List<Object> get props => [];
}

final class DiscoverInitial extends DiscoverState {}

final class DiscoverLoading extends DiscoverState {}

final class DiscoverLoaded extends DiscoverState {
  final DiscoverModel discoverModel;

  const DiscoverLoaded(this.discoverModel);

  @override
  List<Object> get props => [discoverModel];
}

class DiscoverError extends DiscoverState {
  final String message;

  const DiscoverError(this.message);

  @override
  List<Object> get props => [message];
}
