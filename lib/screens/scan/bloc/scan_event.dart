part of 'scan_bloc.dart';

@immutable
abstract class ScanEvent {}

class GetDataPlantEvent extends ScanEvent {
  final File image;

  GetDataPlantEvent({
    @required this.image,
  });
}

class PickImageEvent extends ScanEvent {}

class TakeImageEvent extends ScanEvent {}

class AddPlantEvent extends ScanEvent {}
