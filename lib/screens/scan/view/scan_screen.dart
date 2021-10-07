import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:plant/api/plant_net_api.dart';
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
  final RoundedLoadingButtonController _takePhotoController =
      new RoundedLoadingButtonController();
  final RoundedLoadingButtonController _addPlantController =
      new RoundedLoadingButtonController();
  bool _toggleFlash = false;
  File _image;
  bool _isFromGallery = false;
  final picker = ImagePicker();
  AnimationController controller;
  Animation<Offset> offset;

  String plant;
  double score;
  String familyName;

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

  Future<void> saveImages(File _image, DocumentReference ref) async {
    String imageURL = await uploadFile(_image);
    ref.update(
      {"image": imageURL},
    );
  }

  Future<String> uploadFile(File _image) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(_image.path.split('/').last);
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    String returnURL;
    await storageReference.getDownloadURL().then((fileURL) {
      returnURL = fileURL;
    });
    return returnURL;
  }

  void _pickImage() async {
    //this function to pick the image from galery
    HapticFeedback.selectionClick();
    PickedFile image = await picker.getImage(source: ImageSource.gallery);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
      _isFromGallery = true;
    });
    _takePhotoController.start();
    await fetchPlants(_image);
    _takePhotoController.stop();

    switch (controller.status) {
      case AnimationStatus.completed:
        controller.reverse();
        break;
      case AnimationStatus.dismissed:
        controller.forward();
        break;
      default:
    }
    setState(() {
      _isFromGallery = false;
    });
  }

  void _takeImage() async {
    //this function to take the image from camera

    HapticFeedback.mediumImpact();
    _addPlantController.reset();
    if (!_isFromGallery) {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();

      setState(() {
        _image = File(image.path);
      });
      await fetchPlants(_image);

      switch (controller.status) {
        case AnimationStatus.completed:
          controller.reverse();
          break;
        case AnimationStatus.dismissed:
          controller.forward();
          break;
        default:
      }
      _takePhotoController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? Stack(
                  children: [
                    Transform.scale(
                      scale: 1 /
                          (size.aspectRatio * _controller.value.aspectRatio),
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
                    _buildBackButton(),
                    _buildCameraButton(),
                    _buildGaleryButton(),
                    _buildFlashButton(),
                    _buildAnimatedContainer()
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
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

  Widget _buildCameraButton() {
    return Positioned(
      bottom: 60,
      left: 170,
      child: RoundedLoadingButton(
        width: 70,
        height: 70,
        color: Colors.orange,
        successColor: Colors.green,
        borderRadius: 50,
        loaderSize: 35.0,
        child: Icon(Icons.camera, color: Colors.white, size: 44),
        controller: _takePhotoController,
        onPressed: () => _takeImage(),
      ),
    );
  }

  Widget _buildGaleryButton() {
    return Positioned(
      bottom: 50,
      right: 40,
      child: IconButton(
        onPressed: () => _pickImage(),
        icon: Icon(
          Icons.add_photo_alternate_outlined,
          size: 40,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildFlashButton() {
    return Positioned(
      bottom: 50,
      left: 30,
      child: IconButton(
        icon: _toggleFlash
            ? Icon(Icons.flash_on, color: Colors.white, size: 30)
            : Icon(Icons.flash_off, color: Colors.white, size: 35),
        onPressed: () async {
          HapticFeedback.selectionClick();
          _toggleFlash
              ? await _controller.setFlashMode(FlashMode.off)
              : await _controller.setFlashMode(FlashMode.torch);
          setState(
            () {
              _toggleFlash == true ? _toggleFlash = false : _toggleFlash = true;
            },
          );
        },
      ),
    );
  }

  Widget _buildAnimatedContainer() {
    final size = MediaQuery.of(context).size;

    return Align(
      alignment: Alignment.bottomCenter,
      child: SlideTransition(
        position: offset,
        child: Padding(
          padding: EdgeInsets.only(bottom: 65.0, left: 10, right: 10),
          child: GestureDetector(
            onPanUpdate: (details) {
              if (details.delta.dy > 0) {
                controller.forward();
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
                  _image != null ? _createPlantImage() : Container(),
                  SizedBox(width: 5),
                  _createPlantsDetails(),
                  Spacer(),
                  _createAddPlantButton(),
                  SizedBox(width: 15.0)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _createPlantImage() {
    return Expanded(
      flex: 3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.file(_image, fit: BoxFit.cover),
      ),
    );
  }

  Widget _createPlantsDetails() {
    return Expanded(
      flex: 6,
      child: FutureBuilder(
        future: fetchPlants(_image),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List plants = [];
            List scores = [];
            List familyNames = [];
            snapshot.data.map<Widget>((result) {
              plants.add(result.species.scientificNameWithoutAuthor);
              scores.add(result.score);
              familyNames
                  .add(result.species.family.scientificNameWithoutAuthor);
            }).toList();

            plant = plants[0].toString();
            score = scores[0];
            familyName = familyNames[0];

            return Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      plant,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    score.toStringAsFixed(2),
                    style: TextStyle(color: Colors.black, fontSize: 16.0),
                  ),
                ],
              ),
            );
          }
          return Text('');
        },
      ),
    );
  }

  Widget _createAddPlantButton() {
    return RoundedLoadingButton(
      width: 60,
      height: 60,
      color: Colors.orange,
      successColor: Colors.green,
      borderRadius: 50,
      loaderSize: 35.0,
      child: Icon(Icons.add, color: Colors.white, size: 44),
      controller: _addPlantController,
      onPressed: () async {
        HapticFeedback.selectionClick();
        DocumentReference sightingRef = FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser.uid)
            .collection('plants')
            .doc();

        final imageUrl = await uploadFile(_image);

        sightingRef.set(
          {
            "score": score,
            "image": imageUrl,
            "createdAt": DateTime.now().microsecondsSinceEpoch,
            "species": {
              "scientificNameWithoutAuthor": plant,
              "family": {
                "scientificNameWithoutAuthor": familyName,
              }
            }
          },
        );
        _addPlantController.success();
      },
    );
  }
}
