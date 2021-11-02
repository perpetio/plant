part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoadingState extends HomeState {}

class InitialOrderingState extends HomeState {
  List<Object> get props => [];
}

class RefreshState extends HomeState {
  List<Object> get props => [];
}

class SearchPlantsState extends HomeState {
  final List<PlantsModels> plantsModels;

  SearchPlantsState({
    @required this.plantsModels,
  });
}

class SearchBackTappedState extends HomeState {}

class OpenPlantDetailState extends HomeState {
  final PlantsModels plant;

  OpenPlantDetailState({
    @required this.plant,
  });
}

class AvatarTappedState extends HomeState {}
