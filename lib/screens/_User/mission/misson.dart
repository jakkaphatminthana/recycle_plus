import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_User/mission/mission_day.dart';
import 'package:recycle_plus/screens/_User/mission/mission_week.dart';

class Member_MissionScreen extends StatefulWidget {
  const Member_MissionScreen({Key? key}) : super(key: key);
  //Location page
  static String routeName = "/Mission";

  @override
  State<Member_MissionScreen> createState() => _Member_MissionScreenState();
}

class _Member_MissionScreenState extends State<Member_MissionScreen> {
  //TODO 1. Set Tabbar list here
  TabBar get _tabbar {
    return TabBar(
      indicatorWeight: 2,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.black,
      indicatorSize: TabBarIndicatorSize.label,
      indicator: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        color: Color(0xFF1CCC6A),
      ),
      tabs: [
        Tab(
          child: Align(
            alignment: Alignment.center,
            child: Text("DAILY", style: Roboto18_B),
          ),
        ),
        Tab(
          child: Align(
            alignment: Alignment.center,
            child: Text("WEEKLY", style: Roboto18_B),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    //=================================================================================================================
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  initialIndex: 0,
                  child: Column(
                    children: [
                      const SizedBox(height: 10.0),
                      Text('MISSION', style: Roboto20_B_black),
                      const SizedBox(height: 30.0),

                      //TODO 1: Tabbar
                      PreferredSize(
                        preferredSize: _tabbar.preferredSize,
                        child: ColoredBox(
                          color: Colors.transparent,
                          child: Container(
                            height: 40,
                            child: _tabbar,
                          ),
                        ),
                      ),

                      //TODO 2: TabView
                      const Expanded(
                        child: TabBarView(
                          children: [
                            Member_MissionDay(),
                            Member_MissionWeek(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
