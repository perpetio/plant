import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:plant/screens/home/view/home_screen.dart';
import 'package:plant/utils/router.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraScreen({Key key, @required this.camera}) : super(key: key);

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  final RoundedLoadingButtonController _buttonController =
      new RoundedLoadingButtonController();

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _doSomething() async {
    Timer(Duration(seconds: 3), () {
      _buttonController.success();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                Transform.scale(
                  scale: 1 / (size.aspectRatio * _controller.value.aspectRatio),
                  child: Center(
                    child: CameraPreview(_controller),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 60.0, left: 20.0),
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.selectionClick();
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
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'Scan the plant',
                          style: TextStyle(fontSize: 20.0),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 40,
                  left: 60,
                  child: RoundedLoadingButton(
                    height: 100,
                    child: Icon(
                      Icons.camera,
                      color: Colors.white,
                    ),
                    controller: _buttonController,
                    onPressed: _doSomething,
                  ),
                )
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      body: Image.file(File(imagePath)),
    );
  }
}

// InkWell(
//           onTap: () {},
//           child: Row(
//             children: [
//               Icon(Icons.arrow_back_ios_rounded),
//               Text('Scan the plant')
//             ],
//           ),
//         ),

// floatingActionButton: FloatingActionButton(
//   child: Icon(Icons.camera_alt),
//   // Provide an onPressed callback.
//   onPressed: () async {
//     try {
//       await _initializeControllerFuture;

//       final image = await _controller.takePicture();

//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => DisplayPictureScreen(
//             imagePath: image?.path,
//           ),
//         ),
//       );
//     } catch (e) {
//       print(e);
//     }
//   },
// ),
