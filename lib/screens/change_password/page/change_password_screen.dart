import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant/common_widget/plants_loading.dart';
import 'package:plant/screens/change_password/bloc/change_password_bloc.dart';
import 'package:plant/screens/change_password/content/change_password_content.dart';
import 'package:plant/service/modal_service.dart';

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
            currState is ChangePasswordProgress,
        builder: (context, state) {
          if (state is ChangePasswordInitial) {
          } else if (state is ChangePasswordProgress) {
            return Stack(
              children: [ChangePasswordContent(), PlantsLoading()],
            );
          }
          return ChangePasswordContent();
        },
        listenWhen: (_, currState) =>
            currState is ChangePasswordSuccessState ||
            currState is ChangePasswordErrorState,
        listener: (context, state) {
          if (state is ChangePasswordSuccessState) {
            ModalService.showAlertDialog(context, description: state.message);
          } else if (state is ChangePasswordErrorState) {
            ModalService.showAlertDialog(context, description: state.error);
          }
        },
      ),
    );
  }
}
