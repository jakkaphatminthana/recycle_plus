import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_User/achievement/dialog_detail.dart';
import 'package:recycle_plus/screens/_User/achievement/dialog_loading.dart';
import 'package:recycle_plus/service/database.dart';

class CardHonor extends StatefulWidget {
  const CardHonor({
    Key? key,
    required this.achiment_ID,
    required this.image,
    required this.category,
    required this.title,
    required this.description,
    required this.num_finish,
    required this.trash,
    required this.user_level,
    required this.user_login,
  }) : super(key: key);
  final achiment_ID;
  final image;
  final category;
  final title;
  final description;
  final num_finish;
  final trash;
  final user_level;
  final user_login;

  @override
  State<CardHonor> createState() => _CardHonorState();
}

class _CardHonorState extends State<CardHonor> {
  User? user = FirebaseAuth.instance.currentUser;
  DatabaseEZ db = DatabaseEZ.instance;
  bool honor_claim = false;
  var honor_date;

  bool delay = false;
  bool loading = false;
  bool claim_ready = false;
  Timer? _timer;

  String? category_quest; //แปลประเภท
  String? unit; //หน่วยนับครั้ง
  int? process_numNow; //จำนวนสะสม
  int? order_recycle; //จำนวนออเดอร์ trash
  num sumtotal_trash = 0; //ผลรวมขยะแยกประเภทๆไป

  //TODO 1: Set value คำอธิบายคร่าวๆ
  Future<void> SetValue() async {
    if (widget.category == "Login") {
      category_quest = "เช็คอินสะสม";
      unit = ' วัน';
    } else if (widget.category == "Recycle") {
      category_quest = "รีไซเคิลขยะ";
      unit = ' ครั้ง';
    } else if (widget.category == "Trash") {
      category_quest = "รีไซเคิล ${widget.trash}";
      unit = " ชิ้น";
    } else if (widget.category == "Level") {
      category_quest = "ระดับเลเวลถึง Lv.";
      unit = "";
    } else {
      category_quest = "ผิดพลาด";
      unit = "";
    }
  }

  //TODO 2: Chcek Honor Claimed
  Future<void> getHonorClaim(user_ID, honor_ID) async {
    final col_honor = FirebaseFirestore.instance
        .collection('achievement')
        .doc(honor_ID)
        .collection('owner')
        .doc(user_ID)
        .get();

    final _col_claim = FirebaseFirestore.instance
        .collection('achievement')
        .doc(honor_ID)
        .collection('owner')
        .doc(user_ID)
        .snapshots()
        .listen((event) {
      setState(() {
        honor_date = event.get('timestamp');
      });
    });

    var result = await col_honor.then((value) {
      setState(() {
        if (value.data() != null) {
          honor_claim = true;
        } else {
          honor_claim = false;
        }
      });
    });
  }

  //TODO 3: GetData Order Recycle
  Future<void> getOrderRecycle({required user_ID}) async {
    final recycle_col = FirebaseFirestore.instance
        .collection('orders')
        .doc('trash')
        .collection("order")
        .where('ID_user', isEqualTo: user_ID)
        .get();

    var result = await recycle_col.then((value) {
      setState(() {
        order_recycle = value.size;
      });
    });
  }

  //TODO 0: First call whenever run
  @override
  void initState() {
    super.initState();
    SetValue();
    getHonorClaim(user!.uid, widget.achiment_ID);
    getOrderRecycle(user_ID: user!.uid);

    //1.Delay loading
    _timer = Timer(const Duration(milliseconds: 1000), () {
      setState(() {
        delay = true;
        //2.Honor ที่กำลังทำอยู่
        if (widget.category == "Login") {
          process_numNow = widget.user_login;
        } else if (widget.category == "Recycle") {
          process_numNow = order_recycle;
        } else if (widget.category == "Trash") {
          process_numNow = 0;
        } else if (widget.category == "Level") {
          process_numNow = widget.user_level;
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //คำอธิบาย
    final detail_quest = '$category_quest ${widget.num_finish}${unit}';

    //collection trash category
    final Stream<QuerySnapshot> _stream_orderTrash = FirebaseFirestore.instance
        .collection('orders')
        .doc('trash')
        .collection('order')
        .where('ID_user', isEqualTo: user!.uid)
        .where('trash_type', isEqualTo: widget.trash)
        .snapshots();
    //=============================================================================================================
    return (delay == false)
        ? const SpinKitRing(
            color: Colors.green,
            size: 40.0,
          )
        : Material(
            color: Colors.transparent,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              width: 100,
              height: 130,
              decoration: BoxDecoration(
                color: const Color(0xFF357450),
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 4,
                    color: Color(0x33000000),
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                        stream: _stream_orderTrash,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          //TODO : MODEL กรณีที่ภารกิจสำเร็จ --------------------------------------
                          bool check_mission = (widget.category == 'Trash')
                              ? sumtotal_trash >= widget.num_finish
                              : (widget.category == "Recycle")
                                  ? order_recycle! >= widget.num_finish
                                  : (widget.category == "Login")
                                      ? widget.user_login >= widget.num_finish
                                      : (widget.category == "Level")
                                          ? widget.user_level >=
                                              widget.num_finish
                                          : false;
                          if (!snapshot.hasData) {
                            return Container();
                          } else {
                            return Column(
                              children: [
                                //TODO : Fetch data here
                                ...snapshot.data!.docs
                                    .map((QueryDocumentSnapshot<Object?> data) {
                                  //ผลรวมจำนวนขยะจาก Field ทั้งหมด
                                  final amount = data.get("amount");
                                  (widget.trash != '')
                                      ? sumtotal_trash += amount
                                      : null;

                                  return Container();
                                }),

                                //TODO : กดเครมเมื่อถึงเป้าหมาย (onTap อยุ่ด้านล่างเด้อ)
                                GestureDetector(
                                  child: Column(
                                    children: [
                                      //TODO 1: Title Name
                                      Text(widget.title,
                                          style: Roboto16_B_white),
                                      const SizedBox(height: 8.0),

                                      //TODO 2: Image Honor
                                      GestureDetector(
                                        //TODO 2.1: กรณีที่ ยังไม่ได้เป็นเจ้าของ
                                        child: (honor_claim == false)
                                            ? ColorFiltered(
                                                colorFilter:
                                                    const ColorFilter.matrix(
                                                  <double>[
                                                    0.2126,
                                                    0.7152,
                                                    0.0722,
                                                    0,
                                                    0,
                                                    0.2126,
                                                    0.7152,
                                                    0.0722,
                                                    0,
                                                    0,
                                                    0.2126,
                                                    0.7152,
                                                    0.0722,
                                                    0,
                                                    0,
                                                    0,
                                                    0,
                                                    0,
                                                    1,
                                                    0,
                                                  ],
                                                ),
                                                child: Image.network(
                                                  widget.image,
                                                  width: 100,
                                                  height: 100,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            //TODO 2.2: กรณีที่ เป็นเจ้าของแล้ว
                                            : Image.network(
                                                widget.image,
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.cover,
                                              ),
                                        //ดูลายละเอียดรูปภาพ (กรณีที่ถึงเป้าหมายแล้ว แต่ต้องกดเคลม)
                                        onTap: (honor_claim == false &&
                                                    (widget.category == "Trash")
                                                ? sumtotal_trash >=
                                                    widget.num_finish
                                                : process_numNow! >=
                                                    widget.num_finish)
                                            ? null
                                            : () => showDialogAchiDetail(
                                                  context: context,
                                                  image: widget.image,
                                                  title: widget.title,
                                                  detail: detail_quest,
                                                  description:
                                                      widget.description,
                                                ),
                                      ),
                                      const SizedBox(height: 5.0),

                                      //TODO 4: Detail Process
                                      //กรณีที่รับรางวัลแล้ว
                                      (honor_claim == true)
                                          ? Column(
                                              children: [
                                                const SizedBox(height: 5.0),
                                                Text(
                                                  'เป็นเจ้าของแล้ว',
                                                  style: Roboto14_B_white,
                                                ),
                                                Text(
                                                  formattedDate(honor_date),
                                                  style: Roboto12_white,
                                                ),
                                              ],
                                            )
                                          : build_ProcessMain(
                                              detail: detail_quest,
                                              num_now:
                                                  (widget.category == "Trash")
                                                      ? sumtotal_trash
                                                      : process_numNow,
                                              num_finish: widget.num_finish,
                                            )
                                    ],
                                  ),
                                  //TODO : กดเครมเมื่อถึงเป้าหมายแล้ว -----------------------------------<<<<
                                  onTap: () async {
                                    if (honor_claim == false && check_mission) {
                                      print('Claim!!');
                                      showDialogLoading(
                                        context: context,
                                        achiment_ID: widget.achiment_ID,
                                        user_ID: user!.uid,
                                      );
                                    }
                                  },
                                ),
                              ],
                            );
                          }
                        }),
                  ],
                ),
              ),
            ),
          );
  }

  //=============================================================================================================
  //TODO 1: Mission Detail Process
  Widget build_ProcessMain({detail, num_now, num_finish}) {
    final percent = ((num_now! / widget.num_finish) * 41) / 100;

    return Column(
      children: [
        //TODO 1.1: quest Text
        Text(detail, style: Roboto14_B_white),
        const SizedBox(height: 5.0),

        //TODO 1.2: ProcessBar
        Stack(
          children: [
            build_ProcessBar(color: const Color(0xFF522304), width: 0.41),
            build_ProcessBar(color: const Color(0xFFF0CB6A), width: percent),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //TODO 1.3: กรณีที่ภารกิจถึงเป้าหมายแล้ว
                (num_now >= num_finish)
                    ? Text(
                        'CLAIM  NOW',
                        style: Roboto14_B_brown,
                      )
                    : Text(
                        '$num_now/$num_finish',
                        style: Roboto14_B_white,
                      ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  //TODO 2: Mission Bar
  Widget build_ProcessBar({color, width}) {
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

  //TODO 3: Format Time
  String formattedDate(timeStamp) {
    var dateFromTimeStamp =
        DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
    return DateFormat('dd/MM/yyyy').format(dateFromTimeStamp);
  }
}
