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
import 'package:plant/models/user_data.dart';
import 'package:plant/service/auth_service.dart';
import 'package:plant/service/user_service.dart';
import 'package:plant/service/validation_service.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc() : super(EditProfileInitial());

  UserData user;
  File _image;
  String imageURL;

  @override
  Stream<EditProfileState> mapEventToState(
    EditProfileEvent event,
  ) async* {
    if (event is EditProfileInitialEvent) {
      yield EditProfileProgress();
      yield EditProfileInitial();
    } else if (event is EditProfileChangeImageEvent) {
      _pickImageFromGallery();
    } else if (event is EditProfileTakeImageEvent) {
      _takeImageFromCamera();
    } else if (event is EditProfileReloadImageEvent) {
      yield EditProfileReloadImageState(userImage: event.userImage);
    } else if (event is EditProfileChangeDataEvent) {
      if (_checkValidatorsOfTextField(
          event.nameController.text, event.emailController.text)) {
        try {
          await UserService.changeUserEmail(
              email: event.emailController.text,
              password: event.passwordController.text);
          _saveData(event.nameController, event.emailController);
          yield EditProfileSuccessState(message: 'Data successfully updated!');
        } catch (e) {
          log(e.toString());
          yield EditProfileErrorState(message: e.toString());
        }
      } else {
        yield EditProfileShowErrorState();
      }
    }
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
    await storageReference.getDownloadURL().then((fileURL) {
      imageURL = fileURL;
    });
    return imageURL;
  }

  void _saveData(TextEditingController nameController,
      TextEditingController emailController) {
    DocumentReference sightingRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid);
    if (emailController.text == AuthService.auth.currentUser.email) {
      sightingRef.update({
        "name": nameController.text,
        "email": emailController.text,
      });
    }
  }

  bool _checkValidatorsOfTextField(String userName, String email) {
    return ValidationService.username(userName) &&
        ValidationService.email(email);
  }
}
