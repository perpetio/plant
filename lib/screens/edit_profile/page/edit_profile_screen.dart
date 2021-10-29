import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant/common_widget/plants_loading.dart';
import 'package:plant/models/user_data.dart';
import 'package:plant/screens/edit_profile/bloc/edit_profile_bloc.dart';
import 'package:plant/screens/edit_profile/widget/edit_profile_content.dart';

class EditProfileScreen extends StatelessWidget {
  final UserData user;

  EditProfileScreen({
    @required this.user,
  });
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
      body: _buildBody(context),
    );
  }

  BlocProvider<EditProfileBloc> _buildBody(BuildContext context) {
    return BlocProvider<EditProfileBloc>(
      create: (BuildContext context) => EditProfileBloc(),
      child: BlocConsumer<EditProfileBloc, EditProfileState>(
        buildWhen: (_, currState) =>
            currState is EditProfileInitial ||
            currState is EditProfileProgress ||
            currState is EditProfileErrorState ||
            currState is EditProfileSuccessState,
        builder: (context, state) {
          // ignore: close_sinks
          final bloc = BlocProvider.of<EditProfileBloc>(context);
          if (state is EditProfileInitial) {
            bloc.add(EditProfileInitialEvent());
          } else if (state is EditProfileProgress) {
            return Stack(
              children: [EditProfileContent(user: user), PlantsLoading()],
            );
          } else if (state is EditProfileErrorState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(state.message),
                  duration: Duration(seconds: 3)));
            });
          } else if (state is EditProfileSuccessState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(state.message),
                  duration: Duration(seconds: 3)));
            });
          }
          return EditProfileContent(user: user);
        },
        listenWhen: (_, currState) => true,
        listener: (context, state) {},
      ),
    );
  }
}
