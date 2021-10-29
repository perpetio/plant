import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:plant/service/user_service.dart';
import 'package:plant/service/validation_service.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  ChangePasswordBloc() : super(ChangePasswordInitial());

  final FirebaseAuth firebase = FirebaseAuth.instance;

  @override
  Stream<ChangePasswordState> mapEventToState(
    ChangePasswordEvent event,
  ) async* {
    if (event is ChangePasswordSaveTappedEvent) {
      if (_checkValidatorsOfTextField(
          event.passwordController, event.confirmPasswordController)) {
        try {
          yield ChangePasswordProgress();
          await UserService.changeUserPassword(
              newPassword: event.passwordController.text);
          yield ChangePasswordSuccessState(
              message: 'Password successfully updated!');
        } catch (e) {
          ChangePasswordErrorState(e.toString());
        }
      }
    }
  }

  bool _checkValidatorsOfTextField(TextEditingController passwordController,
      TextEditingController confirmPasswordController) {
    return ValidationService.password(passwordController.text) &&
        ValidationService.confirmPassword(
            passwordController.text, confirmPasswordController.text);
  }
}
