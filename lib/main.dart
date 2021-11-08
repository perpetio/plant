import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plant/utils/authentication.dart';
import 'package:plant/utils/router.dart';

import 'injection_container.dart' as inj_cont;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  inj_cont.init();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plant App',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: router,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Authentication(),
    );
  }
}
