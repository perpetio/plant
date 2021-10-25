import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:plant/screens/login/view/sign_in_screen.dart';
import 'package:plant/screens/profile/bloc/profile_bloc.dart';
import 'package:plant/utils/router.dart';
import 'package:plant/widgets/bottom_navigation_bar.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(
        index: 2,
      ),
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            "Profile",
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        actions: [
          InkWell(
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.edit_outlined,
                  size: 20,
                  color: Colors.black,
                ),
              ),
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                Routers.edit_profile,
              );
            },
          ),
        ],
      ),
      body: _buildContext(context),
    );
  }

  BlocProvider<ProfileBloc> _buildContext(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (BuildContext context) => ProfileBloc(),
      child: BlocConsumer<ProfileBloc, ProfileState>(
        buildWhen: (_, currState) => currState is ProfileInitial,
        builder: (context, state) {
          // ignore: close_sinks
          final bloc = BlocProvider.of<ProfileBloc>(context);
          if (state is ProfileInitial) {
            bloc.add(ProfileInitialEvent());
            // bloc.add(ProfileReloadImageEvent());
            // bloc.add(ProfileReloadUserDataEvent());
          }
          return _Body();
        },
        listenWhen: (_, currState) => true,
        listener: (context, state) {},
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
  // CollectionReference collection =
  //     FirebaseFirestore.instance.collection('users');

  // final picker = ImagePicker();
  // File _image;

  // void _pickImage() async {
  //   //this function to pick the image from galery

  //   HapticFeedback.selectionClick();
  //   PickedFile image = await picker.getImage(source: ImageSource.gallery);
  //   if (image == null) return null;

  //   setState(() {
  //     _image = File(image.path);
  //   });

  //   DocumentReference sightingRef = FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(FirebaseAuth.instance.currentUser.uid);

  //   await saveImages(_image, sightingRef);
  // }

  // Future<void> saveImages(File _image, DocumentReference ref) async {
  //   String imageURL = await uploadFile(_image);
  //   ref.update(
  //     {"image": imageURL},
  //   );
  // }

  // Future<String> uploadFile(File _image) async {
  //   StorageReference storageReference =
  //       FirebaseStorage.instance.ref().child(_image.path.split('/').last);
  //   StorageUploadTask uploadTask = storageReference.putFile(_image);
  //   await uploadTask.onComplete;
  //   print('File Uploaded');
  //   String returnURL;
  //   await storageReference.getDownloadURL().then((fileURL) {
  //     returnURL = fileURL;
  //   });
  //   return returnURL;
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(top: 70.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                final bloc = BlocProvider.of<ProfileBloc>(context);
                return Column(
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 80,
                        backgroundImage: bloc.userData == null ||
                                bloc.userData['image'] == ''
                            ? AssetImage('assets/images/profile.png')
                            : NetworkImage(bloc.userData['image']),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      bloc.userData != null ? bloc.userData['name'] : '',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      bloc.userData != null ? bloc.userData['email'] : '',
                      style: TextStyle(fontSize: 15.0, color: Colors.grey),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 20.0),
            InkWell(
              onTap: () {
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
      ),
    );
  }
}
