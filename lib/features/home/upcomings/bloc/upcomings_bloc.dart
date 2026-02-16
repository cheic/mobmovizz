import 'package:flutter/services.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mobmovizz/core/error/failure.dart';
import 'package:mobmovizz/features/home/upcomings/data/models/upcoming_model.dart';
import 'package:mobmovizz/features/home/upcomings/data/service/upcomings_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'upcomings_event.dart';
part 'upcomings_state.dart';

class UpcomingsBloc extends Bloc<UpcomingsEvent, UpcomingsState> {
  final UpcomingService upcomingService;
  UpcomingsBloc(this.upcomingService) : super(UpcomingsInitial()) {

    on<UpcomingsEvent>(_onFetchUpcomings);
  }


    void _onFetchUpcomings(UpcomingsEvent discoverEvent, Emitter<UpcomingsState> emit) async {
      emit(UpcomingsLoading());
      
      final Either<Failure, UpcomingModel> failureOrMovies = await upcomingService.getUpcomings();
      await failureOrMovies.fold(
        (failure) async {
          emit(UpcomingsError(failure.message ?? ""));
        },
        (data) async {
          emit(UpcomingsLoaded(data));
          // Sauvegarde dans SharedPreferences pour le widget Android
          final prefs = await SharedPreferences.getInstance();
          final jsonString = upcomingModelToJson(data);
          await prefs.setString('upcoming_movies', jsonString);
          // Appel natif pour rafraîchir le widget Android
          try {
            const channel = MethodChannel('mobmovizz/widget');
            await channel.invokeMethod('updateUpcomingWidget');
          } catch (e) {
            // Widget update error handled silently
          }
        },
      );
    }
}
