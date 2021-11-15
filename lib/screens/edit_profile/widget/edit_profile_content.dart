import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant/common_widget/plants_button.dart';
import 'package:plant/common_widget/plants_loading.dart';
import 'package:plant/common_widget/plants_text_field.dart';
import 'package:plant/core/service/auth_service.dart';
import 'package:plant/core/service/modal_service.dart';
import 'package:plant/core/service/validation_service.dart';
import 'package:plant/core/utils/router.dart';
import 'package:plant/models/user_data.dart';
import 'package:plant/screens/edit_profile/bloc/edit_profile_bloc.dart';

class EditProfileContent extends StatefulWidget {
  final UserData user;

  EditProfileContent({
    @required this.user,
  });
  @override
  _EditProfileContentState createState() => _EditProfileContentState();
}

class _EditProfileContentState extends State<EditProfileContent> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController userEmailController = TextEditingController();
  final TextEditingController userPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    userNameController.text = widget.user.name;
    userEmailController.text = widget.user.email;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final EditProfileBloc bloc = BlocProvider.of<EditProfileBloc>(context);
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
                widget.user.imageUrl = state.userImage;
              return _getImage();
            },
          )),
          const SizedBox(height: 15),
          Center(child: _changeImage(bloc)),
          const SizedBox(height: 15),
          _getUserData(),
          const SizedBox(height: 20),
          _createChangePassword(),
          const SizedBox(height: 15),
          _createSaveButton(context, bloc),
        ],
      ),
    );
  }

  Widget _getImage() {
    if (widget.user != null) {
      if (widget.user.imageUrl.startsWith('https://')) {
        return CircleAvatar(
            backgroundImage: NetworkImage(widget.user.imageUrl), radius: 80);
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
          color: Colors.orange,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _getUserData() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: BlocBuilder<EditProfileBloc, EditProfileState>(
        buildWhen: (_, currState) => currState is EditProfileShowErrorState,
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PlantsTextField(
                  controller: userNameController,
                  validator: (name) {
                    if (ValidationService.username(name))
                      return null;
                    else
                      return 'Enter a valid name (more than 1 character)';
                  },
                  placeHolder: 'Enter your name',
                  labelText: 'Name',
                ),
                SizedBox(height: 15),
                PlantsTextField(
                  controller: userEmailController,
                  placeHolder: 'Enter your email',
                  labelText: 'Email',
                  validator: (email) {
                    if (ValidationService.email(email))
                      return null;
                    else
                      return 'Enter a valid email';
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _createSaveButton(BuildContext context, EditProfileBloc bloc) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: PlantButton(
        title: 'Save',
        onTap: () async {
          if (_formKey.currentState.validate()) {
            if (userEmailController.text !=
                AuthService.auth.currentUser.email) {
              _createShowYourPasswordAlert(context, bloc);
            }
          }
        },
      ),
    );
  }

  void _showPickImageAlert(BuildContext context, EditProfileBloc bloc) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Center(
          child: Text(
            'Choose image source',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
        actions: [
          CupertinoButton(
            child: Text('Camera',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.orange,
                    fontWeight: FontWeight.w600)),
            onPressed: () => _getCameraImage(context, bloc),
          ),
          CupertinoButton(
              child: Text('Gallery',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.orange,
                      fontWeight: FontWeight.w600)),
              onPressed: () => _getGalleryImage(context, bloc)),
        ],
      ),
    );
  }

  void _getCameraImage(BuildContext context, EditProfileBloc bloc) {
    bloc.add(EditProfileTakeImageEvent());
    Navigator.of(context).pop();
  }

  void _getGalleryImage(BuildContext context, EditProfileBloc bloc) {
    bloc.add(EditProfileChangeImageEvent());
    Navigator.of(context).pop();
  }

  Widget _createChangePassword() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              Routers.change_password,
            );
          },
          child: Row(
            children: [
              Text(
                'Change password',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.orange,
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 10),
              Icon(Icons.arrow_forward_ios, color: Colors.orange),
            ],
          )),
    );
  }

  void _createShowYourPasswordAlert(
      BuildContext context, EditProfileBloc bloc) {
    ModalService.showPasswordAlertDialog(
      context,
      title: "Enter your password",
      passwordController: userPasswordController,
      onSaveTapped: (password) {
        bloc.add(EditProfileChangeDataEvent(
          nameController: userNameController,
          emailController: userEmailController,
          passwordController: userPasswordController,
        ));
      },
    );
  }
}
