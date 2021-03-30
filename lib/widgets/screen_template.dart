import 'package:flutter/material.dart';
import 'package:plant/widgets/app_bar.dart';
import 'package:plant/widgets/bottom_navigation_bar.dart';

class ScreenTemplate extends StatelessWidget {
  final Widget body;
  final String title;
  final bool isAppBar;
  final int index;
  ScreenTemplate({
    Key key,
    this.body,
    this.index,
    this.title,
    this.isAppBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.white,
      appBar: isAppBar
          ? CustomAppBar(
              title: title,
            )
          : null,
      body: body,
      bottomNavigationBar: CustomBottomNavigationBar(
        index: index,
      ),
    );
  }
}
