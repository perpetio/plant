import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant/common_widget/plants_loading.dart';
import 'package:plant/screens/change_password/bloc/change_password_bloc.dart';
import 'package:plant/screens/change_password/content/change_password_content.dart';

class ChangePasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Change password',
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

  BlocProvider<ChangePasswordBloc> _buildBody(BuildContext context) {
    return BlocProvider<ChangePasswordBloc>(
      create: (BuildContext context) => ChangePasswordBloc(),
      child: BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
        buildWhen: (_, currState) =>
            currState is ChangePasswordInitial ||
            currState is ChangePasswordProgress ||
            currState is ChangePasswordSuccessState ||
            currState is ChangePasswordErrorState,
        builder: (context, state) {
          if (state is ChangePasswordInitial) {
          } else if (state is ChangePasswordProgress) {
            return Stack(
              children: [ChangePasswordContent(), PlantsLoading()],
            );
          } else if (state is ChangePasswordSuccessState) {
            Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(state.message), duration: Duration(seconds: 3)));
          } else if (state is ChangePasswordErrorState) {
            Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(state.error), duration: Duration(seconds: 3)));
          }
          return ChangePasswordContent();
        },
        listenWhen: (_, currState) => true,
        listener: (context, state) {},
      ),
    );
  }
}
