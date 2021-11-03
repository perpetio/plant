import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:plant/common_widget/plants_loading.dart';
import 'package:plant/models/plant_model.dart';
import 'package:plant/screens/home/view/home_screen.dart';
import 'package:plant/screens/scan/bloc/scan_bloc.dart';
import 'package:plant/utils/router.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class ScanContent extends StatefulWidget {
  final CameraDescription camera;

  ScanContent({
    @required this.camera,
  });

  @override
  _ScanContentState createState() => _ScanContentState();
}

class _ScanContentState extends State<ScanContent>
    with TickerProviderStateMixin {
  PlantModel plant;
  @override
  void initState() {
    super.initState();
    // ignore: close_sinks
    final bloc = BlocProvider.of<ScanBloc>(context);

    bloc.controller = CameraController(widget.camera, ResolutionPreset.high);
    bloc.initializeControllerFuture = bloc.controller.initialize();

    bloc.animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    bloc.offset = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 1.0))
        .animate(bloc.animationController);
    bloc.animationController.forward(from: 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bloc = BlocProvider.of<ScanBloc>(context);

    return Container(
      width: double.infinity,
      height: double.infinity,
      child: FutureBuilder(
        future: bloc.initializeControllerFuture,
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? _createCameraBuilder(bloc, size)
              : PlantsLoading();
        },
      ),
    );
  }

  Widget _createCameraBuilder(ScanBloc bloc, Size size) {
    return Stack(
      children: [
        Transform.scale(
          scale: 1 / (size.aspectRatio * bloc.controller.value.aspectRatio),
          child: Center(
            child: CameraPreview(bloc.controller),
          ),
        ),
        Center(
          child: Image.asset(
            'assets/images/scanner.png',
            height: 300,
          ),
        ),
        _buildBackButton(),
        _buildCameraButton(bloc),
        _buildGaleryButton(bloc),
        _buildFlashButton(bloc),
        _buildAnimatedContainer(bloc),
      ],
    );
  }

  Widget _buildBackButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 60.0, left: 20.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushAndRemoveUntil(
            PageTransition(
              type: PageTransitionType.fade,
              child: HomeScreen(),
            ),
            ModalRoute.withName(Routers.home),
          );
        },
        child: Row(
          children: [
            Icon(
              Icons.arrow_back_ios_rounded,
              size: 30.0,
              color: Colors.white,
            ),
            SizedBox(width: 8.0),
            Text(
              'Scan the plant',
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCameraButton(ScanBloc bloc) {
    final size = MediaQuery.of(context).size;
    return Positioned(
      bottom: 60,
      left: size.width * 0.43,
      child: RoundedLoadingButton(
        width: 70,
        height: 70,
        color: Colors.orange,
        successColor: Colors.green,
        borderRadius: 50,
        loaderSize: 35.0,
        child: Icon(Icons.camera, color: Colors.white, size: 44),
        controller: bloc.takePhotoController,
        onPressed: () => bloc.add(TakeImageEvent()),
      ),
    );
  }

  Widget _buildGaleryButton(ScanBloc bloc) {
    return Positioned(
      bottom: 50,
      right: 40,
      child: IconButton(
        onPressed: () {
          bloc.add(PickImageEvent());
        },
        icon: Icon(
          Icons.add_photo_alternate_outlined,
          size: 40,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildFlashButton(ScanBloc bloc) {
    return Positioned(
      bottom: 50,
      left: 30,
      child: IconButton(
        icon: bloc.toggleFlash
            ? Icon(Icons.flash_on, color: Colors.white, size: 30)
            : Icon(Icons.flash_off, color: Colors.white, size: 35),
        onPressed: () async {
          HapticFeedback.selectionClick();
          bloc.toggleFlash
              ? await bloc.controller.setFlashMode(FlashMode.off)
              : await bloc.controller.setFlashMode(FlashMode.torch);
          setState(
            () {
              bloc.toggleFlash == true
                  ? bloc.toggleFlash = false
                  : bloc.toggleFlash = true;
            },
          );
        },
      ),
    );
  }

  Widget _buildAnimatedContainer(ScanBloc bloc) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<ScanBloc, ScanState>(
      buildWhen: (currState, _) =>
          currState is DataPlantGotState || currState is ScanErrorState,
      builder: (context, state) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: SlideTransition(
            position: bloc.offset,
            child: Padding(
              padding: EdgeInsets.only(bottom: 65.0, left: 10, right: 10),
              child: GestureDetector(
                onPanUpdate: (details) {
                  if (details.delta.dy > 0) {
                    bloc.animationController.forward();
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(23),
                    ),
                    color: Color.fromRGBO(255, 255, 255, 0.96),
                  ),
                  height: size.height * 0.13,
                  width: size.width,
                  child: Row(
                    children: [
                      bloc.image != null
                          ? _createPlantImage(bloc.image)
                          : Container(
                              height: 100,
                              width: 100,
                            ),
                      SizedBox(width: 10),
                      Expanded(
                        flex: 6,
                        child: _createPlantsDetails(
                          bloc,
                          context,
                          isError: state is ScanErrorState,
                        ),
                      ),
                      Spacer(),
                      _createAddPlantButton(bloc),
                      SizedBox(width: 15)
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _createPlantImage(File image) {
    return Expanded(
      flex: 3,
      child: Container(
        width: 100,
        height: 100,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.file(image, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _createPlantsDetails(
    ScanBloc bloc,
    BuildContext context, {
    bool isError = false,
  }) {
    if (bloc.plantModel != null) {
      return Text(
        bloc.plantExistInList == false
            ? '${bloc.plantsModels.getPlantName() ?? ""}'
            : "Plant is already added",
        style: TextStyle(
          color: Colors.black,
          fontSize: 17.0,
          fontWeight: FontWeight.bold,
        ),
      );
    } else if (isError) {
      return Text(
        "Plant is not found",
        style: TextStyle(
          color: Colors.black,
          fontSize: 17.0,
          fontWeight: FontWeight.bold,
        ),
      );
    }
    return CupertinoActivityIndicator();
  }

  Widget _createAddPlantButton(ScanBloc bloc) {
    return RoundedLoadingButton(
      width: 60,
      height: 60,
      color: Colors.orange,
      successColor: Colors.green,
      borderRadius: 50,
      loaderSize: 35.0,
      child: Icon(Icons.add, color: Colors.white, size: 44),
      controller: bloc.addPlantController,
      onPressed: () async {
        bloc.add(AddPlantEvent());
      },
    );
  }
}
