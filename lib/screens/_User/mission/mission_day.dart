import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_User/exchange/detail/dialog_buy.dart';
import 'package:recycle_plus/screens/_User/mission/list_mission.dart';

class Member_MissionDay extends StatefulWidget {
  const Member_MissionDay({Key? key}) : super(key: key);

  @override
  State<Member_MissionDay> createState() => _Member_MissionDayState();
}

class _Member_MissionDayState extends State<Member_MissionDay> {
  User? user = FirebaseAuth.instance.currentUser;
  DateTime now = DateTime.now();
  String dateNow = DateFormat('dd/MM/yyyy').format(DateTime.now());
  String dateNext = DateFormat('dd/MM/yyy')
      .format(DateTime.now().add(const Duration(days: 1)));

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _Mission_Day = FirebaseFirestore.instance
        .collection('mission_day')
        .orderBy('timestamp', descending: false)
        .snapshots();
    //===============================================================================================================
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _Mission_Day,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const SpinKitCircle(
                  color: Colors.green,
                  size: 50,
                );
              } else {
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
                                Text("$dateNow (23:59)",
                                    style: Roboto14_B_white),
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
                          (user != null)
                              ? Align(
                                  alignment: const AlignmentDirectional(0, 0),
                                  child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      //TODO : Firebase get <<------------------------------
                                      child: ListView(
                                        children: [
                                          //TODO : Fetch data here
                                          ...snapshot.data!.docs.map(
                                              (QueryDocumentSnapshot<Object?>
                                                  data) {
                                            //ได้ตัว Data มาละ ----------<<<
                                            final mission_type =
                                                data.get('mission');
                                            final category =
                                                data.get('category');
                                            final title = data.get("title");
                                            final num_finish =
                                                data.get('num_finish');
                                            final reward = data.get('reward');
                                            final num_reward =
                                                data.get('num_reward');
                                            final trash = data.get('trash');

                                            return listTile_Mission(
                                              mission_ID: data.id,
                                              mission_type: mission_type,
                                              category: category,
                                              title: title,
                                              num_finish: num_finish,
                                              reward_type: reward,
                                              reward_num: num_reward,
                                              trash: trash,
                                            );
                                          }),
                                        ],
                                      )),
                                )
                              : NoLogin(),
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
            },
          ),
        ),
      ],
    );
  }

  //=================================================================================================================
  Widget NoLogin() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error,
            color: Colors.black,
            size: 90,
          ),
          Text('Only Member', style: Roboto20_B_black),
          const SizedBox(height: 5.0),
          Text(
            'โปรดเข้าสู่ระบบเพื่อเปิดใช้งานฟังก์ชันนี้',
            style: Roboto16_black,
          ),
        ],
      ),
    );
  }
}
