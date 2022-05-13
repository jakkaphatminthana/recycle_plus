import 'dart:async';

import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/models/user_model.dart';
import 'package:recycle_plus/screens/_Admin/member/member_detail/card_MemberStatus.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:recycle_plus/screens/_Admin/member/member_edit/member_edit.dart';
import 'package:recycle_plus/service/database.dart';

class Admin_MemberDetail extends StatefulWidget {
  //Location page
  static String routeName = "/Admin_MemberDetail";
  //ก่อนจะเรียกหน้านี้จำเป็นต้องมี paramiter data
  const Admin_MemberDetail({required this.data1, required this.data2});

  final data1; //data snapshot ทั่วไป
  final data2; //data Querysnapshot (หน้า search)

  @override
  State<Admin_MemberDetail> createState() => _Admin_MemberDetailState();
}

class _Admin_MemberDetailState extends State<Admin_MemberDetail> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  //เรียก firebase database
  DatabaseEZ db = DatabaseEZ.instance;

  @override
  Widget build(BuildContext context) {
    Stream<List<UserModel>> user_strem = db.getStateUser();
    final queryID = FirebaseFirestore.instance
        .collectionGroup('users')
        .where('id', isEqualTo: widget.data1);

    var data; //ใช้เก็บข้อมูลแทน data1, data2

    //ถ้ามีการส่งข้อมูลมาแบบไหน data เช่น data1, data2 ตัวแปร data จะเท่ากับค่านั้น
    if (widget.data1 != null) {
      data = widget.data1;
    } else {
      data = widget.data2;
    }

    return Scaffold(
      key: scaffoldKey,
      //TODO 1. Appbar Header
      appBar: AppBar(
        backgroundColor: const Color(0xFF00883C),
        automaticallyImplyLeading: true,
        title: Text("Profile", style: Roboto18_B_white),
        centerTitle: true,
        actions: [
          //Dropdown Menu appbar ปุ่มกด
          PopupMenuButton<int>(
            //item คือค่าในการบอกว่า user ได้กดเมนูไหนเช่น 0,1,2 (มันคือ value นั้นแหละ)
            //OnSelected = ส่งค่าที่เลือกเมนู่ไปยังฟังก์ชั่น onSelected
            onSelected: (item) => onSelectedMenu(context, item),
            itemBuilder: (context) => [
              const PopupMenuItem<int>(
                value: 0,
                child: Text("Edit"),
              ),
              const PopupMenuItem<int>(
                value: 1,
                child: Text("Delete"),
              ),
            ],
          ),
        ],
      ),
      //================================================================================================
      body: Align(
        alignment: const AlignmentDirectional(0, 0),
        child: Column(
          children: [
            const SizedBox(height: 20.0),

            Expanded(child: Text("data 1 = ${widget.data1}")),
            Expanded(child: Text("data 2 = ${widget.data2}")),
            Expanded(child: Text("data = ${data}")),
            Expanded(child: Text("query = ${queryID}")),

            // //TODO 2. Avatar Profile
            // Expanded(
            //   child: Container(
            //     width: 100,
            //     height: 100,
            //     clipBehavior: Clip.antiAlias,
            //     decoration: BoxDecoration(
            //       shape: BoxShape.circle,
            //       border: Border.all(width: 1),
            //     ),
            //     child: Image.network(
            //       "${data!.get('image')}",
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 10.0),

            // //TODO 3. Name and Email
            // Expanded(
            //   child: Column(
            //     children: [
            //       Text(data!.get('name'), style: Roboto20_B_green),
            //       Text(data!.get('email'), style: Roboto16_w500_black),
            //     ],
            //   ),
            // ),
            // const SizedBox(height: 20.0),

            // //TODO 4. Status User
            // Container(
            //   width: MediaQuery.of(context).size.width,
            //   height: 150,
            //   decoration: const BoxDecoration(color: Color(0xFFEEEEEE)),
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 20.0),
            //     child: Row(
            //       mainAxisSize: MainAxisSize.max,
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //       children: const [
            //         //1. Role User (member, sponsor, admin)
            //         CardMemberStatus(
            //           title: "Member",
            //           status: true,
            //         ),
            //         CardMemberStatus(
            //           title: "ยืนยันตัวตน",
            //           status: false,
            //         ),
            //         CardMemberStatus(
            //           title: "Wallet Conent",
            //           status: false,
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            const SizedBox(height: 20.0),
            Text("เมนูเพิ่มเติม", style: Roboto16_B_black),
            const SizedBox(height: 10.0),

            //TODO 5. เมนูเพิ่มเติม
            _buidMenulist(
              context,
              const FaIcon(Icons.person, size: 30, color: Colors.black),
              "รายละเอียโปรไฟล์",
              () {},
            ),
            const SizedBox(height: 10.0),

            _buidMenulist(
              context,
              const FaIcon(Icons.history, size: 30, color: Colors.black),
              "ประวัติการใช้งาน",
              () {},
            ),
            const SizedBox(height: 10.0),

            _buidMenulist(
              context,
              const FaIcon(Icons.swap_horiz, size: 30, color: Colors.black),
              "ประวัติการแลกของรางวัล",
              () {},
            ),
          ],
        ),
      ),
    );
  }
}

//=====================================================================================================
//TODO : เช็คค่าจากการกดเมนู
void onSelectedMenu(BuildContext context, int item) {
  switch (item) {
    case 0:
      print('Clicked Edit');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Admin_MemberEdit()));
      break;
    case 1:
      print('Clicked Delete');
      break;
  }
}

//TODO : สร้างเมนูเพิ่มเติม
Widget _buidMenulist(BuildContext context, FaIcon iconEZ, String title,
    GestureTapCallback press) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.9,
    height: 40,
    decoration: BoxDecoration(
      color: const Color(0xFFEEEEEE),
      border: Border.all(color: const Color(0xFF727272), width: 1),
    ),
    child: ListTile(
      leading: iconEZ,
      title: Text(title, style: Roboto14_B_black),
      trailing: const Icon(Icons.arrow_forward_ios, size: 20),
      dense: true,
      visualDensity: const VisualDensity(vertical: -3),
      onTap: press,
    ),
  );
}
