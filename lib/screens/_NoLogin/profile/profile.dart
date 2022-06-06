import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Member_ProfileScreen extends StatefulWidget {
  const Member_ProfileScreen({Key? key}) : super(key: key);
  //Location Page
  static String routeName = "/MyProfile";

  @override
  State<Member_ProfileScreen> createState() => _Member_ProfileScreenState();
}

class _Member_ProfileScreenState extends State<Member_ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //TODO 1. Appbar App
      appBar: AppBar(
        backgroundColor: const Color(0xFF00883C),
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text("My Profile", style: Roboto18_B_white),
        //Icon Menu bar
        actions: [
          IconButton(
            icon: const FaIcon(
              Icons.more_vert_sharp,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {},
          ),
        ],
        elevation: 2.0,
      ),
      //----------------------------------------------------------------------------------------------
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //TODO 2. Verify Button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                    child: ElevatedButton.icon(
                      icon: const FaIcon(FontAwesomeIcons.shieldAlt, size: 14),
                      label: Text("Not Verify", style: Roboto14_B_white),
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFFE45050),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
