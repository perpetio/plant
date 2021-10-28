import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'changepassword_event.dart';
part 'changepassword_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  ChangePasswordBloc() : super(ChangePasswordInitial());

  @override
  Stream<ChangePasswordState> mapEventToState(ChangePasswordEvent event) {
    throw UnimplementedError();
  }
}
