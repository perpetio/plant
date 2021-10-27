import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant/screens/common_widget/plants_container.dart';
import 'package:plant/screens/common_widget/plants_text_field.dart';
import 'package:plant/screens/common_widget/plants_button.dart';
import 'package:plant/screens/common_widget/plants_loading.dart';
import 'package:plant/screens/edit_profile/bloc/edit_profile_bloc.dart';
import 'package:plant/service/validation_service.dart';

class EditProfileContent extends StatefulWidget {
  @override
  _EditProfileContentState createState() => _EditProfileContentState();
}

class _EditProfileContentState extends State<EditProfileContent> {
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
                bloc.userImage = state.userImage;
              return _getImage(bloc);
            },
          )),
          const SizedBox(height: 15),
          Center(
            child: _changeImage(bloc),
          ),
          SizedBox(height: 15),
          _getUserData(bloc),
          const SizedBox(height: 15),
          _createSaveButton(bloc),
        ],
      ),
    );
  }

  Widget _getImage(EditProfileBloc bloc) {
    if (bloc.userImage != null) {
      if (bloc.userImage.startsWith('https://')) {
        return CircleAvatar(
            backgroundImage: NetworkImage(bloc.userImage), radius: 80);
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
                controller: bloc.userNameController,
                errorText: 'Enter a valid name (more than 1 character)',
                isError: state is EditProfileShowErrorState
                    ? !ValidationService.username(bloc.userNameController.text)
                    : false,
                placeHolder: 'Enter your name',
                title: 'Name',
              ),
              SizedBox(height: 15),
              PlantsTextField(
                controller: bloc.userEmailController,
                errorText: 'Enter a valid email',
                isError: state is EditProfileShowErrorState
                    ? !ValidationService.email(bloc.userEmailController.text)
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
            EditProfileChangeDataEvent(),
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
}
