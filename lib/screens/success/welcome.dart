import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
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
  //key scaffold
  final scaffoldKey = GlobalKey<ScaffoldState>();
  //เชื่อมต่อ firebase datastore
  DatabaseEZ db = DatabaseEZ.instance;

  //ไปหน้าอื่นโดยที่ delay เวลาไว้
  void gotoNextPage(routeName) async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.pushReplacementNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    //ดึงเอกสาร id ของ user ทั้งหมด
    Stream<List<UserModel>> status = db.getStateUser();
    //อ้างอิง collection ของ user
    CollectionReference col_users =
        FirebaseFirestore.instance.collection("users");

    //เรียกใช้ Firebase Authentication
    final _auth = firebase_auth.FirebaseAuth.instance;
    //กำหนดตัวแปรที่บอกว่า ตอนนี้ใครกำลังเข้าใช้งานอยู่
    firebase_auth.User? _user;
    _user = _auth.currentUser;

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

                  //TODO 4. Firebase Check Role User -------------------------------
                  StreamBuilder(
                    stream: status,
                    builder: (context, snapshot) {
                      return FutureBuilder<DocumentSnapshot>(
                        future: col_users.doc("${_user?.uid}").get(),
                        builder: (context, snapshotEZ) {
                          if (snapshot.hasError) {
                            return const Text("Something is wrong!");
                          }
                          if (snapshotEZ.hasError) {
                            return const Text("Something is wrong!");
                          }
                          if (snapshotEZ.hasData) {
                            //ลอง print ดูสถานะข้อมูลเฉยๆ
                            print("snapshotEZ.hasData = ${snapshotEZ.hasData}");
                            print("snapshotEZ.connectionState == Connect.done");

                            if (snapshotEZ.connectionState ==
                                ConnectionState.done) {
                              try {
                                //TODO : data = เอกสารข้อมูลจาก state, col_users
                                Map<String, dynamic> data = snapshotEZ.data!
                                    .data() as Map<String, dynamic>;

                                //TODO : กระทำกับฐานข้อมูลตรงนี้เด้อ
                                if (data['role'] != null) {
                                  //TODO 5. Button Check role
                                  if (data['role'] == "Member" ||
                                      data['role'] == "Sponsor") {
                                    gotoNextPage(Member_TabbarHome.routeName);
                                  } else if (data['role'] == "Admin") {
                                    gotoNextPage(Admin_TabbarHome.routeName);
                                  } else {
                                    //ERROR ถ้าเกิดไม่มีข้อมูล role
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Something is worng, Please try again.",
                                          style: Roboto14_B_black,
                                        ),
                                        const SizedBox(height: 30.0),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, LoginScreen.routeName);
                                          },
                                          child: Text(
                                            "ลองใหม่อีกครั้ง",
                                            style: Roboto14_B_yellow,
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                }
                                //ERROR ถ้าเกิดไม่มีข้อมูล role
                              } catch (e) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Something is worng, Please try again.",
                                      style: Roboto14_B_black,
                                    ),
                                    const SizedBox(height: 30.0),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, LoginScreen.routeName);
                                      },
                                      child: Text(
                                        "ลองใหม่อีกครั้ง",
                                        style: Roboto16_B_yellow,
                                      ),
                                    ),
                                  ],
                                );
                              }
                            }
                          }
                          return const Text('โปรดรอกำลังเปลี่ยนเส้นทาง...');
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
