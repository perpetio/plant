import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:plant/service/validation_service.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc() : super(EditProfileInitial());

  Map<String, dynamic> userData;
  TextEditingController userNameController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  File _image;
  String imageURL;
  String userName;
  String userEmail;
  String userImage;

  @override
  Stream<EditProfileState> mapEventToState(
    EditProfileEvent event,
  ) async* {
    if (event is EditProfileInitialEvent) {
      yield EditProfileProgress();
      _getUserData();
      yield EditProfileInitial();
    } else if (event is EditProfileChangeImageEvent) {
      _pickImageFromGallery();
    } else if (event is EditProfileTakeImageEvent) {
      _takeImageFromCamera();
    } else if (event is EditProfileReloadImageEvent) {
      yield EditProfileReloadImageState(userImage: event.userImage);
    } else if (event is EditProfileChangeDataEvent) {
      if (_checkValidatorsOfTextField(
          userNameController.text, userEmailController.text)) {
        try {
          // yield EditProfileProgress();
          _saveData();
        } catch (e) {
          log(e.toString());
          yield EditProfileErrorState(message: e.toString());
        }
      } else {
        yield EditProfileShowErrorState();
      }
    }
  }

  Future<void> _getUserData() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();

    userData = snapshot.data();
    userName = userData['name'] == null ? "No Username" : userData['name'];
    userEmail = userData['email'] == null ? "No email" : userData['email'];
    userImage = userData['image'] == null ? "No image" : userData['image'];
    userNameController.text = userName;
    userEmailController.text = userEmail;
  }

  Future<void> _pickImageFromGallery() async {
    HapticFeedback.selectionClick();
    PickedFile image =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (image == null) return null;

    _image = File(image.path);

    DocumentReference sightingRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid);

    await saveImages(_image, sightingRef);
  }

  Future<void> _takeImageFromCamera() async {
    PickedFile image = await ImagePicker().getImage(source: ImageSource.camera);
    if (image == null) return null;

    _image = File(image.path);

    DocumentReference sightingRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid);

    await saveImages(_image, sightingRef);
  }

  Future<void> saveImages(File _image, DocumentReference ref) async {
    String imageURL = await uploadFile(_image);
    add(EditProfileReloadImageEvent(userImage: imageURL));
    ref.update(
      {
        "image": imageURL,
      },
    );
  }

  Future<String> uploadFile(File _image) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(_image.path.split('/').last);
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    // String returnURL;
    await storageReference.getDownloadURL().then((fileURL) {
      imageURL = fileURL;
    });
    return imageURL;
  }

  void _saveData() {
    DocumentReference sightingRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid);
    sightingRef.update({
      "name": userNameController.text,
      "email": userEmailController.text,
    });
  }

  bool _checkValidatorsOfTextField(String userName, String email) {
    return ValidationService.username(userName) &&
        ValidationService.email(email);
  }
}
