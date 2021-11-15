import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:plant/screens/profile/page/profile_screen.dart';
import 'package:plant/core/utils/router.dart';
import 'package:plant/common_widget/avatar.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  CustomAppBar({
    this.title,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final List<Widget> actions = [
      IconButton(
        icon: Icon(Icons.search, color: Colors.black, size: 30),
        onPressed: () {},
      ),
      SizedBox(width: 10),
      InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          Navigator.of(context).pushAndRemoveUntil(
            PageTransition(
                type: PageTransitionType.fade, child: ProfileScreen()),
            ModalRoute.withName(Routers.profile),
          );
        },
        child: Avatar(),
      ),
      SizedBox(width: 15)
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        title: Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        actions: actions,
      ),
    );
  }

  Widget buildLogo() {
    return Flexible(
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 24,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
