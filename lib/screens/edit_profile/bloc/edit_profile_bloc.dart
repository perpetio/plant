import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc() : super(EditProfileInitial());

  @override
  Stream<EditProfileState> mapEventToState(
    EditProfileEvent event,
  ) async* {}
}
