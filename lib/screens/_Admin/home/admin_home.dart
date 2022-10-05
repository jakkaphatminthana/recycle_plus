import 'package:flutter/material.dart';
import 'package:recycle_plus/screens/_Admin/home/list_menu.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recycle_plus/screens/_Admin/member/member.dart';
import 'package:recycle_plus/screens/_Admin/mission/mission.dart';
import 'package:recycle_plus/screens/_Admin/trash/trash.dart';
import 'package:recycle_plus/screens/test/test_MutiAddData.dart';
import 'package:recycle_plus/screens/test/test_blockchain.dart';
import 'package:recycle_plus/screens/test/test_metamask.dart';

class Admin_HomeScreen extends StatefulWidget {
  const Admin_HomeScreen({Key? key}) : super(key: key);

  @override
  State<Admin_HomeScreen> createState() => _Admin_HomeScreenState();
}

class _Admin_HomeScreenState extends State<Admin_HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10.0),
            ListMenu(
              header: "Garbage Trash",
              subtitle: "ข้อมูลขยะในระบบ",
              iconEZ: const FaIcon(FontAwesomeIcons.trash, size: 28),
              colorEZ: const Color(0xFFFD9090),
              press: () {
                Navigator.pushNamed(context, Admin_TrashControl.routeName);
              },
            ),
            const SizedBox(height: 10.0),
            ListMenu(
              header: "Petition List",
              subtitle: "รายการคำร้อง",
              iconEZ: const FaIcon(FontAwesomeIcons.stream, size: 28),
              colorEZ: const Color(0xFFF9DF8C),
              press: () {},
            ),
            const SizedBox(height: 10.0),
            ListMenu(
              header: "Mission List",
              subtitle: "รายการภารกิจ",
              iconEZ: const FaIcon(FontAwesomeIcons.compass, size: 32),
              colorEZ: const Color(0xFF9EE971),
              press: () {
                Navigator.pushNamed(context, Admin_MissionScreen.routeName);
              },
            ),
            const SizedBox(height: 10.0),
            ListMenu(
              header: "Member",
              subtitle: "ข้อมูลสมาชิกในระบบ",
              iconEZ: const FaIcon(Icons.people, size: 35),
              colorEZ: const Color(0xFF4DD187),
              press: () {
                Navigator.pushNamed(context, Admin_MemberScreen.routeName);
              },
            ),
            const SizedBox(height: 10.0),
            ListMenu(
              header: "Verify",
              subtitle: "ตรวจสอบการยืนยันตัวตน",
              iconEZ: const FaIcon(Icons.how_to_reg, size: 35),
              colorEZ: const Color(0xFF6AC0F0),
              //TODO : Change Link Here --------------------------------------------------------------<<<<
              press: () {
                Navigator.pushNamed(context, Test_MetaMask.routeName);
              },
            ),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
