part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class HomeInitialEvent extends HomeEvent {}

class NextImageEvent extends HomeEvent {
  final int index;

  NextImageEvent({
    this.index,
  });

  List<Object> get props => [index];
}

class RefreshEvent extends HomeEvent {
  List<Object> get props => [];
}

class SearchPlantsEvent extends HomeEvent {
  final String query;

  SearchPlantsEvent({
    @required this.query,
  });
}

class SearchBackTappedEvent extends HomeEvent {}

class SearchClearTappedEvent extends HomeEvent {}

class OpenPlantDetailEvent extends HomeEvent {
  final PlantsModels plant;

  OpenPlantDetailEvent({
    @required this.plant,
  });
}
