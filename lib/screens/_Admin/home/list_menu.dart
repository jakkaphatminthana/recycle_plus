import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recycle_plus/components/font.dart';

class ListMenu extends StatelessWidget {
  const ListMenu({
    Key? key,
    required this.header,
    required this.subtitle,
    required this.iconEZ,
    required this.colorEZ,
    required this.press,
  }) : super(key: key);

  final String header;
  final String subtitle;
  final FaIcon iconEZ;
  final Color colorEZ;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: GestureDetector(
        onTap: press,
        child: ListTile(
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
            child: iconEZ,
          ),
          title: Text(header, style: Roboto16_B_black),
          subtitle: Text(subtitle, style: Roboto12_black),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: Color(0xFF303030),
            size: 20,
          ),
          tileColor: colorEZ,
          dense: false,
        ),
      ),
    );
  }
}
