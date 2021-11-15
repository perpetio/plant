import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:plant/api/firestore_api_client.dart';
import 'package:plant/models/plant_model.dart';
import 'package:plant/models/user_data.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial());

  int currentPromo = 0;
  UserData user;
  List<PlantsModels> listPlantsModels = <PlantsModels>[];

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is HomeInitialEvent) {
      // yield HomeLoadingState();
      user = await FirestoreApiClient.getData();
      listPlantsModels = await FirestoreApiClient.getPlantsData();
      yield HomeInitial();
    } else if (event is NextImageEvent) {
      currentPromo = event.index;
      yield RefreshState();
    } else if (event is RefreshEvent) {
      yield InitialOrderingState();
    } else if (event is SearchPlantsEvent) {
      final plants = _getPlantsByQuery(event.query);
      yield SearchPlantsState(plantsModels: plants);
    } else if (event is SearchBackTappedEvent) {
      yield SearchBackTappedState();
    } else if (event is SearchClearTappedEvent) {
    } else if (event is OpenPlantDetailEvent) {
      yield OpenPlantDetailState(plant: event.plant);
    } else if (event is AvatarTappedEvent) {
      yield AvatarTappedState();
    } else if (event is DeletePlantItemEvent) {
      await FirestoreApiClient.deletePlantItem(event.plant);
    }
  }

  List<PlantsModels> _getPlantsByQuery(String query) {
    final List<PlantsModels> foundPlants = listPlantsModels
        .where((PlantsModels plant) =>
            plant.plantModels
                .map((e) => e.plantName)
                .toString()
                .toLowerCase()
                .indexOf(query.toLowerCase()) >
            -1)
        .toList();

    return foundPlants;
  }
}
