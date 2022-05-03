import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:recycle_plus/models/user_model.dart';
import 'package:recycle_plus/screens/_Admin/tabbar_control.dart';
import 'package:recycle_plus/screens/_NoLogin/tabbar_control.dart';
import 'package:recycle_plus/service/database.dart';

class LoginSuccess extends StatefulWidget {
  //Location page
  static String routeName = "/LoginSuccess";

  @override
  State<LoginSuccess> createState() => _LoginSuccessState();
}

class _LoginSuccessState extends State<LoginSuccess> {
  //key scaffold
  final scaffoldKey = GlobalKey<ScaffoldState>();
  //เชื่อมต่อ firebase datastore
  DatabaseEZ db = DatabaseEZ.instance;

  var role;

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
    return Scaffold(
      //TODO 1. Appbar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        leading: const SizedBox(),
        flexibleSpace: Align(
          alignment: const AlignmentDirectional(0, 0.55),
          child: Text(
            "Login Success",
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
                  padding: const EdgeInsets.only(top: 100),
                  child: Image.asset(
                    "assets/image/success.png",
                    fit: BoxFit.cover,
                  ),
                ),

                //TODO 3. Text Login Success
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Text(
                    "Login Success",
                    style: Russo26_gray,
                  ),
                ),
                const SizedBox(height: 50.0),

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
                        if (snapshotEZ.hasData) {
                          //ลอง print ดูสถานะข้อมูลเฉยๆ
                          print("snapshotEZ.hasData = ${snapshotEZ.hasData}");
                          print("snapshotEZ.connectionState == Connect.done");

                          if (snapshotEZ.connectionState ==
                              ConnectionState.done) {
                            //TODO : data = เอกสารข้อมูลจาก state, col_users
                            Map<String, dynamic> data =
                                snapshotEZ.data!.data() as Map<String, dynamic>;

                            //TODO : กระทำกับฐานข้อมูลตรงนี้เด้อ
                            if (data['role'] != null) {
                              //TODO 5. Button Check role
                              return ElevatedButton(
                                child: Text(
                                  "Back to Home",
                                  style: Roboto20_B_white,
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: const Color(0xFF00883C),
                                  fixedSize: const Size(160, 45),
                                  elevation: 2.0, //เงา
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                //เมื่อกดปุ่มนี้แล้วทำอะไรต่อ
                                onPressed: () {
                                  if (data['role'] == "member" ||
                                      data['role'] == "sponsor") {
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                            Member_TabbarHome.routeName,
                                            (route) => false);
                                  } else if (data['role'] == "admin") {
                                    Navigator.pushNamed(
                                        context, Admin_TabbarHome.routeName);
                                  } else {
                                    print("button | Something is wrong!");
                                  }
                                },
                              );
                            }
                          }
                        }
                        return const Text('กำลังโหลด..');
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
