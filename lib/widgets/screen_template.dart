import 'package:flutter/material.dart';
import 'package:plant/widgets/app_bar.dart';
import 'package:plant/widgets/bottom_navigation_bar.dart';

class ScreenTemplate extends StatelessWidget {
  final Widget body;
  final String title;
  final int index;
  const ScreenTemplate({Key key, this.body, this.index, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: title,
      ),
      body: body,
      bottomNavigationBar: CustomBottomNavigationBar(
        index: index,
      ),
    );
  }
}
