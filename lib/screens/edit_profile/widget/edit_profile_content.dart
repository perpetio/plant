import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant/screens/common_widget/edit_account_container.dart';
import 'package:plant/screens/common_widget/edit_account_textfield.dart';
import 'package:plant/screens/common_widget/plant_button.dart';
import 'package:plant/screens/edit_profile/bloc/edit_profile_bloc.dart';
import 'package:plant/service/validation_service.dart';

class EditProfileContent extends StatefulWidget {
  @override
  _EditProfileContentState createState() => _EditProfileContentState();
}

class _EditProfileContentState extends State<EditProfileContent> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final User user = FirebaseAuth.instance.currentUser;
  String photoUrl;
  bool isNameInvalid = false;
  bool isEmailInvalid = false;
  String userName;
  String userEmail;

  void initState() {
    final bloc = BlocProvider.of<EditProfileBloc>(context);

    userName = bloc.userData['name'] ?? "No Username";
    userEmail = bloc.userData['email'] ?? 'No email';
    photoUrl = bloc.userData['image'] ?? null;
    _nameController.text = userName;
    _emailController.text = userEmail;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<EditProfileBloc>(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Center(child: _getImage()),
          const SizedBox(height: 15),
          Center(
            child: _changeImage(bloc),
          ),
          SizedBox(height: 15),
          _getUserData(),
          const SizedBox(height: 15),
          _createSaveButton(bloc),
        ],
      ),
    );
  }

  Widget _getImage() {
    if (photoUrl != null) {
      if (photoUrl.startsWith('https://')) {
        return CircleAvatar(
            backgroundImage: NetworkImage(photoUrl), radius: 80);
      } else {
        return CircleAvatar(
            backgroundImage: AssetImage('assets/images/profile.png'),
            radius: 80);
      }
    }
    return Container();
  }

  Widget _changeImage(EditProfileBloc bloc) {
    return TextButton(
      onPressed: () {
        bloc.add(EditProfileChangeImageEvent());
      },
      child: Text(
        'Edit photo',
        style: TextStyle(
          color: Colors.blue,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _getUserData() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Name'),
          EditAccountContainer(
            child: EditAccountTextField(
              controller: _nameController,
              placeHolder: 'Enter your name',
            ),
          ),
          SizedBox(height: 15),
          Text('Email'),
          EditAccountContainer(
            child: EditAccountTextField(
              controller: _emailController,
              placeHolder: 'Enter your email',
            ),
          ),
        ],
      ),
    );
  }

  Widget _createSaveButton(EditProfileBloc bloc) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: PlantButton(
        title: 'Save',
        onTap: () {},
      ),
    );
  }
}
