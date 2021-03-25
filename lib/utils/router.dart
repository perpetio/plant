import 'package:flutter/material.dart';
import 'package:plant/screens/home/view/home_screen.dart';
import 'package:plant/screens/profile/view/profile_screen.dart';
import 'package:plant/screens/scan/view/detect.dart';

/// Generator callback allowing the app to be navigated to a named route.

/// Static class contains Strings of all named routes
class Routers {
  static const String home = '/home';
  static const String scan = '/scan';
  static const String profile = '/profile';
}

///Return MaterialPageRoute depends of route name

// ignore: missing_return
Route<dynamic> router(routeSetting) {
  switch (routeSetting.name) {
    case Routers.home:
      return new MaterialPageRoute(
        builder: (context) => HomeScreen(),
        settings: routeSetting,
      );
      break;
    case Routers.scan:
      return new MaterialPageRoute(
        builder: (context) => Detect(),
        settings: routeSetting,
      );
      break;
    case Routers.profile:
      return new MaterialPageRoute(
        builder: (context) => ProfileScreen(),
        settings: routeSetting,
      );
      break;
  }
}
