import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:plant/screens/login/view/sign_in_screen.dart';
import 'package:plant/screens/profile/bloc/profile_bloc.dart';
import 'package:plant/utils/router.dart';
import 'package:plant/widgets/screen_template.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return ProfileBloc();
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return ScreenTemplate(
            index: 2,
            isAppBar: false,
            title: "Profile",
            body: _Body(),
          );
        },
      ),
    );
  }
}

class _Body extends StatefulWidget {
  _Body({Key key}) : super(key: key);

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  final _auth = FirebaseAuth.instance;

  CollectionReference collection =
      FirebaseFirestore.instance.collection('users');

  final picker = ImagePicker();
  File _image;

  void _pickImage() async {
    //this function to pick the image from galery
    HapticFeedback.selectionClick();
    PickedFile image = await picker.getImage(source: ImageSource.gallery);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });

    DocumentReference sightingRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid);

    await saveImages(_image, sightingRef);
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(top: 70.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Profile',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    letterSpacing: 1.0),
              ),
            ),
          ),
          SizedBox(height: 30.0),
          StreamBuilder<QuerySnapshot>(
            stream: collection.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              if (snapshot.hasData) {
                QueryDocumentSnapshot user;
                snapshot.data.docs.map((element) {
                  if (element['uid'] == FirebaseAuth.instance.currentUser.uid) {
                    user = element;
                  }
                }).toList();

                return Column(
                  children: [
                    Center(
                      child: Stack(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 80,
                            backgroundImage: user['image'] == ''
                                ? AssetImage('assets/images/profile.png')
                                : NetworkImage(user['image']),
                          ),
                          Positioned(
                            bottom: 0.0,
                            right: 17.0,
                            child: InkWell(
                              onTap: () => _pickImage(),
                              child: Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  heightFactor: 10,
                                  widthFactor: 10,
                                  child: Icon(Icons.edit_outlined, size: 20),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      user['name'],
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      user['email'],
                      style: TextStyle(fontSize: 15.0, color: Colors.grey),
                    ),
                  ],
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          SizedBox(height: 20.0),
          InkWell(
            onTap: () {
              _auth.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                PageTransition(
                    type: PageTransitionType.fade, child: SignInScreen()),
                ModalRoute.withName(Routers.sign_in),
              );
            },
            child: Container(
              height: size.height * 0.06,
              width: size.width * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: Color(0xFFF3F7FB),
              ),
              child: Row(
                children: [
                  SizedBox(width: 20.0),
                  Icon(Icons.logout),
                  SizedBox(width: 10.0),
                  Text('Logout'),
                  Spacer(),
                  Icon(Icons.arrow_forward_ios_rounded),
                  SizedBox(
                    width: 20.0,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
