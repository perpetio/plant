import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant/api/plant_api.dart';
import 'package:plant/screens/camera_screen.dart';
import 'package:plant/screens/scan/bloc/scan_bloc.dart';
import 'package:plant/widgets/screen_template.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return ScanBloc();
      },
      child: BlocBuilder<ScanBloc, ScanState>(
        builder: (context, state) {
          return ScreenTemplate(
            index: 1,
            body: _Body(),
          );
        },
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  bool _loading = true;
  File _image;
  final picker = ImagePicker();

  pickImage(ImageSource source) async {
    //this function to grab the image from camera
    PickedFile image = await picker.getImage(source: source);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
      _loading = false;
    });

    await fetchPlants(_image);
  }

  openCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CameraScreen(camera: firstCamera)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 35, vertical: 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20.0),
          buildImage(),
          Spacer(),
          Container(
            child: Column(
              children: [
                buildTakePhoto(),
                SizedBox(height: 30),
                buildPickFromGallery()
              ],
            ),
          ),
          SizedBox(height: 40.0)
        ],
      ),
    );
  }

  Widget buildImage() {
    return Container(
      child: Center(
        child: _loading == true
            ? null //show nothing if no picture selected
            : Container(
                child: Column(
                  children: [
                    SizedBox(height: 20.0),
                    Container(
                      height: 250,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.file(
                          _image,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizedBox(height: 40.0),
                    Divider(height: 25, thickness: 1),
                    FutureBuilder(
                      future: fetchPlants(_image),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List results = snapshot.data.map<Widget>((result) {
                            return Text(
                              result.species.scientificNameWithoutAuthor,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 22.0),
                            );
                          }).toList();
                          List score = snapshot.data.map<Widget>((result) {
                            return Text(
                              result.score.toStringAsFixed(2),
                              style: TextStyle(
                                  color: Colors.black, fontSize: 18.0),
                            );
                          }).toList();

                          return Column(
                            children: [results[0], score[0]],
                          );
                        }
                        // By default, show a loading spinner
                        return Text('');
                      },
                    ),
                    Divider(height: 25, thickness: 1),
                  ],
                ),
              ),
      ),
    );
  }

  Widget buildTakePhoto() {
    return GestureDetector(
      onTap: () => openCamera(),
      child: Container(
        width: MediaQuery.of(context).size.width - 200,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 17),
        decoration: BoxDecoration(
            color: Colors.blueGrey[600],
            borderRadius: BorderRadius.circular(15)),
        child: Text(
          'Take A Photo',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget buildPickFromGallery() {
    return GestureDetector(
      onTap: () => pickImage(ImageSource.gallery),
      child: Container(
        width: MediaQuery.of(context).size.width - 200,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 17),
        decoration: BoxDecoration(
            color: Colors.blueGrey[600],
            borderRadius: BorderRadius.circular(15)),
        child: Text(
          'Pick From Gallery',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
