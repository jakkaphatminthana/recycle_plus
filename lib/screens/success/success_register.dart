import 'dart:async';

import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/login/body_login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterSuccess extends StatefulWidget {
  //Location page
  static String routeName = "/RegisterSuccess";

  @override
  State<RegisterSuccess> createState() => _RegisterSuccessState();
}

class _RegisterSuccessState extends State<RegisterSuccess> {
  //เรียกใช้ Firebase Authentication
  final _auth = FirebaseAuth.instance;

  User? user = FirebaseAuth.instance.currentUser;
  //ตัวจับเวลา
  Timer? timer;

  // //TODO : initState = ทำการเรียกใช้ทุกครั้ง เมื่อเข้ามาหน้านี้
  // @override
  // void initState() {
  //   super.initState();

  //   if (user != null) {
  //     timer = Timer.periodic(
  //       const Duration(seconds: 3),
  //       (_) => signoutEZ(),
  //     );
  //   }
  // }

  // //TODO : dispose = เมื่อสิ้นสุด initState แล้วให้เรียกใช้
  // @override
  // void dispose() {
  //   timer?.cancel();
  //   super.dispose();
  // }

  //TODO : ทำให้ออกจากระบบก่อน เพื่อให้ล็อคอินใหม่
  Future signoutEZ() async {
    await _auth.signOut();
    //รีเฟรชสถานะผู้ใช้
    //await _auth.currentUser!.reload();
    //timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    //================================================================================================================
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
            "Register Success",
            style: Roboto18_gray,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Align(
            alignment: const AlignmentDirectional(0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                //TODO 2. Image Success
                Padding(
                  padding: EdgeInsets.only(top: 100),
                  child: Image.asset(
                    "assets/image/success.png",
                    fit: BoxFit.cover,
                  ),
                ),

                //TODO 3. Text Success
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Text(
                    "Register Success",
                    style: Russo26_gray,
                  ),
                ),
                const SizedBox(height: 50.0),

                //TODO 4. Button
                ElevatedButton(
                    child: Text("Go to Login", style: Roboto20_B_white),
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF00883C),
                      fixedSize: const Size(160, 45),
                      elevation: 2.0, //เงา
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                    ),
                    onPressed: () async {
                      await signoutEZ();
                      Navigator.pushNamed(context, LoginScreen.routeName);
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
