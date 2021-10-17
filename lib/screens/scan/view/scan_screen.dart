import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant/screens/scan/bloc/scan_bloc.dart';
import 'package:plant/screens/scan/widget/scan_content.dart';

class ScanScreen extends StatelessWidget {
  final CameraDescription camera;

  ScanScreen({
    @required this.camera,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContext(context),
    );
  }

  BlocProvider<ScanBloc> _buildContext(BuildContext context) {
    return BlocProvider<ScanBloc>(
      create: (BuildContext context) => ScanBloc(),
      child: BlocConsumer<ScanBloc, ScanState>(
        buildWhen: (_, currState) =>
            currState is ScanInitial || currState is DataPlantGotState,
        builder: (context, state) {
          return ScanContent(camera: camera);
        },
        listenWhen: (_, currState) => true,
        listener: (context, state) {},
      ),
    );
  }
}
