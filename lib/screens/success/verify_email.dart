import 'dart:async';

import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recycle_plus/screens/login/body_login.dart';
import 'package:recycle_plus/screens/register/body_register.dart';
import 'package:recycle_plus/screens/success/success_register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recycle_plus/models/user_model.dart';
import 'package:recycle_plus/service/auth.dart';

class VerifyEmail extends StatefulWidget {
  //ก่อนจะเรียกหน้านี้จำเป็นต้องมี paramiter data
  const VerifyEmail({required this.name});
  final name; //data Querysnapshot

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  //เรียกใช้ FirebaseAuth
  final auth = FirebaseAuth.instance;
  //เรียกใช้ Package Auth จาก auth.dart
  final AuthService auth_package = AuthService();
  //ตัวแปรที่ใช้ check status KYC email
  bool isEmailVerify = false;
  //ตัวจับเวลา
  Timer? timer;
  //User Current
  User? user = FirebaseAuth.instance.currentUser;

  //TODO : initState = ทำการเรียกใช้ทุกครั้ง เมื่อเข้ามาหน้านี้
  @override
  void initState() {
    super.initState();
    //Status KVC Email
    isEmailVerify = auth.currentUser!.emailVerified;

    //ถ้ายังไม่ได้ยืนยันอีเมล
    if (isEmailVerify != true) {
      //ส่งเมลยืนยันไปให้
      auth_package.sendVerifyEmail();
      //ทุกๆ 3 วินาทีจะทำการเช็คสถานะ
      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  //TODO : dispose = เมื่อสิ้นสุด initState แล้วให้เรียกใช้
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  //TODO : function ตรวจสอบสถานะการยืนยันอีเมล
  Future checkEmailVerified() async {
    //รีเฟรชสถานะผู้ใช้
    await auth.currentUser!.reload();

    setState(() {
      isEmailVerify = auth.currentUser!.emailVerified;
    });

    //หากยืนยันแล้วให้ปิด timer
    if (isEmailVerify == true) {
      timer?.cancel();

      //TODO : ทำการสร้าง database profile
      //กรณีไม่มี name ส่งมาให้
      if (widget.name == null) {
        final UserMail = user?.email.toString();
        List<String>? splited = UserMail?.split("@");
        final data_map = splited?.asMap();
        final nameEmail = data_map![0];

        await auth_package.createProfile(nameEmail!);
      } else {
        await auth_package.createProfile(widget.name!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //==========================================================================================================
    //TODO : ทำให้ไม่สามารถกด back page ได้
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("The System Back Button is Deactivated")),
        );
        return false;
      },
      //TODO : ถ้ามีสถานะการยืนยันแล้วจะเด้งไปหน้า เสร็จสิ้นเอง auto
      child: (isEmailVerify == true)
          ? RegisterSuccess()
          : Scaffold(
              //TODO 1. Appbar
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                elevation: 0.0,
                leading: const SizedBox(),
                flexibleSpace: Align(
                  alignment: const AlignmentDirectional(0, 0.55),
                  child: Text(
                    "Verify email",
                    style: Roboto18_gray,
                  ),
                ),
              ),
              //------------------------------------------------------------------------------------
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Align(
                    alignment: const AlignmentDirectional(0, 0),
                    child: Column(
                      children: [
                        //TODO 2. Image Main
                        Padding(
                          padding: const EdgeInsets.only(top: 100),
                          child: Image.asset(
                            "assets/image/verifyEmail.png",
                            width: 350,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 20.0),

                        //TODO 3. Title text
                        Text("โปรดตรวจสอบที่ ${auth.currentUser?.email}",
                            style: Roboto14_black),
                        Text(
                            "เราได้ส่งลิงก์ไปยืนยันตัวให้ไปให้อีเมลของท่านแล้ว.",
                            style: Roboto14_black),
                        const SizedBox(height: 30.0),

                        //TODO 4.Button Send
                        ElevatedButton.icon(
                          icon: const FaIcon(
                            Icons.email,
                            size: 25,
                          ),
                          label:
                              Text("ส่งใหม่อีกครั้ง", style: Roboto16_B_white),
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(300, 45),
                            primary: const Color(0xFF389B61),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          onPressed: () {
                            //auth_package.sendVerifyEmail();

                            final test = auth.currentUser!.emailVerified;
                            print("emailVerifie = $test");

                            final UserMail = user?.email.toString();
                            List<String>? splited = UserMail?.split("@");
                            final data_map = splited?.asMap();
                            final nameEmail = data_map![0];

                            print("nameField= $nameEmail");
                            print("nameReal = ${widget.name}");
                            print("user current = $user");
                          },
                        ),
                        const SizedBox(height: 20.0),

                        //TODO 5. Cancle text
                        GestureDetector(
                          child: Text("ยกเลิก", style: Roboto18_B_green),
                          onTap: () async {
                            await FirebaseAuth.instance.signOut();
                            await Navigator.pushReplacementNamed(
                                context, LoginScreen.routeName);
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
