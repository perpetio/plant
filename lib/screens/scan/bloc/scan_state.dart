part of 'scan_bloc.dart';

@immutable
abstract class ScanState {}

class ScanInitial extends ScanState {}

class DataPlantGotState extends ScanState {
  final PlantModel plantModel;

  DataPlantGotState({
    @required this.plantModel,
  });
}

class ScanErrorState extends ScanState {
  final String message;

  ScanErrorState({@required this.message});
}

class ScanGetPlantImage extends ScanState {
  final String image;

  ScanGetPlantImage({
    @required this.image,
  });
}
