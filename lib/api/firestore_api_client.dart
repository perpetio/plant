import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:plant/models/plant_model.dart';
import 'package:plant/models/user_data.dart';

class FirestoreApiClient {
  static Future<dynamic> getData() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();

    final Map<String, dynamic> userData = snapshot.data();
    final UserData user = UserData.fromJson(userData);
    return user;
  }

  static Future<void> deletePlantItem(PlantsModels plant) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('plants')
        .doc(plant.plantId)
        .delete();
  }

  static Future<List<PlantsModels>> getPlantsData() async {
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
              "plantId": e.id,
            }))
        .toList();

    return lstPlantsModels;
  }

  static Future<String> addPlant(
    File image,
    PlantsModels plantsModels,
    bool plantExistInList, {
    VoidCallback onSuccess,
    VoidCallback onError,
  }) async {
    DocumentReference sightingRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('plants')
        .doc();

    final plantImage = await uploadFile(image);

    final listPlantImage = plantsModels.plantsImages[0].toJson();
    final listPlantModel = plantsModels.plantModels[0].toJson();

    if (plantExistInList == false) {
      sightingRef.set({
        "createdAt": DateTime.now().microsecondsSinceEpoch,
        "images": [listPlantImage],
        "suggestions": [listPlantModel],
      });
      onSuccess();
    } else if (plantExistInList == true) {
      onError();
    }

    return plantImage;
  }

  static Future<String> uploadFile(File image) async {
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
