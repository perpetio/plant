import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant/injection_container.dart';
import 'package:plant/screens/scan/bloc/scan_bloc.dart';
import 'package:plant/screens/scan/widget/scan_content.dart';

class ScanScreen extends StatelessWidget {
  final CameraDescription camera;
  final ScanBloc bloc = serviceLocator.get<ScanBloc>();

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
      create: (_) => bloc,
      child: BlocConsumer<ScanBloc, ScanState>(
        buildWhen: (_, currState) =>
            currState is ScanInitial || currState is DataPlantGotState,
        builder: (context, state) {
          // ignore: close_sinks
          // final bloc = BlocProvider.of<ScanBloc>(context);
          if (state is ScanInitial) {
            bloc.add(ScanInitialEvent());
          } else if (state is DataPlantGotState) {
            print('plants');
          }
          return ScanContent(camera: camera);
        },
        listenWhen: (_, currState) => true,
        listener: (context, state) {},
      ),
    );
  }
}
