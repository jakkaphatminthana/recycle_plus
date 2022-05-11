import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recycle_plus/components/appbar_title.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/models/user_model.dart';
import 'package:recycle_plus/screens/_Admin/member/member_detail/member_detail.dart';
import 'package:recycle_plus/screens/_Admin/member/member_search.dart';
import 'package:recycle_plus/screens/_Admin/member/textfieldSearch.dart';
import 'package:recycle_plus/screens/_Admin/tabbar_control.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:recycle_plus/service/database.dart';

//เรียก firebase database
DatabaseEZ db = DatabaseEZ.instance;

class Admin_MemberScreen extends StatefulWidget {
  //Location page
  static String routeName = "/Admin_MemberControl";

  @override
  State<Admin_MemberScreen> createState() => _Admin_MemberScreenState();
}

class _Admin_MemberScreenState extends State<Admin_MemberScreen> {
  //เก็บและเรียกข้อมูลจาก firebase collecttion ("users")
  Stream<List<UserModelV2>> user_list = db.getUserData();

  //customIcon = Set icon Search
  //customAppbar = Widget Appbar title
  //backIcon = เปิดปิดฟังก์ชั่นกดกลับ
  Icon customIcon = const Icon(Icons.search);
  Widget customAppbarTitle = const AppbarTitle();
  bool backIcon = true;

  @override
  Widget build(BuildContext context) {
//==============================================================================================
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
          IconButton(
            icon: customIcon,
            //กดปุ่มค้นหาแล้วทำอะไรต่อ....
            onPressed: () {
              //Navigator.pushNamed(context, Admin_MemberSearch.routeName);
              showSearch(context: context, delegate: Member_Search());
            },
          ),
        ],
      ),
      //===============================================================================================
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
              child: StreamBuilder<List<UserModelV2>>(
                stream: user_list,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("something is wrong! ${snapshot.error}");
                  } else if (snapshot.hasData) {
                    final users = snapshot.data!;

                    //Show Data ทั้งหมดออกมา
                    return ListView(
                      children: users.map(buildMemberCon).toList(),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

//=======================================================================================
//TODO : Widget Member Container
  Widget buildMemberCon(UserModelV2 users) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        width: double.infinity,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          //เงาขอบๆ
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 4,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        //เนื้อหาในกล่องนี้ จะแสดงอะไร
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, Admin_MemberDetail.routeName);
          },
          child: ListTile(
            //TODO : Profile Image
            leading: Container(
              width: 45,
              height: 45,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 1),
              ),
              child: Image.network(users.image),
            ),
            //TODO : Email User
            title: Text(users.email, style: Roboto16_B_black),
            //TODO : Role User
            subtitle: Text("Member", style: Roboto12_black),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF303030),
              size: 20,
            ),
            dense: false,
          ),
        ),
      ),
    );
  }
}
