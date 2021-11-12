import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:plant/const/color_const.dart';
import 'package:plant/screens/home/page/home_screen.dart';
import 'package:plant/screens/profile/page/profile_screen.dart';
import 'package:plant/screens/scan/page/scan_screen.dart';
import 'package:plant/core/utils/router.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int index;

  CustomBottomNavigationBar({Key key, this.index}) : super(key: key);

  _handleBottomNavigation(BuildContext context, int index) async {
    if (index == 0) {
      HapticFeedback.selectionClick();
      Navigator.of(context).pushAndRemoveUntil(
        PageTransition(type: PageTransitionType.fade, child: HomeScreen()),
        ModalRoute.withName(Routers.home),
      );
    }
    if (index == 1) {
      List<CameraDescription> cameras = await availableCameras();
      CameraDescription camera = cameras.first;

      HapticFeedback.selectionClick();
      Navigator.of(context).pushAndRemoveUntil(
        PageTransition(
            type: PageTransitionType.fade,
            child: ScanScreen(
              camera: camera,
            )),
        ModalRoute.withName(Routers.scan),
      );
    }
    if (index == 2) {
      HapticFeedback.selectionClick();
      Navigator.of(context).pushAndRemoveUntil(
        PageTransition(type: PageTransitionType.fade, child: ProfileScreen()),
        ModalRoute.withName(Routers.profile),
      );
    }
  }

  final List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(
      icon:
          Image.asset('assets/icons/home.png', height: 25, color: Colors.grey),
      activeIcon: Image.asset(
        'assets/icons/home.png',
        height: 25,
        color: ColorConstants.green,
      ),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Image.asset('assets/icons/scan.png', height: 56, width: 56),
      activeIcon: Image.asset('assets/icons/scan.png',
          height: 56, width: 56, color: ColorConstants.green),
      label: 'Scan',
    ),
    BottomNavigationBarItem(
      icon: Image.asset('assets/icons/profile.png', height: 25.0),
      activeIcon: Image.asset('assets/icons/profile.png',
          height: 25, color: ColorConstants.green),
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return Container(
      height: height * 0.123,
      color: Colors.transparent,
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 0.0,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        selectedLabelStyle: TextStyle(letterSpacing: 1, fontSize: 10),
        unselectedLabelStyle: TextStyle(letterSpacing: 1, fontSize: 10),
        items: items,
        currentIndex: this.index,
        onTap: (index) => _handleBottomNavigation(context, index),
      ),
    );
  }
}