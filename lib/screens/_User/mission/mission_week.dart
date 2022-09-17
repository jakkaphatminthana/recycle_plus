import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_User/mission/list_mission.dart';

class Member_MissionWeek extends StatefulWidget {
  const Member_MissionWeek({Key? key}) : super(key: key);

  @override
  State<Member_MissionWeek> createState() => _Member_MissionWeekState();
}

class _Member_MissionWeekState extends State<Member_MissionWeek> {
  @override
  Widget build(BuildContext context) {
    return Column(
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
                    Text("4D 08H 32M.", style: Roboto14_B_white),
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
                    child: ListView(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            listTile_Mission(
                              status: false,
                              title: 'เข้าสู่ระบบ ',
                              num_mission: ' 7 ครั้ง',
                              num_finish: 7,
                              num_now: 2,
                              reward_type: 'exp',
                              reward_num: 200,
                            ),
                            listTile_Mission(
                              status: false,
                              title: 'รีไซเคิล PET',
                              num_mission: ' 10 ชิ้น',
                              num_finish: 10,
                              num_now: 5,
                              reward_type: 'token',
                              reward_num: 20,
                            ),
                            listTile_Mission(
                              status: false,
                              title: 'รีไซเคิล PP ',
                              num_mission: '10 ชิ้น',
                              num_finish: 10,
                              num_now: 3,
                              reward_type: 'exp',
                              reward_num: 100,
                            ),
                            listTile_Mission(
                              status: false,
                              title: 'รีไซเคิล LDPE ',
                              num_mission: '10 ชิ้น',
                              num_finish: 10,
                              num_now: 8,
                              reward_type: 'exp',
                              reward_num: 150,
                            ),
                            listTile_Mission(
                              status: false,
                              title: 'รีไซเคิลสะสม ',
                              num_mission: '40 ชิ้น',
                              num_finish: 40,
                              num_now: 8,
                              reward_type: 'token',
                              reward_num: 30,
                            ),
                          ],
                        ),
                      ],
                    )),
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
    );
  }
}
