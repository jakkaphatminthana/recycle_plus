import 'package:flutter/material.dart';
import 'package:recycle_plus/screens/_Admin/mission/add/mission_add.dart';

class Admin_MissionDay extends StatefulWidget {
  const Admin_MissionDay({Key? key}) : super(key: key);

  @override
  State<Admin_MissionDay> createState() => _Admin_MissionDayState();
}

class _Admin_MissionDayState extends State<Admin_MissionDay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(),
      ),
      //TODO : ปุ่มกดมุมขวาล่าง
      floatingActionButton: buildFloatingButton(),
    );
  }

  //================================================================================================================
  //TODO : Action Add Mission
  Widget buildFloatingButton() => FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFF00883C),
        onPressed: () {
          Navigator.pushNamed(context, Admin_AddMission.routeName);
        },
      );
}
