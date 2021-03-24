import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant/api/plant_api.dart';
import 'package:plant/screens/camera_screen.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
    return Scaffold(
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Container(
      color: Colors.black.withOpacity(0.9),
      padding: EdgeInsets.symmetric(horizontal: 35, vertical: 90),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Color(0xFF2A363B),
          borderRadius: BorderRadius.circular(30),
        ),
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
                                  color: Colors.white, fontSize: 22.0),
                            );
                          }).toList();
                          List score = snapshot.data.map<Widget>((result) {
                            return Text(
                              result.score.toStringAsFixed(2),
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0),
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
