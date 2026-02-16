import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mobmovizz/core/error/failure.dart';
import 'package:mobmovizz/features/home/top_rated/data/top_rated_service.dart';
import 'package:mobmovizz/features/home/upcomings/data/models/upcoming_model.dart';

part 'top_rated_event.dart';
part 'top_rated_state.dart';

class TopRatedBloc extends Bloc<TopRatedEvent, TopRatedState> {
  final TopRatedService topRatedService;
  TopRatedBloc(this.topRatedService) : super(TopRatedInitial()) {
    on<TopRatedEvent>(_onFetchTopRated);
  }

  void _onFetchTopRated(
      TopRatedEvent event, Emitter<TopRatedState> emit) async {
    emit(TopRatedInitial());

    final Either<Failure, UpcomingModel> failureOrData =
        await topRatedService.getTopRated();

    failureOrData.fold(
        (failure) =>
            emit(TopRatedError(failure.message ?? 'Some error occurs')),
        (data) => emit(TopRatedLoaded(data)));
  }
}
