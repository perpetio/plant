part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class InitialOrderingState extends HomeState {
  List<Object> get props => [];
}

class RefreshState extends HomeState {
  List<Object> get props => [];
}
