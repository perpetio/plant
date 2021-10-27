import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:plant/models/plant_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial());

  int currentPromo = 0;

  // PlantsModels plantsModels;
  List<PlantsModels> listPlantsModels;

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is HomeInitialEvent) {
      yield HomeLoadingState();
      await _getPlantsData();
      yield HomeInitial();
    } else if (event is NextImageEvent) {
      currentPromo = event.index;
      yield RefreshState();
    }

    if (event is RefreshEvent) {
      yield InitialOrderingState();
    }
  }

  Future<void> _getPlantsData() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("plants")
        .orderBy("createdAt")
        .get();

    final lstPlantsModels = snapshot.docs
        .map((e) => PlantsModels.fromJson({
              "images": e["images"] == null ? [] : e["images"],
              "suggestions": e["suggestions"] == null ? [] : e["suggestions"],
            }))
        .toList();
    if (lstPlantsModels.isNotEmpty) {
      listPlantsModels = lstPlantsModels;
    }
  }
}
