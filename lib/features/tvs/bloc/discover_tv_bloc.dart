import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mobmovizz/core/error/failure.dart';
import 'package:mobmovizz/features/home/upcomings/data/models/upcoming_model.dart';
import 'package:mobmovizz/features/home/upcomings/data/service/upcomings_service.dart';

part 'discover_tv_event.dart';
part 'discover_tv_state.dart';

class DiscoverTvBloc extends Bloc<DiscoverTvEvent, DiscoverTvState> {
  final UpcomingService discoverService;
  DiscoverTvBloc(this.discoverService) : super(DiscoverTvInitial()) {

    on<DiscoverTvEvent>(_onFetchTv);
  }


    void _onFetchTv( DiscoverTvEvent discoverEvent, Emitter<DiscoverTvState> emit) async {
    emit(DiscoverTvLoading());
    final Either<Failure, UpcomingModel> failureOrMovies =
        await discoverService.getUpcomings();
    emit(failureOrMovies.fold((failure) => DiscoverTvError(failure.message ?? ""),
        (data) => DiscoverTvLoaded(data)));
  }
}
