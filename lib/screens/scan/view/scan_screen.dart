import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:plant/screens/home/view/home_screen.dart';
import 'package:plant/utils/router.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class ScanScreen extends StatefulWidget {
  final CameraDescription camera;

  const ScanScreen({Key key, @required this.camera}) : super(key: key);

  @override
  ScanScreenState createState() => ScanScreenState();
}

class ScanScreenState extends State<ScanScreen> with TickerProviderStateMixin {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  final RoundedLoadingButtonController _buttonController =
      new RoundedLoadingButtonController();
  bool _toggleFlash = false;
  bool _loading = true;
  File _image;
  final picker = ImagePicker();
  AnimationController controller;
  Animation<Offset> offset;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize();

    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    offset = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 1.0))
        .animate(controller);
    controller.forward(from: 1.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _pickImage() async {
    //this function to grab the image from camera
    PickedFile image = await picker.getImage(source: ImageSource.gallery);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
      _loading = false;
    });
  }

  void _doSomething() async {
    Timer(Duration(seconds: 3), () {
      _buttonController.stop();
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
                Center(
                  child: Image.asset(
                    'assets/images/scanner.png',
                    height: 300,
                  ),
                ),
                buildBackButton(),
                buildCameraButton(),
                buildGaleryButton(),
                buildFlashButton(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SlideTransition(
                    position: offset,
                    child: Padding(
                      padding: EdgeInsets.all(50.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          color: Color.fromRGBO(255, 255, 255, 0.96),
                        ),
                        height: size.height * 0.1,
                        width: size.width,
                      ),
                    ),
                  ),
                )
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget buildBackButton() {
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

  Widget buildCameraButton() {
    return Positioned(
      bottom: 60,
      left: 170,
      child: RoundedLoadingButton(
        width: 70,
        height: 70,
        color: Colors.orange,
        successColor: Colors.green,
        borderRadius: 50,
        child: Icon(
          Icons.camera,
          color: Colors.white,
          size: 44,
        ),
        controller: _buttonController,
        onPressed: () async {
          // HapticFeedback.mediumImpact();
          // await _initializeControllerFuture;

          // final image = await _controller.takePicture();

          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => DisplayPictureScreen(
          //       imagePath: image?.path,
          //     ),
          //   ),
          // );
          switch (controller.status) {
            case AnimationStatus.completed:
              controller.reverse();
              break;
            case AnimationStatus.dismissed:
              controller.forward();
              break;
            default:
          }
          _buttonController.stop();
        },
      ),
    );
  }

  Widget buildGaleryButton() {
    return Positioned(
      bottom: 50,
      right: 40,
      child: IconButton(
          onPressed: () {
            HapticFeedback.selectionClick();
            _pickImage();
          },
          icon: Icon(
            Icons.add_photo_alternate_outlined,
            size: 40,
            color: Colors.white,
          )),
    );
  }

  Widget buildFlashButton() {
    return Positioned(
        bottom: 50,
        left: 30,
        child: IconButton(
          icon: _toggleFlash
              ? Icon(
                  Icons.flash_on,
                  color: Colors.white,
                  size: 30,
                )
              : Icon(
                  Icons.flash_off,
                  color: Colors.white,
                  size: 35,
                ),
          onPressed: () async {
            HapticFeedback.selectionClick();
            _toggleFlash
                ? await _controller.setFlashMode(FlashMode.off)
                : await _controller.setFlashMode(FlashMode.torch);
            setState(() {
              _toggleFlash == true ? _toggleFlash = false : _toggleFlash = true;
            });
          },
        ));
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(height: 2000, child: Image.file(File(imagePath))),
    );
  }
}

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
