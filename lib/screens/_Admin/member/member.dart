import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:recycle_plus/components/appbar/appbar_title.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/models/user_model.dart';
import 'package:recycle_plus/screens/_Admin/member/list_member.dart';
import 'package:recycle_plus/screens/_Admin/member/member_detail/member_detail.dart';
import 'package:recycle_plus/screens/_Admin/member/member_search.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:recycle_plus/screens/_Admin/tabbar_control.dart';
import 'package:recycle_plus/service/database.dart';

class Admin_MemberScreen extends StatefulWidget {
  //Location page
  static String routeName = "/Admin_MemberControl";

  @override
  State<Admin_MemberScreen> createState() => _Admin_MemberScreenState();
}

class _Admin_MemberScreenState extends State<Admin_MemberScreen> {
  //เรียก firebase database
  DatabaseEZ db = DatabaseEZ.instance;
  bool isMember = true;
  bool isSponsor = true;

  @override
  Widget build(BuildContext context) {
    //customIcon = Set icon Search
    //customAppbar = Widget Appbar title
    //backIcon = เปิดปิดฟังก์ชั่นกดกลับ
    Icon customIcon = const Icon(Icons.search);
    Widget customAppbarTitle = AppbarTitle(
      press: () => Navigator.popAndPushNamed(
        context,
        Admin_TabbarHome.routeName,
      ),
    );
    bool backIcon = true;

    final Stream<QuerySnapshot> _user_all = FirebaseFirestore.instance
        .collection('users')
        .where('role', isNotEqualTo: 'Admin')
        .snapshots();
    final Stream<QuerySnapshot> _user_member = FirebaseFirestore.instance
        .collection('users')
        .where("role", isEqualTo: "Member")
        .snapshots();
    final Stream<QuerySnapshot> _user_sponsor = FirebaseFirestore.instance
        .collection('users')
        .where("role", isEqualTo: "Sponsor")
        .snapshots();
//=================================================================================================================
//ส่วนหัวด้านบน หน้าจอโทรศัพท์
    return Scaffold(
      //TODO 1. Appbar Headder
      appBar: AppBar(
        backgroundColor: const Color(0xFF00883C),
        automaticallyImplyLeading: backIcon,
        centerTitle: true,
        //Title ตรงกลางกดแล้วไปหน้าแรก
        title: customAppbarTitle,
        //Icon Menu ทางขวาสุด
        actions: [
          //TODO 1.1: Search Email
          IconButton(
            icon: customIcon,
            //กดปุ่มค้นหาแล้วทำอะไรต่อ....
            onPressed: () {
              //Navigator.pushNamed(context, Admin_MemberSearch.routeName);
              showSearch(context: context, delegate: Member_Search());
            },
          ),

          //TODO 1.2: Filter Item
          IconButton(
            icon: const Icon(Icons.filter_list_outlined),
            onPressed: () {
              showInformationDialog(context);
            },
          ),
        ],
      ),
      //------------------------------------------------------------------------------------------------------------
      //ส่วนเนื้อหา หน้าจอโทรศัพท์
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            //TODO 2. Header Text
            Align(
              alignment: const AlignmentDirectional(-1, 0),
              child: Text("รายการข้อมูลสมาชิก", style: Roboto18_B_black),
            ),
            const SizedBox(height: 10.0),

            //TODO 3. Show Data
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: (isMember == true && isSponsor == false)
                    ? _user_member
                    : (isMember == false && isSponsor == true)
                        ? _user_sponsor
                        : _user_all,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    //TODO : Fetch data here
                    return ListView(
                      children: [
                        ...snapshot.data!.docs.map(
                          (QueryDocumentSnapshot<Object?> data) {
                            //ได้ตัว Data มาละ ----------<<<
                            final String email = data.get("email");
                            final String image = data['image'];
                            final String role = data['role'];

                            //จะแสดงผลข้อมูลที่ได้ในรูปแบบไหน =---------------------------
                            return (role == "Member")
                                ? ListTile_Member(
                                    data: data,
                                    image: image,
                                    email: email,
                                    role: role,
                                    level: data.get('level'),
                                  )
                                : ListTile_Member(
                                    data: data,
                                    image: image,
                                    email: email,
                                    role: role,
                                    otp: data.get('otp'),
                                  );
                          },
                        )
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

  //=================================================================================================================
  //TODO : Dialog Filter
  Future<void> showInformationDialog(BuildContext context) async {
    var check1 = isMember;
    var check2 = isSponsor;
    var checkError = 0;

    //1.Reset buttons
    Widget cancelButton = TextButton(
      child: Text("Reset", style: Roboto16_B_gray),
      onPressed: () {
        setState(() {
          isMember = true;
          isSponsor = true;
          checkError = 0;
        });
        Navigator.of(context).pop();
      },
    );
    //2.Enter buttons
    Widget continueButton = TextButton(
      child: Text("Filter", style: Roboto16_B_green),
      onPressed: () async {
        // print("isLimited = $isLimited");
        // print("isNFT = $isNFT");

        //2.1 เมื่อมีการ false ทุกตัวเลือก
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
            isMember = check1;
            isSponsor = check2;
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
              content: Column(
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

                  //3.2 Checkbox Member
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCheckBox(
                        iconEZ: Icons.person,
                        title: "Member",
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

                  //3.3 Checkbox Sponsor
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCheckBox(
                        iconEZ: Icons.business_center,
                        title: "Sponsor",
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
                child: FaIcon(iconEZ, size: 30, color: Colors.black),
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
