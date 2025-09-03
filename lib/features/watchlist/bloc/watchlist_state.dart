import 'package:equatable/equatable.dart';
import 'package:mobmovizz/core/utils/app_preferences.dart';

sealed class WatchlistState extends Equatable {
  const WatchlistState();
  
  @override
  List<Object> get props => [];
}

final class WatchlistInitial extends WatchlistState {
  const WatchlistInitial();
}

final class WatchlistLoading extends WatchlistState {
  const WatchlistLoading();
}

final class WatchlistLoaded extends WatchlistState {
  final List<WatchlistItem> watchlist;

  const WatchlistLoaded(this.watchlist);

  @override
  List<Object> get props => [watchlist];
}

final class WatchlistError extends WatchlistState {
  final String message;

  const WatchlistError(this.message);

  @override
  List<Object> get props => [message];
}
