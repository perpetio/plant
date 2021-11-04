import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:plant/service/auth_service.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(ForgotPasswordInitial());

  @override
  Stream<ForgotPasswordState> mapEventToState(
    ForgotPasswordEvent event,
  ) async* {
    if (event is ForgotPassSaveTappedEvent) {
      try {
        await AuthService.auth.sendPasswordResetEmail(email: event.email);
        yield ForgotPassSuccessState(
            message: 'A password reset link has been sent to ${event.email}');
      } catch (e) {
        yield ForgotPassErrorState(error: e.toString());
      }
    }
  }
}
