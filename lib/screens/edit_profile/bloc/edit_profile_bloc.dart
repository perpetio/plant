import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc() : super(EditProfileInitial());

  Map<String, dynamic> userData;
  ImagePicker picker;
  File _image;

  @override
  Stream<EditProfileState> mapEventToState(
    EditProfileEvent event,
  ) async* {
    if (event is EditProfileInitialEvent) {
      yield EditAccountProgress();
      _getUserData();
      yield EditProfileInitial();
    } else if (event is EditProfileChangeImageEvent) {
      _pickImage();
    } else if (event is EditProfileChangeDataEvent) {
      _saveData();
    }
  }

  Future<dynamic> _getUserData() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();

    userData = snapshot.data();
  }

  void _pickImage() async {
    //this function to pick the image from galery

    HapticFeedback.selectionClick();
    PickedFile image = await picker.getImage(source: ImageSource.gallery);
    if (image == null) return null;

    _image = File(image.path);

    DocumentReference sightingRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid);

    await saveImages(_image, sightingRef);
  }

  Future<void> saveImages(File _image, DocumentReference ref) async {
    String imageURL = await uploadFile(_image);
    ref.update(
      {"image": imageURL},
    );
  }

  Future<String> uploadFile(File _image) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(_image.path.split('/').last);
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    String returnURL;
    await storageReference.getDownloadURL().then((fileURL) {
      returnURL = fileURL;
    });
    return returnURL;
  }

  void _saveData() {}
}
