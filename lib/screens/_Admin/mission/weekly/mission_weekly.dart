import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:recycle_plus/screens/_Admin/mission/add/mission_add.dart';
import 'package:recycle_plus/screens/_Admin/mission/list_mission.dart';

class Admin_MissionWeek extends StatefulWidget {
  const Admin_MissionWeek({Key? key}) : super(key: key);

  @override
  State<Admin_MissionWeek> createState() => _Admin_MissionWeekState();
}

class _Admin_MissionWeekState extends State<Admin_MissionWeek> {
  final Stream<QuerySnapshot> _Mission_week =
      FirebaseFirestore.instance.collection('mission_week').snapshots();

  @override
  Widget build(BuildContext context) {
    //=============================================================================================================
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _Mission_week,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  } else {
                    return ListView(
                      children: [
                        //TODO : Fetch data here
                        ...snapshot.data!.docs
                            .map((QueryDocumentSnapshot<Object?> data) {
                          //ได้ตัว Data มาละ ----------<<<
                          final category = data.get("category");
                          final title = data.get("title");
                          final num_finish = data.get("num_finish");
                          final reward = data.get("reward");
                          final num_reward = data.get("num_reward");
                          final trash = data.get("trash");

                          return ListTile_MissionAdmin(
                            data: data,
                            category: category,
                            title: title,
                            num_finish: num_finish,
                            reward_type: reward,
                            reward_num: num_reward,
                            trash: trash,
                          );
                        }),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
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
