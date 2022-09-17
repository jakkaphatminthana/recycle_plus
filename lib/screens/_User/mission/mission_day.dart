import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_User/mission/list_mission.dart';

class Member_MissionDay extends StatefulWidget {
  const Member_MissionDay({Key? key}) : super(key: key);

  @override
  State<Member_MissionDay> createState() => _Member_MissionDayState();
}

class _Member_MissionDayState extends State<Member_MissionDay> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          //TODO 1: BarTop Time
          Container(
            width: MediaQuery.of(context).size.width,
            height: 20,
            child: Stack(
              children: [
                //Image
                Image.asset(
                  'assets/image/baner_brown.jpg',
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
                //Time
                Padding(
                  padding: const EdgeInsets.only(top: 1.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.clock,
                        color: Colors.white,
                        size: 15,
                      ),
                      const SizedBox(width: 5.0),
                      Text("0D 12H 43M.", style: Roboto14_B_white),
                    ],
                  ),
                ),
              ],
            ),
          ),

          //TODO 2: Mission Body
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.55,
            child: Stack(
              children: [
                //TODO 2.1: Background
                Image.asset(
                  'assets/image/mission_bg.jpg',
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.cover,
                ),

                //TODO 2.2: Mission List
                Align(
                  alignment: const AlignmentDirectional(0, 0),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        listTile_Mission(
                          status: true,
                          title: 'เข้าสู่ระบบ ',
                          num_mission: ' 1 ครั้ง',
                          num_finish: 1,
                          num_now: 1,
                          reward_type: 'exp',
                          reward_num: 10,
                        ),
                        listTile_Mission(
                          status: false,
                          title: 'รีไซเคิล ',
                          num_mission: ' 3 ครั้ง',
                          num_finish: 3,
                          num_now: 2,
                          reward_type: 'token',
                          reward_num: 5,
                        ),
                        listTile_Mission(
                          status: false,
                          title: 'ได้รับโทเค็นจำนวน  ',
                          num_mission: '30 RCT',
                          num_finish: 30,
                          num_now: 12.5,
                          reward_type: 'exp',
                          reward_num: 25,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),

          //TODO 3: Bottom Bar
          Container(
            width: MediaQuery.of(context).size.width,
            height: 20,
            child: Image.asset(
              'assets/image/baner_brown.jpg',
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 5.0),
        ],
      ),
    );
  }
}
