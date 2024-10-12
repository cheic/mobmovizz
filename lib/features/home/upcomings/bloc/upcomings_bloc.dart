import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mobmovizz/core/error/failure.dart';
import 'package:mobmovizz/features/home/upcomings/data/models/upcoming_model.dart';
import 'package:mobmovizz/features/home/upcomings/data/service/upcomings_service.dart';

part 'upcomings_event.dart';
part 'upcomings_state.dart';

class UpcomingsBloc extends Bloc<UpcomingsEvent, UpcomingsState> {
  final UpcomingService upcomingService;
  UpcomingsBloc(this.upcomingService) : super(UpcomingsInitial()) {

    on<UpcomingsEvent>(_onFetchUpcomings);
  }


    void _onFetchUpcomings( UpcomingsEvent discoverEvent, Emitter<UpcomingsState> emit) async {
    emit(UpcomingsLoading());
    final Either<Failure, UpcomingModel> failureOrMovies =
        await upcomingService.getUpcomings();
        failureOrMovies.fold((l) {
          
        },
        (r){
          print(" RRRRR $r");
        });

      
    emit(failureOrMovies.fold((failure) => UpcomingsError(failure.message ?? ""),
        (data) => UpcomingsLoaded(data)));
  }
}
