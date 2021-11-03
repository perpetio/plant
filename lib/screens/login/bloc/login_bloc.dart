import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:plant/service/auth_service.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is SignInTappedEvent) {
      yield SignInTappedState();
    } else if (event is SignInDoNotHaveAccountEvent) {
      yield SignInDoNotHaveAccountState();
    }
  }
}
