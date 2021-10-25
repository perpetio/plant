import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant/screens/common_widget/plants_loading.dart';
import 'package:plant/screens/edit_profile/bloc/edit_profile_bloc.dart';
import 'package:plant/screens/edit_profile/widget/edit_profile_content.dart';

class EditProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Account',
          style: TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.of(context).pop()),
      ),
      body: _buildContext(context),
    );
  }

  BlocProvider<EditProfileBloc> _buildContext(BuildContext context) {
    return BlocProvider<EditProfileBloc>(
      create: (BuildContext context) => EditProfileBloc(),
      child: BlocConsumer<EditProfileBloc, EditProfileState>(
        buildWhen: (_, currState) =>
            currState is EditProfileInitial || currState is EditAccountProgress,
        builder: (context, state) {
          final bloc = BlocProvider.of<EditProfileBloc>(context);
          if (state is EditProfileInitial) {
            bloc.add(EditProfileInitialEvent());
          } else if (state is EditAccountProgress) {
            return Stack(
              children: [EditProfileContent(), PlantsLoading()],
            );
          }
          return EditProfileContent();
        },
        listenWhen: (_, currState) => true,
        listener: (context, state) {},
      ),
    );
  }
}
