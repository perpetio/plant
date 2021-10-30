import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant/common_widget/plants_button.dart';
import 'package:plant/common_widget/plants_text_field.dart';
import 'package:plant/screens/change_password/bloc/change_password_bloc.dart';
import 'package:plant/service/validation_service.dart';

class ChangePasswordContent extends StatefulWidget {
  @override
  _ChangePasswordContentState createState() => _ChangePasswordContentState();
}

class _ChangePasswordContentState extends State<ChangePasswordContent> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ChangePasswordBloc>(context);
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.white,
      child: BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
        buildWhen: (_, currState) => currState is ChangePasswordShowErrorState,
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  PlantsTextField(
                    title: 'Old password',
                    placeHolder: 'Enter an old password',
                    controller: oldPasswordController,
                    errorText: 'Password should contain at least 6 characters',
                    isError: state is ChangePasswordShowErrorState
                        ? !ValidationService.password(
                            oldPasswordController.text)
                        : false,
                  ),
                  const SizedBox(height: 20),
                  PlantsTextField(
                    title: 'New password',
                    placeHolder: 'Enter a new password',
                    controller: newPasswordController,
                    errorText: 'Password should contain at least 6 characters',
                    isError: state is ChangePasswordShowErrorState
                        ? !ValidationService.password(
                            newPasswordController.text)
                        : false,
                  ),
                  const SizedBox(height: 20),
                  PlantsTextField(
                    title: 'Confirm password',
                    placeHolder: 'Re-enter password',
                    controller: confirmPasswordController,
                    errorText: 'Password is not the same',
                    isError: state is ChangePasswordShowErrorState
                        ? !ValidationService.confirmPassword(
                            newPasswordController.text,
                            confirmPasswordController.text)
                        : false,
                  ),
                  const SizedBox(height: 20),
                  _createSaveButton(bloc),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _createSaveButton(ChangePasswordBloc bloc) {
    return PlantButton(
      title: 'Save',
      onTap: () {
        bloc.add(
          ChangePasswordSaveTappedEvent(
            oldPasswordController: oldPasswordController,
            newPasswordController: newPasswordController,
            confirmPasswordController: confirmPasswordController,
          ),
        );
      },
    );
  }
}
