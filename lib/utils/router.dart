import 'package:flutter/material.dart';
import 'package:plant/screens/home/view/home_screen.dart';
import 'package:plant/screens/login/view/sign_in_screen.dart';
import 'package:plant/screens/login/view/sign_up_screen.dart';
import 'package:plant/screens/plant/view/plant_screen.dart';
import 'package:plant/screens/profile/view/profile_screen.dart';

/// Generator callback allowing the app to be navigated to a named route.

/// Static class contains Strings of all named routes
class Routers {
  static const String sign_up = '/sign_up';
  static const String sign_in = 'sign_in';
  static const String home = '/home';
  static const String scan = '/scan';
  static const String profile = '/profile';
  static const String plant = '/plant';
}

///Return MaterialPageRoute depends of route name

// ignore: missing_return
Route<dynamic> router(routeSetting) {
  switch (routeSetting.name) {
    case Routers.sign_up:
      return new MaterialPageRoute(
        builder: (context) => SignUpScreen(),
        settings: routeSetting,
      );
      break;

    case Routers.sign_in:
      return new MaterialPageRoute(
        builder: (context) => SignInScreen(),
        settings: routeSetting,
      );
      break;

    case Routers.home:
      return new MaterialPageRoute(
        builder: (context) => HomeScreen(),
        settings: routeSetting,
      );
      break;

    case Routers.profile:
      return new MaterialPageRoute(
        builder: (context) => ProfileScreen(),
        settings: routeSetting,
      );
      break;

    case Routers.plant:
      return new MaterialPageRoute(
        builder: (context) => PlantScreen(name: 'Ficus benjamina'),
        settings: routeSetting,
      );
      break;
  }
}
