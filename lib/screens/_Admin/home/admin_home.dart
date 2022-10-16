import 'package:flutter/material.dart';
import 'package:recycle_plus/screens/_Admin/achievement/admin_achievement.dart';
import 'package:recycle_plus/screens/_Admin/home/list_menu.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recycle_plus/screens/_Admin/member/member.dart';
import 'package:recycle_plus/screens/_Admin/mission/mission.dart';
import 'package:recycle_plus/screens/_Admin/sponsor/admin_sponsor.dart';
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
              header: "Achievement",
              subtitle: "ภารกิจความสำเร็จ",
              iconEZ: const FaIcon(FontAwesomeIcons.trophy, size: 28),
              colorEZ: const Color(0xFFF9DF8C),
              press: () {
                Navigator.pushNamed(context, Admin_AchievementScreen.routeName);
              },
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
              header: "Sponsor",
              subtitle: "จัดการข้อมมูลสปอนเซอร์",
              iconEZ: const FaIcon(FontAwesomeIcons.handsHelping, size: 28),
              colorEZ: const Color(0xFF6AC0F0),
              //TODO : Change Link Here --------------------------------------------------------------<<<<
              press: () {
                Navigator.pushNamed(context, Admin_SponsorManager.routeName);
              },
            ),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
