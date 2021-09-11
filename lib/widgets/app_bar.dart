import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:plant/screens/profile/view/profile_screen.dart';
import 'package:plant/utils/router.dart';
import 'package:plant/widgets/avatar.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  CustomAppBar({Key key, this.title}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final List<Widget> actions = [
      IconButton(
        icon: Icon(Icons.search, color: Colors.black, size: 30),
        onPressed: () {},
      ),
      SizedBox(width: 10.0),
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
      SizedBox(width: 15.0)
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: AppBar(
        elevation: 0.0,
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
        // title: Row(
        //   children: [SizedBox(width: 15.0), buildLogo()],
        // ),
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
          fontSize: 24.0,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}
