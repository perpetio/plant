import 'package:flutter/material.dart';
import 'package:plant/widgets/avatar.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({Key key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(70);

  final List<Widget> actions = [
    IconButton(
      icon: Icon(Icons.search, color: Colors.black, size: 30),
      onPressed: () {},
    ),
    SizedBox(width: 10.0),
    InkWell(
      onTap: () {},
      child: Avatar(
        assetName: 'assets/plant.jpg',
      ),
    ),
    SizedBox(width: 15.0)
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: AppBar(
          elevation: 0.0,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          title: Row(
            children: [SizedBox(width: 2), SizedBox(width: 15.0), _AppLogo()],
          ),
          actions: actions),
    );
  }
}

class _AppLogo extends StatelessWidget {
  const _AppLogo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Home',
      style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 24.0,
          letterSpacing: 1.0),
    );
  }
}
