import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recycle_plus/components/font.dart';

import 'add sponsor/dialog_add.dart';

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
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [],
          ),
        ),
        //TODO : ปุ่มกดมุมขวาล่าง
        floatingActionButton: buildFloatingButton(),
      ),
    );
  }

  //===============================================================================================================
  //TODO : Action Add Sponsor
  Widget buildFloatingButton() => FloatingActionButton(
        child: const Icon(Icons.add_business, size: 35),
        backgroundColor: const Color(0xFF00883C),
        onPressed: () {
          // Navigator.pushNamed(context, Admin_AddMission.routeName);
          showDialogAddSponsor(context: context);
        },
      );
}
