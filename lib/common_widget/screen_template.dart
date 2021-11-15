import 'package:appbar_textfield/appbar_textfield.dart';
import 'package:flutter/material.dart';
import 'package:plant/common_widget/app_bar.dart';
import 'package:plant/common_widget/bottom_navigation_bar.dart';

class ScreenTemplate extends StatelessWidget {
  final Widget body;
  final String title;
  final AppBarTextField appBar;
  final bool isAppBar;
  final int index;
  ScreenTemplate({
    this.body,
    this.index,
    this.appBar,
    this.title,
    this.isAppBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.white,
      appBar: isAppBar
          ? appBar != null
              ? appBar
              : CustomAppBar(
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
