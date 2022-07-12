import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recycle_plus/components/wallet_card.dart';
import 'package:recycle_plus/screens/_NoLogin/profile/card_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:recycle_plus/screens/login/body_login.dart';

class Member_ProfileScreen extends StatefulWidget {
  //Location Page
  static String routeName = "/MyProfile";

  @override
  State<Member_ProfileScreen> createState() => _Member_ProfileScreenState();
}

class _Member_ProfileScreenState extends State<Member_ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    //เรียกใช้ Firebase Authentication
    final _auth = firebase_auth.FirebaseAuth.instance;
    //กำหนดตัวแปรที่บอกว่า ตอนนี้ใครกำลังเข้าใช้งานอยู่
    firebase_auth.User? _user;
    _user = _auth.currentUser;

    //==============================================================================================
    return Scaffold(
      //TODO 1. Appbar App
      appBar: AppBar(
        backgroundColor: const Color(0xFF00883C),
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text("My Profile", style: Roboto18_B_white),
        //Icon Menu bar
        actions: [
          IconButton(
            icon: const FaIcon(
              Icons.mode_edit,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {},
          ),
        ],
        elevation: 2.0,
      ),
      //----------------------------------------------------------------------------------------------
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //TODO 2. Verify Button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                    child: ElevatedButton.icon(
                      icon: const FaIcon(FontAwesomeIcons.shieldAlt, size: 14),
                      label: Text("Not Verify", style: Roboto14_B_white),
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFFE45050),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(height: 15.0),

                  //TODO 3. Image Profile
                  Stack(
                    children: [
                      //TODO : Container Image
                      Align(
                        alignment: const AlignmentDirectional(0, 0),
                        //Container
                        child: Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEEEEE),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFB3B3B3),
                              width: 5,
                            ),
                          ),
                          //Image Profile
                          child: Container(
                            width: 130,
                            height: 130,
                            clipBehavior: Clip.antiAlias,
                            decoration:
                                const BoxDecoration(shape: BoxShape.circle),
                            child: Image.network(
                              'https://picsum.photos/seed/840/600',
                            ),
                          ),
                        ),
                      ),

                      //TODO 4. Level in Profile
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 105.0),
                          child: Container(
                            width: 70,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: const Color(0xFFB3B3B3),
                                width: 5,
                              ),
                            ),
                            child: Text(
                              "Lv. 14",
                              style: Roboto16_B_black,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),

                  //TODO 5. Name and Email
                  Center(
                    child: Text("Joson Sibling", style: Roboto20_B_green),
                  ),
                  const SizedBox(height: 5.0),
                  Center(
                    child: Text("Joson@gmail.com", style: Roboto16_black),
                  ),
                  const SizedBox(height: 20.0),

                  //TODO 6. Wallet Widget
                  const Center(
                    child: Wallet_card(colorEZ: Color(0xFFEEEEEE)),
                  ),
                  const SizedBox(height: 30.0),

                  //TODO 7. Area Container Menu
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 230,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      border: Border.all(
                        color: const Color(0xFF8D8D8D),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                          child: Stack(
                            children: [
                              //TODO 8. Level Bar
                              //Black Level Bar
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF6F6F6),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    width: 1,
                                  ),
                                ),
                              ),

                              //Green Level Bar
                              Container(
                                width: MediaQuery.of(context).size.width * 0.50,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: const Color(0xCD00883C),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ],
                          ),
                        ),

                        //TODO 9. EXP Texting
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("EXP: 100/200", style: Roboto14_black),
                              Text("100 XP. to level up",
                                  style: Roboto14_black),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        const Divider(
                          height: 1.0,
                          thickness: 2.0,
                          color: Color(0xFFC3C3C3),
                        ),

                        //TODO 10. Menu Manage header
                        Padding(
                          padding: const EdgeInsets.only(top: 5, left: 10),
                          child:
                              Text("การจัดการบัญชี", style: Roboto14_B_black),
                        ),

                        //TODO 11. Menu Card
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Card_menuIcon(
                                icon: const FaIcon(
                                  Icons.location_on,
                                  color: Color(0xFF00883C),
                                  size: 35,
                                ),
                                title: "ที่อยู่จัดส่ง",
                                press: () {},
                              ),
                              Card_menuIcon(
                                icon: const FaIcon(
                                  Icons.history_sharp,
                                  color: Color(0xFF00883C),
                                  size: 35,
                                ),
                                title: "ประวัติธุรกรรม",
                                press: () {},
                              ),
                              Card_menuIcon(
                                icon: const FaIcon(
                                  Icons.report,
                                  color: Color(0xFF00883C),
                                  size: 35,
                                ),
                                title: "รายงาน",
                                press: () {},
                              ),
                              Card_menuIcon(
                                icon: const FaIcon(
                                  FontAwesomeIcons.donate,
                                  color: Color(0xFF00883C),
                                  size: 35,
                                ),
                                title: "สนับสนุนเรา",
                                press: () {},
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30.0),

                  Center(
                    child: ElevatedButton(
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
                  ),
                  const SizedBox(height: 30.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
