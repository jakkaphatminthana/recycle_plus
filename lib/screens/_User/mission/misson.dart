import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recycle_plus/components/font.dart';

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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10.0),
              Text('MISSION', style: Roboto20_B_black),
              const SizedBox(height: 20.0),
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

              //TODO 2: BarTop Time
              Container(
                width: MediaQuery.of(context).size.width,
                height: 20,
                child: Stack(children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: Image.asset(
                      'assets/image/baner_brown.jpg',
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
