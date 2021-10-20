import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:plant/api/plant_id_api.dart';
import 'package:plant/models/plant_model.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

part 'scan_event.dart';
part 'scan_state.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  ScanBloc() : super(ScanInitial());

  CameraController controller;
  Future<void> initializeControllerFuture;
  final RoundedLoadingButtonController takePhotoController =
      new RoundedLoadingButtonController();
  final RoundedLoadingButtonController addPlantController =
      new RoundedLoadingButtonController();
  bool toggleFlash = false;
  File image;
  bool isFromGallery = false;
  final picker = ImagePicker();
  AnimationController animationController;
  Animation<Offset> offset;
  String plantImage;

  PlantModel plantModel;
  PlantsModels plantsModels;

  @override
  Stream<ScanState> mapEventToState(
    ScanEvent event,
  ) async* {
    if (event is PickImageEvent) {
      _pickImage();
    } else if (event is TakeImageEvent) {
      _takeImage();
    } else if (event is GetDataPlantEvent) {
      try {
        plantsModels = await getPlants(event.image);
        print(plantsModels.toJson());
        if (plantsModels.plantModels.isNotEmpty) {
          plantModel = plantsModels.plantModels[0];
        }
        yield ScanGetPlantImage(image: event.image.toString());
        yield DataPlantGotState(plantModel: plantModel);
      } catch (e) {
        yield ScanErrorState(message: e.toString());
      }
    } else if (event is AddPlantEvent) {
      _addPlant();
    }
  }

  void _pickImage() async {
    //this function to pick the image from galery

    HapticFeedback.selectionClick();
    PickedFile pickedImage = await picker.getImage(source: ImageSource.gallery);
    if (pickedImage == null) return null;

    image = File(pickedImage.path);
    isFromGallery = true;
    takePhotoController.start();

    add(GetDataPlantEvent(image: image));

    takePhotoController.stop();

    switch (animationController.status) {
      case AnimationStatus.completed:
        animationController.reverse();
        break;
      case AnimationStatus.dismissed:
        animationController.forward();
        break;
      default:
    }
    isFromGallery = false;
  }

  void _takeImage() async {
    //this function to take the image from camera

    HapticFeedback.mediumImpact();
    addPlantController.reset();
    if (!isFromGallery) {
      await initializeControllerFuture;

      final imageCamera = await controller.takePicture();
      image = File(imageCamera.path);

      add(GetDataPlantEvent(image: image));

      switch (animationController.status) {
        case AnimationStatus.completed:
          animationController.reverse();
          break;
        case AnimationStatus.dismissed:
          animationController.forward();
          break;
        default:
      }
      takePhotoController.stop();
    }
  }

  void _addPlant() async {
    HapticFeedback.selectionClick();
    DocumentReference sightingRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('plants')
        .doc();

    plantImage = await uploadFile(image);

    final listPlantImage = plantsModels.plantsImages[0].toJson();
    final listPlantModel = plantsModels.plantModels[0].toJson();

    sightingRef.set({
      "images": [listPlantImage],
      "suggestions": [listPlantModel],
    });

    addPlantController.success();
  }

  Future<String> uploadFile(File image) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(image.path.split('/').last);
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;
    print('File Uploaded');
    String returnURL;
    await storageReference.getDownloadURL().then((fileURL) {
      returnURL = fileURL;
    });
    return returnURL;
  }
}
