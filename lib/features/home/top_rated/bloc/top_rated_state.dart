part of 'top_rated_bloc.dart';

sealed class TopRatedState extends Equatable {
  const TopRatedState();
  
  @override
  List<Object> get props => [];
}

final class TopRatedInitial extends TopRatedState {}
