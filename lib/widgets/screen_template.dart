import 'package:flutter/material.dart';
import 'package:plant/widgets/app_bar.dart';
import 'package:plant/widgets/bottom_navigation_bar.dart';

class ScreenTemplate extends StatelessWidget {
  final Widget body;
  final int index;
  const ScreenTemplate({Key key, this.body, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: body,
      bottomNavigationBar: CustomBottomNavigationBar(
        index: index,
      ),
    );
  }
}
