import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Social_Card extends StatelessWidget {
  const Social_Card({
    Key? key,
    required this.icon,
    required this.press,
  }) : super(key: key);

  final String icon;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: press,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SvgPicture.asset(
            icon,
            width: 45,
            height: 45,
            fit: BoxFit.cover,
          ),
        ));
  }
}
