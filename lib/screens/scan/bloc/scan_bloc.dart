import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'scan_event.dart';
part 'scan_state.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  ScanBloc() : super(ScanInitial());

  @override
  Stream<ScanState> mapEventToState(
    ScanEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
