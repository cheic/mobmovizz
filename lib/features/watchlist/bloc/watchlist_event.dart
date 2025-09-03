import 'package:equatable/equatable.dart';
import 'package:mobmovizz/core/utils/app_preferences.dart';

sealed class WatchlistEvent extends Equatable {
  const WatchlistEvent();

  @override
  List<Object> get props => [];
}

class LoadWatchlistEvent extends WatchlistEvent {
  const LoadWatchlistEvent();
}

class AddToWatchlistEvent extends WatchlistEvent {
  final int movieId;
  final String title;
  final String? posterPath;
  final String? releaseDate;
  final DateTime? reminderDate;
  final bool notifyAgain;

  const AddToWatchlistEvent({
    required this.movieId,
    required this.title,
    this.posterPath,
    this.releaseDate,
    this.reminderDate,
    this.notifyAgain = true,
  });

  @override
  List<Object> get props => [movieId, title, posterPath ?? '', releaseDate ?? '', reminderDate ?? DateTime.now(), notifyAgain];
}

class RemoveFromWatchlistEvent extends WatchlistEvent {
  final int movieId;

  const RemoveFromWatchlistEvent(this.movieId);

  @override
  List<Object> get props => [movieId];
}

class UpdateWatchlistItemEvent extends WatchlistEvent {
  final int movieId;
  final WatchlistItem updatedItem;

  const UpdateWatchlistItemEvent({
    required this.movieId,
    required this.updatedItem,
  });

  @override
  List<Object> get props => [movieId, updatedItem];
}