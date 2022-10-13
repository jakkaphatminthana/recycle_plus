import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';

class Admin_AchievementScreen extends StatefulWidget {
  const Admin_AchievementScreen({Key? key}) : super(key: key);

  //Location page
  static String routeName = "/Admin_Achievement";

  @override
  State<Admin_AchievementScreen> createState() =>
      _Admin_AchievementScreenState();
}

class _Admin_AchievementScreenState extends State<Admin_AchievementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00883C),
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text("Achievement", style: Roboto16_B_white),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
