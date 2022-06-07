import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Card_menuIcon extends StatelessWidget {
  const Card_menuIcon({
    Key? key,
    required this.icon,
    required this.title,
    required this.press,
  }) : super(key: key);

  final FaIcon icon;
  final String title;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        children: [
          //TODO : เงา
          Material(
            color: Colors.transparent,
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            //TODO : Container
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFFEEEEEE),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  width: 1,
                ),
              ),
              child: Center(child: icon),
            ),
          ),
          const SizedBox(height: 5.0),

          //TODO : Title Text
          Text(title, style: Roboto14_black),
        ],
      ),
    );
  }
}
