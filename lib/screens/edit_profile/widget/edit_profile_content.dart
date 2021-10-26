import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant/screens/common_widget/edit_account_container.dart';
import 'package:plant/screens/common_widget/edit_account_textfield.dart';
import 'package:plant/screens/common_widget/plant_button.dart';
import 'package:plant/screens/common_widget/plants_loading.dart';
import 'package:plant/screens/edit_profile/bloc/edit_profile_bloc.dart';

class EditProfileContent extends StatefulWidget {
  @override
  _EditProfileContentState createState() => _EditProfileContentState();
}

class _EditProfileContentState extends State<EditProfileContent> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String photoUrl = '';
  String userName = '';
  String userEmail = '';

  @override
  void initState() {
    // ignore: close_sinks
    final bloc = BlocProvider.of<EditProfileBloc>(context);

    if (bloc.userData != null) {
      userName =
          bloc.userData['name'] == null ? "No Username" : bloc.userData['name'];
      userEmail =
          bloc.userData['email'] == null ? "No email" : bloc.userData['email'];
      photoUrl = bloc.userData['image'] == null
          ? "assets/images/profile.png"
          : bloc.userData['image'];
      _nameController.text = userName;
      _emailController.text = userEmail;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<EditProfileBloc>(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Center(
              child: BlocBuilder<EditProfileBloc, EditProfileState>(
            buildWhen: (_, currState) =>
                currState is EditProfileReloadImageState,
            builder: (context, state) {
              if (state is EditProfileReloadImageState)
                photoUrl = state.userImage;
              return _getImage();
            },
          )),
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
    return PlantsLoading();
  }

  Widget _changeImage(EditProfileBloc bloc) {
    return TextButton(
      onPressed: () {
        _showPickImageAlert(context, bloc);
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
        onTap: () {
          bloc.add(
            EditProfileChangeDataEvent(
              userEmail: _emailController.text,
              userName: _nameController.text,
            ),
          );
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showPickImageAlert(BuildContext context, EditProfileBloc bloc) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Text('Choose image source'),
        actions: [
          TextButton(
            child: Text('Camera'),
            onPressed: () => _getCameraImage(bloc, context),
          ),
          TextButton(
              child: Text('Gallery'),
              onPressed: () => _getGalleryImage(bloc, context)),
        ],
      ),
    );
  }

  void _getCameraImage(EditProfileBloc bloc, BuildContext context) {
    bloc.add(EditProfileTakeImageEvent());
    Navigator.of(context).pop();
  }

  void _getGalleryImage(EditProfileBloc bloc, BuildContext context) {
    bloc.add(EditProfileChangeImageEvent());
    Navigator.of(context).pop();
  }
}
