import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobmovizz/core/utils/app_preferences.dart';
import 'package:mobmovizz/features/watchlist/bloc/watchlist_event.dart';
import 'package:mobmovizz/features/watchlist/bloc/watchlist_state.dart';
import 'package:mobmovizz/core/services/notification_service.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  final AppPreferences _appPreferences;

  WatchlistBloc(this._appPreferences) : super(WatchlistInitial()) {
    on<LoadWatchlistEvent>(_onLoadWatchlist);
    on<AddToWatchlistEvent>(_onAddToWatchlist);
    on<RemoveFromWatchlistEvent>(_onRemoveFromWatchlist);
    on<UpdateWatchlistItemEvent>(_onUpdateWatchlistItem);
  }

  void _onLoadWatchlist(LoadWatchlistEvent event, Emitter<WatchlistState> emit) async {
    emit(WatchlistLoading());
    try {
      final watchlist = _appPreferences.getWatchlist();
      emit(WatchlistLoaded(watchlist));
    } catch (e) {
      emit(WatchlistError('Failed to load watchlist: $e'));
    }
  }

  void _onAddToWatchlist(AddToWatchlistEvent event, Emitter<WatchlistState> emit) async {
    try {
      final currentWatchlist = _appPreferences.getWatchlist();
      
      // Check if already exists
      if (currentWatchlist.any((item) => item.id == event.movieId)) {
        emit(WatchlistError('Movie is already in your watchlist'));
        return;
      }

      final newItem = WatchlistItem(
        id: event.movieId,
        title: event.title,
        posterPath: event.posterPath,
        releaseDate: event.releaseDate,
        reminderDate: event.reminderDate,
        notifyAgain: event.notifyAgain,
        addedDate: DateTime.now(),
      );

      currentWatchlist.add(newItem);
      await _appPreferences.saveWatchlist(currentWatchlist);

      // Schedule a notification for the movie reminder
      if (event.reminderDate != null) {
        await NotificationService.scheduleMovieReminder(
          movieId: newItem.id.hashCode,
          movieTitle: newItem.title,
          reminderDateTime: event.reminderDate!,
          notificationTitle: event.notificationTitle,
          notificationBody: event.notificationBody,
        );
      }

      emit(WatchlistLoaded(currentWatchlist));
    } catch (e) {
      emit(WatchlistError('Failed to add movie to watchlist: $e'));
    }
  }

  void _onRemoveFromWatchlist(RemoveFromWatchlistEvent event, Emitter<WatchlistState> emit) async {
    try {
      final currentWatchlist = _appPreferences.getWatchlist();
      currentWatchlist.removeWhere((item) => item.id == event.movieId);
      await _appPreferences.saveWatchlist(currentWatchlist);
      
      emit(WatchlistLoaded(currentWatchlist));
    } catch (e) {
      emit(WatchlistError('Failed to remove movie from watchlist: $e'));
    }
  }

  void _onUpdateWatchlistItem(UpdateWatchlistItemEvent event, Emitter<WatchlistState> emit) async {
    try {
      final currentWatchlist = _appPreferences.getWatchlist();
      final index = currentWatchlist.indexWhere((item) => item.id == event.movieId);
      
      if (index != -1) {
        currentWatchlist[index] = event.updatedItem;
        await _appPreferences.saveWatchlist(currentWatchlist);
        
        // Reschedule notification with new date/time if reminder date is set
        if (event.updatedItem.reminderDate != null) {
          await NotificationService.scheduleMovieReminder(
            movieId: event.updatedItem.id.hashCode,
            movieTitle: event.updatedItem.title,
            reminderDateTime: event.updatedItem.reminderDate!,
            notificationTitle: event.notificationTitle,
            notificationBody: event.notificationBody,
          );
        }
        
        emit(WatchlistLoaded(currentWatchlist));
      } else {
        emit(WatchlistError('Movie not found in watchlist'));
      }
    } catch (e) {
      emit(WatchlistError('Failed to update watchlist item: $e'));
    }
  }
}
