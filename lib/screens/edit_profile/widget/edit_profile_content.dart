import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant/models/user_data.dart';
import 'package:plant/screens/common_widget/plants_text_field.dart';
import 'package:plant/screens/common_widget/plants_button.dart';
import 'package:plant/screens/common_widget/plants_loading.dart';
import 'package:plant/screens/edit_profile/bloc/edit_profile_bloc.dart';
import 'package:plant/service/validation_service.dart';
import 'package:plant/utils/router.dart';

class EditProfileContent extends StatefulWidget {
  final UserData user;

  EditProfileContent({
    @required this.user,
  });
  @override
  _EditProfileContentState createState() => _EditProfileContentState();
}

class _EditProfileContentState extends State<EditProfileContent> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();

  @override
  void initState() {
    userNameController.text = widget.user.name;
    userEmailController.text = widget.user.email;

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
                widget.user.imageUrl = state.userImage;
              return _getImage(bloc);
            },
          )),
          const SizedBox(height: 15),
          Center(child: _changeImage(bloc)),
          const SizedBox(height: 15),
          _getUserData(bloc),
          const SizedBox(height: 20),
          _createChangePassword(),
          const SizedBox(height: 15),
          _createSaveButton(bloc),
        ],
      ),
    );
  }

  Widget _getImage(EditProfileBloc bloc) {
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

  Widget _getUserData(EditProfileBloc bloc) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: BlocBuilder<EditProfileBloc, EditProfileState>(
        buildWhen: (_, currState) => currState is EditProfileShowErrorState,
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PlantsTextField(
                controller: userNameController,
                errorText: 'Enter a valid name (more than 1 character)',
                isError: state is EditProfileShowErrorState
                    ? !ValidationService.username(userNameController.text)
                    : false,
                placeHolder: 'Enter your name',
                title: 'Name',
              ),
              SizedBox(height: 15),
              PlantsTextField(
                controller: userEmailController,
                errorText: 'Enter a valid email',
                isError: state is EditProfileShowErrorState
                    ? !ValidationService.email(userEmailController.text)
                    : false,
                placeHolder: 'Enter your email',
                title: 'Email',
              ),
            ],
          );
        },
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
                emailController: userEmailController,
                nameController: userNameController),
          );
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
}
