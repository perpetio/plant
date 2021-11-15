import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'plant_event.dart';
part 'plant_state.dart';

class PlantBloc extends Bloc<PlantEvent, PlantState> {
  PlantBloc() : super(PlantInitial());

  @override
  Stream<PlantState> mapEventToState(
    PlantEvent event,
  ) async* {
    if (event is PlantBackTappedEvent) {
      yield PlantBackTappedState();
    }
  }
}
