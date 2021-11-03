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
  final _formKey = GlobalKey<FormState>();

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
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    const SizedBox(height: 25),
                    PlantsTextField(
                      labelText: 'Old password',
                      placeHolder: 'Enter an old password',
                      controller: oldPasswordController,
                      validator: (password) {
                        if (ValidationService.password(password))
                          return null;
                        else
                          return 'Password should contain at least 6 characters';
                      },
                    ),
                    const SizedBox(height: 20),
                    PlantsTextField(
                      labelText: 'New password',
                      placeHolder: 'Enter a new password',
                      controller: newPasswordController,
                      validator: (newPassword) {
                        if (ValidationService.password(newPassword))
                          return null;
                        else
                          return 'Password should contain at least 6 characters';
                      },
                    ),
                    const SizedBox(height: 20),
                    PlantsTextField(
                      labelText: 'Confirm password',
                      placeHolder: 'Re-enter password',
                      controller: confirmPasswordController,
                      validator: (confirmPassword) {
                        if (ValidationService.confirmPassword(
                            newPasswordController.text, confirmPassword))
                          return null;
                        else
                          return 'Password is not the same';
                      },
                    ),
                    const SizedBox(height: 20),
                    _createSaveButton(bloc),
                  ],
                ),
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
        if (_formKey.currentState.validate())
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
