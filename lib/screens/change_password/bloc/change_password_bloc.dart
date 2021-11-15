import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:plant/core/service/user_service.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  ChangePasswordBloc() : super(ChangePasswordInitial());

  @override
  Stream<ChangePasswordState> mapEventToState(
    ChangePasswordEvent event,
  ) async* {
    if (event is ChangePasswordSaveTappedEvent) {
      try {
        // yield ChangePasswordProgress();
        await UserService.changeUserPassword(
            newPassword: event.newPasswordController.text,
            oldPassword: event.oldPasswordController.text);
        yield ChangePasswordSuccessState(
            message: 'Password successfully updated!');
      } catch (e) {
        ChangePasswordErrorState(e.toString());
      }
    }
  }
}
