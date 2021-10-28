import 'package:flutter/material.dart';
import 'package:plant/models/plant_model.dart';
import 'package:plant/models/user_data.dart';
import 'package:plant/screens/change_password/page/change_password_screen.dart';
import 'package:plant/screens/edit_profile/page/edit_profile_screen.dart';
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
  static const String edit_profile = '/edit_profile';
  static const String change_password = '/change_password';
}

///Return MaterialPageRoute depends of route name

// ignore: missing_return
Route<dynamic> router(RouteSettings routeSetting) {
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
      final plant = routeSetting.arguments as PlantsModels;
      return new MaterialPageRoute(
        builder: (context) => PlantScreen(
          plantsModels: plant,
        ),
        settings: routeSetting,
      );
      break;

    case Routers.edit_profile:
      final user = routeSetting.arguments as UserData;
      return MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          user: user,
        ),
        settings: routeSetting,
      );
      break;

    case Routers.change_password:
      return MaterialPageRoute(
        builder: (context) => ChangePasswordScreen(),
        settings: routeSetting,
      );
  }
}
