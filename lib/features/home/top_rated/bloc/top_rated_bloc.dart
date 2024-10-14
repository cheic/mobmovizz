import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'top_rated_event.dart';
part 'top_rated_state.dart';

class TopRatedBloc extends Bloc<TopRatedEvent, TopRatedState> {
  TopRatedBloc() : super(TopRatedInitial()) {
    on<TopRatedEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
