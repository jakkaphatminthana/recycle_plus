import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/service/database.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Test1_listData extends StatefulWidget {
  Test1_listData({Key? key}) : super(key: key);
  //Location page
  static String routeName = "/TestData1";

  @override
  State<Test1_listData> createState() => _Test1_listDataState();
}

class _Test1_listDataState extends State<Test1_listData> {
  //_formKey = Key สำหรับการ form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isNFT = true;
  bool isLimited = true;

  @override
  Widget build(BuildContext context) {
    //TODO : get data Stream Snapshot
    final Stream<QuerySnapshot> _Stream_Limited = FirebaseFirestore.instance
        .collection('test')
        .where("type", isEqualTo: "Limited")
        .snapshots();
    final Stream<QuerySnapshot> _Stream_NFT = FirebaseFirestore.instance
        .collection('test')
        .where("type", isEqualTo: "NFT")
        .snapshots();
    final Stream<QuerySnapshot> _Stream_All =
        FirebaseFirestore.instance.collection('test').snapshots();
//======================================================================================================================
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00883C),
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text("รายการสินค้า", style: Roboto16_B_white),
        //Icon Menu ทางขวาสุด
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            //TODO 1: Button fiter
            ElevatedButton(
              child: const Text("Filter"),
              onPressed: () {
                showInformationDialog(context);
              },
            ),
            const SizedBox(height: 30.0),

            //TODO 2. Data from Firebase Snapshot by me
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: (isLimited == true && isNFT == false)
                    ? _Stream_Limited
                    : (isLimited == false && isNFT == true)
                        ? _Stream_NFT
                        : _Stream_All,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Text("No data");
                  } else {
                    return ListView(
                      children: [
                        ...snapshot.data!.docs
                            .map((QueryDocumentSnapshot<Object?> data) {
                          //ได้ตัว Data มาละ ----------<<<
                          final String id = data.get("id");
                          final String type = data.get("type");

                          return Row(
                            children: [
                              Text("ID: $id"),
                              const SizedBox(width: 5.0),
                              Text("TYPE: $type"),
                            ],
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
    );
  }

  //==================================================================================================================
  //TODO : Dialog Filter
  Future<void> showInformationDialog(BuildContext context) async {
    var check1 = isLimited;
    var check2 = isNFT;
    var checkError = 0;

    //1.Cancle buttons
    Widget cancelButton = TextButton(
      child: Text("Reset", style: Roboto16_B_gray),
      onPressed: () {
        setState(() {
          isLimited = true;
          isNFT = true;
          checkError = 0;
        });
        Navigator.of(context).pop();
      },
    );
    //2.Continue buttons
    Widget continueButton = TextButton(
      child: Text("Filter", style: Roboto16_B_green),
      onPressed: () async {
        print("isLimited = $isLimited");
        print("isNFT = $isNFT");
        print("checkError = $checkError");

        //2.1 เมื่อมีการ false ทั้งสองตัวเลือก
        if (check1 == false && check2 == false) {
          setState(() {
            checkError = 1;
          });
          //กรณีเกิด ERROR all false check
          (checkError == 1)
              ? Fluttertoast.showToast(
                  msg: "โปรดเลือกเนื้อหาอย่างน้อย 1 อย่าง",
                  gravity: ToastGravity.BOTTOM,
                )
              : Container();
        } else {
          setState(() {
            isLimited = check1;
            isNFT = check2;
            checkError = 0;
          });
          Navigator.of(context).pop();
        }
      },
    );
    //3.แสดงออกมา dialog stateful
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              actions: [continueButton, cancelButton],
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //3.1 Header Text
                    Text("ขัดแยกประเภท", style: Roboto18_B_black),
                    const SizedBox(height: 5.0),
                    const Divider(
                      height: 1.0,
                      thickness: 2.0,
                      color: Color(0xFFC3C3C3),
                    ),

                    //3.2 Checkbox Limited
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCheckBox(
                          iconEZ: Icons.star_rounded,
                          title: "Limited",
                        ),
                        Transform.scale(
                          scale: 1.1,
                          child: Checkbox(
                            value: check1,
                            activeColor: const Color(0xFF00883C),
                            onChanged: (checked) {
                              setState(() {
                                check1 = checked!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    //3.3 Checkbox NFT
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCheckBox(
                          iconEZ: Icons.panorama,
                          title: "NFT",
                        ),
                        Transform.scale(
                          scale: 1.1,
                          child: Checkbox(
                            value: check2,
                            activeColor: const Color(0xFF00883C),
                            onChanged: (checked) {
                              setState(() {
                                check2 = checked!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  //TODO : CheckBox Selection
  _buildCheckBox({iconEZ, title}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        //1.แบ่งพื้นที่ 50% / 50%
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          child: Row(
            children: [
              //2. พื้นที่สำหรับ Icon
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.10,
                child: FaIcon(
                  iconEZ,
                  size: (title == "NFT") ? 25 : 30,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 5.0),
              //3. Title Type
              Text(title, style: Roboto16_B_black),
            ],
          ),
        ),
        //4. Check box
      ],
    );
  }
}
