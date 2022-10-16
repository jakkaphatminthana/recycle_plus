import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recycle_plus/components/font.dart';

class Admin_SponsorManager extends StatefulWidget {
  const Admin_SponsorManager({Key? key}) : super(key: key);
  //Location page
  static String routeName = "/Admin_Sponsor";

  @override
  State<Admin_SponsorManager> createState() => _Admin_SponsorManagerState();
}

class _Admin_SponsorManagerState extends State<Admin_SponsorManager> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00883C),
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text("Sponsor Management", style: Roboto16_B_white),
        actions: [
          IconButton(
            icon: const FaIcon(
              Icons.addchart_sharp,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(),
    );
  }
}
