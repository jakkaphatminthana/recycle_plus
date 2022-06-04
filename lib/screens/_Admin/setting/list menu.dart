import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recycle_plus/components/font.dart';

class ListMenuSetting extends StatelessWidget {
  const ListMenuSetting({
    Key? key,
    required this.title,
    required this.iconEZ,
    required this.press,
  }) : super(key: key);

  final String title;
  final FaIcon iconEZ;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: GestureDetector(
        onTap: press,
        child: Card(
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(5.0)),
          child: ListTile(
            leading: Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
              child: iconEZ,
            ),
            title: Text(title, style: Roboto16_B_black),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
              size: 20,
            ),
            tileColor: Colors.white,
            dense: false,
          ),
        ),
      ),
    );
  }
}
