import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mobmovizz/core/error/failure.dart';
import 'package:mobmovizz/features/movies/data/overview_service.dart';
import 'package:mobmovizz/features/movies/data/models/discover_model.dart';

part 'overview_event.dart';
part 'overview_state.dart';

class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  final DiscoverService discoverService;
  DiscoverBloc(this.discoverService) : super(DiscoverInitial()) {
    on<DiscoverEvent>(_onFetchMovies);
  }


  void _onFetchMovies(
      DiscoverEvent discoverEvent, Emitter<DiscoverState> emit) async {
    emit(DiscoverLoading());
    final Either<Failure, DiscoverModel> failureOrMovies =
        await discoverService.discover();
    emit(failureOrMovies.fold((failure) => DiscoverError(failure.message ?? ""),
        (data) => DiscoverLoaded(data)));
  }
}
