import 'package:flutter/material.dart';
import 'package:recycle_plus/screens/_Admin/home/list_menu.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
              header: "Amount of Garbage",
              subtitle: "ข้อมูลขยะในระบบ",
              iconEZ: const FaIcon(FontAwesomeIcons.trash, size: 28),
              colorEZ: const Color(0xFFFD9090),
              press: () {},
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
              press: () {},
            ),
            const SizedBox(height: 10.0),

            ListMenu(
              header: "Member",
              subtitle: "ข้อมูลสมาชิกในระบบ",
              iconEZ: const FaIcon(Icons.people, size: 35),
              colorEZ: const Color(0xFF4DD187),
              press: () {},
            ),
            const SizedBox(height: 10.0),

            ListMenu(
              header: "Verify",
              subtitle: "ตรวจสอบการยืนยันตัวตน",
              iconEZ: const FaIcon(Icons.how_to_reg, size: 35),
              colorEZ: const Color(0xFF6AC0F0),
              press: () {},
            ),
            const SizedBox(height: 10.0),

          ],
        ),
      ),
    );
  }

}
