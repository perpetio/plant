import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial());

  int currentPromo = 0;

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is NextImageEvent) {
      currentPromo = event.index;

      yield RefreshState();
    }

    if (event is RefreshEvent) {
      yield InitialOrderingState();
    }
  }
}
