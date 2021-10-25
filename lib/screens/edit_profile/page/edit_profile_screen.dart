import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant/screens/edit_profile/bloc/edit_profile_bloc.dart';
import 'package:plant/screens/edit_profile/widget/edit_profile_content.dart';

class EditProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContext(context),
    );
  }

  BlocProvider<EditProfileBloc> _buildContext(BuildContext context) {
    return BlocProvider<EditProfileBloc>(
      create: (BuildContext context) => EditProfileBloc(),
      child: BlocConsumer<EditProfileBloc, EditProfileState>(
        buildWhen: (_, currState) => currState is EditProfileInitial,
        builder: (context, state) {
          return EditProfileContent();
        },
        listenWhen: (_, currState) => true,
        listener: (context, state) {},
      ),
    );
  }
}
