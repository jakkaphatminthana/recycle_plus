import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recycle_plus/models/user_model.dart';
import 'package:recycle_plus/screens/_Admin/tabbar_control.dart';
import 'package:recycle_plus/screens/login/body_login.dart';
import 'package:recycle_plus/service/database.dart';

import '../_User/tabbar_control.dart';

class WelcomeScreen extends StatefulWidget {
  //Location page
  static String routeName = "/Welcome Back";

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  //เชื่อมต่อ firebase datastore
  DatabaseEZ db = DatabaseEZ.instance;
  User? user = FirebaseAuth.instance.currentUser;
  Timer? _timer;
  var value_role;
  String status_load = 'โปรดรอกำลังเปลี่ยนเส้นทาง...';

  //TODO 1: ไปหน้าอื่นโดยที่ delay เวลาไว้
  void gotoNextPage(routeName) async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.pushReplacementNamed(context, routeName);
  }

  //TODO 2: Get User Database
  Future<void> getUserDatabase(id) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .snapshots()
        .listen((event) {
      setState(() {
        value_role = event.get('role');
      });
    });
  }

  //TODO : First call whenever run
  @override
  void initState() {
    super.initState();
    getUserDatabase(user?.uid);
    _timer = Timer(const Duration(milliseconds: 2000), () {
      print('user role: ${value_role}');
      print('user id: ${user!.uid}');

      if (value_role == "Member") {
        gotoNextPage(Member_TabbarHome.routeName);
      } else if (value_role == "Admin") {
        gotoNextPage(Admin_TabbarHome.routeName);
      } else if (value_role == "Sponsor") {
        gotoNextPage(Member_TabbarHome.routeName);
      } else {
        setState(() {
          status_load = 'เกิดข้อผิดพลาด โปรดลองใหม่อีกครั้ง';
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//==============================================================================================================
    //TODO : ทำให้ไม่สามารถกด back page ได้
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("The System Back Button is Deactivated")),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFe6eff1),
        //TODO 1. Appbar
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          elevation: 0.0,
          leading: const SizedBox(),
          flexibleSpace: Align(
            alignment: const AlignmentDirectional(0, 0.55),
            child: Text(
              "Welcome Back",
              style: Roboto18_gray,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Align(
              alignment: const AlignmentDirectional(0, 0),
              child: Column(
                children: [
                  //TODO 2. Image Success
                  Padding(
                    padding: const EdgeInsets.only(top: 70),
                    child: Image.asset(
                      "assets/image/giphy (1).gif",
                      fit: BoxFit.cover,
                    ),
                  ),

                  //TODO 3. Text Login Success
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Text(
                      "ยินดีต้อนรับกลับมา",
                      style: Roboto22_R_black,
                    ),
                  ),
                  const SizedBox(height: 10.0),

                  //TODO 4. Status Loadding
                  (value_role == null)
                      ? const Text('Something is worng')
                      : Text(status_load),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
