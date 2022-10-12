import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_User/exchange/detail/dialog_buy.dart';
import 'package:recycle_plus/screens/_User/mission/dialog_success.dart';
import 'package:recycle_plus/screens/_User/tabbar_control.dart';

class listTile_Mission extends StatefulWidget {
  listTile_Mission({
    Key? key,
    required this.mission_ID,
    required this.mission_type,
    required this.title,
    required this.category,
    required this.num_finish,
    required this.reward_type,
    required this.reward_num,
    required this.trash,
  }) : super(key: key);
  final mission_ID;
  final mission_type;
  final title;
  final category;
  final num_finish;
  final reward_type;
  final reward_num;
  final trash;

  @override
  State<listTile_Mission> createState() => _listTile_MissionState();
}

class _listTile_MissionState extends State<listTile_Mission> {
  User? user = FirebaseAuth.instance.currentUser;
  bool delay = false;
  Timer? _timer;

  //Day
  DateTime now = DateTime.now();
  String dateNow = DateFormat('yyyy-MM-dd').format(DateTime.now());

  //Week
  DateTime fistdayOfWeek =
      DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
  DateTime lastdayOfWeek = DateTime.now()
      .add(Duration(days: DateTime.daysPerWeek - DateTime.now().weekday));
  String TimeScale =
      "${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)))},${DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: DateTime.daysPerWeek - DateTime.now().weekday)))}";

  bool mission_claim = false;
  bool mission_status = false;
  int? miss_loginDay = 1;
  int? miss_recycle_num;
  num? miss_trash_PETE;
  num? miss_trash_PP;
  num? miss_trash_LDPE;

  int? mission_numNow; //จำนวนที่กำลังทำอยู่
  int numnum = 0;
  num sumtotal = 0;

  // TODO 1: Get Mission Status Claim for today
  Future<void> getMissionClaim(
      mission_type, mission_ID, user_ID, dateNow) async {
    final _col_Day = FirebaseFirestore.instance
        .collection('mission_day')
        .doc(mission_ID)
        .collection('list-date')
        .doc(dateNow)
        .collection('complete')
        .doc(user_ID)
        .get();

    final _col_Week = FirebaseFirestore.instance
        .collection('mission_week')
        .doc(mission_ID)
        .collection('list-date')
        .doc(TimeScale)
        .collection('complete')
        .doc(user_ID)
        .get();

    final select_col = (mission_type == 'day') ? _col_Day : _col_Week;

    var result = await select_col.then((value) {
      //print('data value = ${value.data()}');
      setState(() {
        if (value.data() != null) {
          mission_claim = true;
        } else {
          mission_claim = false;
        }
      });
    });
  }

  //TODO 2: Order Trash Recycle
  Future<void> getNumofOrderRecycle(user_ID, mission_type) async {
    final _col_Day = FirebaseFirestore.instance
        .collection('orders')
        .doc('trash')
        .collection('order')
        .where('ID_user', isEqualTo: user_ID)
        .where('timeDate', isEqualTo: dateNow)
        .get();

    final _col_Week = FirebaseFirestore.instance
        .collection('orders')
        .doc('trash')
        .collection('order')
        .where('ID_user', isEqualTo: user_ID)
        .where('timeWeek', isEqualTo: TimeScale)
        .get();

    final select_col = (mission_type == 'day') ? _col_Day : _col_Week;

    var result = await select_col.then((value) {
      setState(() {
        miss_recycle_num = value.size;
      });
    });
  }

  //TODO 3: Order Trash
  Future<void> getNumofOrderTrash(cateTrash, total) async {
    setState(() {
      if (cateTrash == "PETE") {
        miss_trash_PETE = total;
      } else if (cateTrash == "LDPE") {
        miss_trash_LDPE = total;
      } else if (cateTrash == "PP") {
        miss_trash_PP = total;
      }
    });
  }

  //TODO 0: First call whenever run
  @override
  void initState() {
    super.initState();
    getMissionClaim(widget.mission_type, widget.mission_ID, user!.uid, dateNow);
    getNumofOrderRecycle(user!.uid, widget.mission_type);
    getNumofOrderTrash(widget.trash, sumtotal);

    //1.Delay loading
    _timer = Timer(const Duration(milliseconds: 1000), () {
      setState(() {
        delay = true;
        //2.Mission ที่กำลังทำอยู่
        if (widget.category == "Login") {
          mission_numNow = miss_loginDay;
        } else if (widget.category == "Recycle") {
          mission_numNow = miss_recycle_num;
        } else if (widget.category == "Trash") {
          mission_numNow = int.parse('$sumtotal');
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    String unit = (widget.category == 'Recycle' || widget.category == "Login")
        ? 'ครั้ง'
        : 'ชิ้น';

    final Stream<QuerySnapshot> orderTrash_Day = FirebaseFirestore.instance
        .collection('orders')
        .doc('trash')
        .collection('order')
        .where('ID_user', isEqualTo: user!.uid)
        .where('timeDate', isEqualTo: dateNow)
        .where('trash_type', isEqualTo: widget.trash)
        .snapshots();

    final Stream<QuerySnapshot> orderTrash_Week = FirebaseFirestore.instance
        .collection('orders')
        .doc('trash')
        .collection('order')
        .where('ID_user', isEqualTo: user!.uid)
        .where('timeWeek', isEqualTo: TimeScale)
        .where('trash_type', isEqualTo: widget.trash)
        .snapshots();

    //===============================================================================================================
    return (delay == false)
        ? const Padding(
            padding: EdgeInsets.all(10),
            child: SpinKitRing(
              color: Colors.green,
              size: 40.0,
            ),
          )
        : StreamBuilder<QuerySnapshot>(
            stream: (widget.mission_type == 'day')
                ? orderTrash_Day
                : orderTrash_Week,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              //TODO : MODEL กรณีที่รับของรางวัลไปแล้ว & ภารกิจสำเร็จ -------------------------
              bool check_mission = (widget.category == 'Trash')
                  ? sumtotal >= widget.num_finish
                  : (widget.category == "Recycle")
                      ? miss_recycle_num! >= widget.num_finish
                      : (widget.category == "Login" &&
                              widget.mission_type == 'day')
                          ? miss_loginDay! >= widget.num_finish
                          : false;
              if (!snapshot.hasData) {
                return const SpinKitCircle(
                  color: Colors.green,
                  size: 50,
                );
              } else {
                return Column(
                  children: [
                    //TODO : Fetch data here
                    ...snapshot.data!.docs
                        .map((QueryDocumentSnapshot<Object?> data) {
                      //ผลรวมจำนวนขยะจาก Field ทั้งหมด
                      final amount = data.get("amount");
                      (widget.trash != '') ? sumtotal += amount : null;

                      return Container();
                    }),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      //TODO 1: Contaner
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F5F8),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              //TODO 2: Icon Image
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                child: (mission_claim == true)
                                    ? Image.asset(
                                        "assets/image/mission_com.png",
                                        width: 45,
                                        height: 45,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        "assets/image/mission.png",
                                        width: 45,
                                        height: 45,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              const SizedBox(width: 5.0),

                              //TODO 3: Detail Mission
                              Container(
                                width: MediaQuery.of(context).size.width * 0.44,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //TODO 3.1: Text title
                                    Row(
                                      children: [
                                        //1. เนื้อหาภารกิจ
                                        Text(widget.title,
                                            style: Roboto14_B_brown),

                                        //2. กรณีที่เป็นภารกิจ Recycle
                                        (widget.category == "Trash")
                                            ? Text(" ${widget.trash}",
                                                style: Roboto14_B_brown)
                                            : Container(),

                                        //3.จำนวนภารกิจ
                                        TextPending(
                                          Text(
                                            ' ${widget.num_finish}',
                                            style: Roboto14_B_brown,
                                          ),
                                        ),
                                        //4.หน่วยนับภารกิจ
                                        Text(" $unit", style: Roboto14_B_brown),
                                      ],
                                    ),
                                    const SizedBox(height: 5.0),

                                    //TODO 3.2: Mission Bar
                                    Stack(
                                      children: [
                                        build_missonBar(
                                          color: const Color(0xFF522304),
                                          width: 0.5,
                                        ),
                                        build_missonBar(
                                          color: const Color(0xFFF0CB6A),
                                          width: (mission_numNow == null)
                                              ? 0
                                              : (widget.category == 'Trash')
                                                  ? ((sumtotal /
                                                              widget
                                                                  .num_finish) *
                                                          50) /
                                                      100
                                                  : ((mission_numNow! /
                                                              widget
                                                                  .num_finish) *
                                                          50) /
                                                      100,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            //กรณีที่รับของรางวัลไปแล้ว & ภารกิจสำเร็จ
                                            (check_mission ||
                                                    sumtotal >=
                                                        widget.num_finish)
                                                ? Text(
                                                    'SUCCESS',
                                                    style: Roboto14_B_white,
                                                  )
                                                : Text(
                                                    //กรณีที่ภารกิจเป็นแบบ Trash
                                                    (widget.trash != '')
                                                        ? '${sumtotal}/${widget.num_finish}'
                                                        : '${mission_numNow}/${widget.num_finish}',
                                                    style: Roboto14_B_white,
                                                  ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 5.0),

                              //TODO 4: Button Reward
                              GestureDetector(
                                onTap: () {
                                  // var timeEZ = DateTime.now();
                                  // print('time: $timeEZ');
                                  // print('timeweek: ${now.weekday}');
                                  // print('datenow: $dateNow');
                                  // print('nextWeek: $nextWeek');
                                  // print('status: $mission_claim');
                                  // print('miss_recycle: $miss_recycle_num');
                                  // print('miss_PETE: $miss_trash_PETE');
                                  // print('miss_LDPE: $miss_trash_LDPE');
                                  // print('miss_PP: $miss_trash_PP');
                                  // print('mission_now: $mission_numNow');
                                  // print('sumtotal: $sumtotal');

                                  //เฉพาะกรณีที่ยังไม่ได้รับรางวัล & ภารกิจสำเสร็จ
                                  if (mission_claim == false) {
                                    if (check_mission ||
                                        sumtotal >= widget.num_finish) {
                                      showDialogMissionSuccess(
                                        context: context,
                                        user_ID: user!.uid,
                                        mission_ID: widget.mission_ID,
                                        mission_type: widget.mission_type,
                                      );
                                    }
                                  }
                                },
                                child: Material(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.22,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.06,
                                      decoration: BoxDecoration(
                                          //กรณีที่รับของรางวัลไปแล้ว & ภารกิจสำเร็จ
                                          color: (check_mission ||
                                                  sumtotal >= widget.num_finish)
                                              ? const Color(0xFF1CCC6A)
                                              : const Color.fromARGB(
                                                  155,
                                                  89,
                                                  85,
                                                  85,
                                                ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: const Color(0x32000000),
                                            width: 1,
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black,
                                              blurRadius: 1,
                                              spreadRadius: 0,
                                            ),
                                            BoxShadow(
                                              color: Colors.white,
                                              blurRadius: 10,
                                              spreadRadius: 5,
                                            ),
                                          ]),
                                      //กรณีที่รับของรางวัลไปแล้ว & ภารกิจสำเร็จ
                                      child: (mission_claim != true)
                                          ? build_reward(
                                              type: widget.reward_type,
                                              num_reward: widget.reward_num,
                                              status: (check_mission ||
                                                      sumtotal >=
                                                          widget.num_finish)
                                                  ? true
                                                  : false,
                                            )
                                          : const Center(
                                              child: Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 24,
                                              ),
                                            )),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          );
  }

  //==================================================================================================================
  //TODO 1: Mission Bar
  Widget build_missonBar({color, width}) {
    return Container(
      width: MediaQuery.of(context).size.width * width,
      height: 15,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          width: 1,
        ),
      ),
    );
  }

  //TODO 2: Reward in Button
  Widget build_reward({type, num_reward, status}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //TODO 2.1: Reward num
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (type == 'Exp')
                  ? Image.asset(
                      'assets/image/exp2.png',
                      width: 12,
                      height: 12,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/image/token.png',
                      width: 15,
                      height: 15,
                      fit: BoxFit.cover,
                    ),
              const SizedBox(width: 5.0),
              Text(
                (type == "Exp") ? '$num_reward XP.' : '$num_reward RCT',
                style: (status == true) ? Roboto12_B_yellow : Roboto12_B_gray,
              ),
            ],
          ),
          //TODO 2.2: Text Button
          (status == true)
              ? Text(
                  'CLAIM',
                  style: Roboto14_B_white,
                )
              : Text(
                  'Reward',
                  style: Roboto14_B_black,
                )
        ],
      ),
    );
  }

  //TODO 3: Save Pending text
  Widget TextPending(textEZ) {
    return Padding(
      padding: const EdgeInsets.only(top: 2.0),
      child: textEZ,
    );
  }

  //TODO 4: Format Time
  String formatDateFB(timeStamp) {
    var dateFromTimeStamp =
        DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
    return DateFormat('yyyy/MM/dd').format(dateFromTimeStamp);
  }
}
