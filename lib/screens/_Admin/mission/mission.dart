import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_Admin/mission/daily/mission_daily.dart';
import 'package:recycle_plus/screens/_Admin/mission/weekly/mission_weekly.dart';

class Admin_MissionScreen extends StatefulWidget {
  const Admin_MissionScreen({Key? key}) : super(key: key);
  //Location page
  static String routeName = "/Admin_Mission";

  @override
  State<Admin_MissionScreen> createState() => _Admin_MissionScreenState();
}

class _Admin_MissionScreenState extends State<Admin_MissionScreen> {
  //TODO 1. Set Tabbar list here
  TabBar get _tabbar {
    return const TabBar(
      labelColor: Colors.white,
      labelStyle: TextStyle(fontSize: 15),
      unselectedLabelColor: Color(0xFFDFDFDF),
      indicatorWeight: 2,
      indicatorColor: Colors.white,
      //labelPadding: EdgeInsets.only(top: 10.0),
      tabs: [
        Tab(text: 'Daily'),
        Tab(text: 'Weekly'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    //=================================================================================================================
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF00883C),
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: Text("Mission Management", style: Roboto16_B_white),
          //TODO 2. Tabbar in Appbar
          bottom: PreferredSize(
            preferredSize: _tabbar.preferredSize,
            child: ColoredBox(
              color: const Color(0xFF15924C),
              child: Container(
                height: 45,
                child: _tabbar,
              ),
            ),
          ),
        ),
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(), //ไม่ต้องเลื่อนได้,
          children: [
            Admin_MissionDay(),
            Admin_MissionWeek(),
          ],
        ),
      ),
    );
  }
}
