//หน้ารันสั่งแอป ให้ทำงาน
import 'package:flutter/material.dart';
import 'package:recycle_plus/routes.dart';
import 'package:recycle_plus/screens/ErrorScreen.dart';
import 'package:recycle_plus/screens/_Admin/setting/setting.dart';
import 'package:recycle_plus/screens/_Admin/setting/sponsor%20logo/sponsor_logo.dart';
import 'package:recycle_plus/screens/_Admin/tabbar_control.dart';
import 'package:recycle_plus/screens/_Admin/trash/trash.dart';
import 'package:recycle_plus/screens/_NoLogin/profile/profile.dart';
import 'package:recycle_plus/screens/_NoLogin/tabbar_control.dart';
import 'package:recycle_plus/screens/login/body_login.dart';
import 'package:recycle_plus/screens/start/start.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:recycle_plus/screens/success/success_login.dart';
import 'package:recycle_plus/screens/success/verify_email.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/user_model.dart';
import 'screens/_NoLogin/home/user_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  //User now
  User? user = FirebaseAuth.instance.currentUser;
  //อ้างอิง collection ของ user
  CollectionReference col_users =
      FirebaseFirestore.instance.collection("users");
  //ดึงเอกสาร id ของ user ทั้งหมด
  Stream<List<UserModel>> status = db.getStateUser();

//===================================================================================================
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recycle +',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //initialRoute: Member_ProfileScreen.routeName,
      routes: routes,

      //TODO : ใช้ดักทางสำหรับ user ไม่มีบัญชีและไม่ยืนยันบัญชี
      home: Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            try {
              if (snapshot.hasData && user?.emailVerified == true) {
                // StreamBuilder(
                //   stream: status,
                //   builder: (context, snapshot) {
                //     return FutureBuilder<DocumentSnapshot>(
                //       future: col_users.doc("$user?.uid").get(),
                //       builder: (context, snapshotEZ) {
                //         if (snapshot.hasError) {
                //           return const Text("something is wrong!");
                //         }
                //         if (snapshotEZ.hasData) {
                //           return LoginSuccess();
                //         } else {
                //           return LoginScreen();
                //         }
                //       },
                //     );
                //   },
                // );
                return LoginSuccess();
              } else if (snapshot.hasData) {
                return VerifyEmail(name: null);
              } else {
                return StartScreen();
              }
            } catch (e) {
              return ErrorScreen(err: e);
            }
          },
        ),
      ),
    );
  }
}
