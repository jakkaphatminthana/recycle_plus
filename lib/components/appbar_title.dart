import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';

import '../screens/_Admin/tabbar_control.dart';

class AppbarTitle extends StatelessWidget {
  const AppbarTitle({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.popAndPushNamed(context, Admin_TabbarHome.routeName);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            "assets/image/logo.png",
            width: 30,
            height: 30,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Text("RECYCLE+", style: Roboto18_B_white),
          ),
        ],
      ),
    );
  }
}