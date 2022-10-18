import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_Admin/setting/list%20menu.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recycle_plus/screens/_Admin/setting/sponsor%20logo/sponsor_logo.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:recycle_plus/screens/login/body_login.dart';

class Admin_SettingMore extends StatelessWidget {
  //Location page
  static String routeName = "/Admin_SettingMore";

  @override
  Widget build(BuildContext context) {
    //เรียกใช้ Firebase Authentication
    final _auth = firebase_auth.FirebaseAuth.instance;
    //กำหนดตัวแปรที่บอกว่า ตอนนี้ใครกำลังเข้าใช้งานอยู่
    firebase_auth.User? _user;
    _user = _auth.currentUser;

    //=======================================================================================
    return Scaffold(
      //TODO 1. Appbar Header
      appBar: AppBar(
        backgroundColor: const Color(0xFF00883C),
        centerTitle: true,
        title: Text("Setting Menu", style: Roboto18_B_white),
        elevation: 2.0,
      ),
      //---------------------------------------------------------------------------------
      body: Column(
        children: [
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //TODO : Menu Sponsor Header
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, bottom: 5.0),
                  child: Text("Sponsor", style: Roboto16_black),
                ),

                //TODO : Add Logo Sponsor
                ListMenuSetting(
                  title: "โลโก้สปอนเซอร์",
                  iconEZ: const FaIcon(
                    Icons.add_to_photos_outlined,
                    size: 32,
                    color: Colors.black,
                  ),
                  press: () {
                    // Navigator.pushNamed(context, Admin_LogoSponsor.routeName);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 30.0),

          //TODO : ออกจากระบบ
          ElevatedButton(
            child: Text(
              "ออกจากระบบ",
              style: Roboto20_B_white,
            ),
            style: ElevatedButton.styleFrom(
              primary: const Color(0xFFff5963),
              fixedSize: const Size(180, 45),
              elevation: 2.0, //เงา
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
            //เมื่อกดปุ่มนี้แล้วทำอะไรต่อ
            onPressed: () {
              _auth
                  .signOut()
                  .then(
                    (value) => Navigator.popAndPushNamed(
                      context,
                      LoginScreen.routeName,
                    ),
                  )
                  .catchError((err) => print("SignOut Faild : $err"));
            },
          ),
        ],
      ),
    );
  }
}
