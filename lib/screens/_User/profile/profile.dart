import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recycle_plus/components/wallet/wallet_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:recycle_plus/screens/_User/profile/address/profile_address.dart';
import 'package:recycle_plus/screens/_User/profile/edit_profile/profile_edit.dart';
import 'package:recycle_plus/screens/_User/profile/order/order.dart';
import 'package:recycle_plus/screens/login/body_login.dart';
import 'package:recycle_plus/service/database.dart';

import 'card_menu.dart';

class Member_ProfileScreen extends StatefulWidget {
  //Location Page
  static String routeName = "/MyProfile";

  @override
  State<Member_ProfileScreen> createState() => _Member_ProfileScreenState();
}

class _Member_ProfileScreenState extends State<Member_ProfileScreen> {
  //เรียกใช้ Firebase Authentication
  final _auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  DatabaseEZ db = DatabaseEZ.instance;
  dynamic dataEZ;

  var exponent = 1.15;
  var baseXP = 45;
  var value_level;
  var value_exp;
  var value_exp_next;
  var value_exp_remain;
  var value_exp_percent;
  Timer? _timer;
  bool isLoading = false;
  bool openProfile = false;
  int max_level = 100;

  var phone;
  var gender;
  var nameEZ;
  var emailEZ;

  //TODO : Get Level & Exp
  Future<void> getUserDatabase(id) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .snapshots()
        .listen((event) {
      setState(() {
        value_level = event.get('level');
        value_exp = event.get('exp');
        phone = event.get('phone');
        gender = event.get('gender');
        nameEZ = event.get('name');
        emailEZ = event.get('email');
      });
    });
  }

  //TODO : Level Calculator System
  Future<void> levelCalculator(level, exp) async {
    var level_next = level + 1;
    var exponent = 1.15;
    var baseXP = 45;
    var exp_next_level = (baseXP * (pow(level_next, exponent))).round();
    bool isLevelUP = (exp >= exp_next_level);
    var exp_remain = (isLevelUP) ? exp - exp_next_level : exp_next_level - exp;

    // print("Before--------------------");
    // print('you level: $value_level');
    // print('Now: level $value_level -> $level_next');
    // print('EXP now: $exp');
    // print('EXP to next level:  $exp_next_level');
    // print('EXP enough: $isLevelUP');
    // print('EXP remain: $exp_remain');

    //ถ้ามี exp ที่เพียงพอและเวลไม่เกิน 100
    if (isLevelUP == true && level_next <= 100) {
      isLoading = true;
      value_level = value_level + 1;
      value_exp = exp_remain;
      value_exp_next = (baseXP * (pow(value_level + 2, exponent))).round();
      value_exp_remain = value_exp_next - value_exp;

      //กรณีที่มีค่า exp แบบที่สามารถ level up ได้หลายรอบ
      while (value_exp >= value_exp_next && (value_level + 1) <= 100) {
        value_level = value_level + 1;
        value_exp = value_exp - value_exp_next;
        value_exp_next = (baseXP * (pow(value_level + 2, exponent))).round();
        value_exp_remain = value_exp_next - value_exp;
        // print('loop start <<<<<');
        // print("level = $value_level");
        // print("exp = $value_exp");
        // print('exp next = $value_exp_next');
        // print('exp remain = $value_exp_remain');
        // print('loop stop <<<<<<');
      }
      isLevelUP = (value_exp >= exp_next_level);
      setState(() {});
      // print("After--------------------");
      // print('you level: $value_level');
      // print('Now: level $value_level -> ${value_level + 1}');
      // print('EXP now: $value_exp');
      // print('EXP to next level:  $value_exp_next');
      // print('EXP enough: $isLevelUP');
      // print('EXP remain: $value_exp_remain');

      //update to firebase
      await db
          .updateLevel(
            ID_user: user!.uid,
            newLevel: value_level,
            newExp: value_exp,
          )
          .then((value) => print("level update success"))
          .catchError((err) => print('level error: $err'));
    }
    isLoading = false;
    print('isLoading == $isLoading');
    _timer?.cancel();
  }

  //TODO : First call whenever run
  @override
  void initState() {
    super.initState();

    getUserDatabase(user?.uid);
    _timer = Timer(const Duration(milliseconds: 250), () {
      levelCalculator(value_level, value_exp);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> _collection = FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .snapshots();

    //=======================================================================================================================
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Member_ProfileEdit(data: dataEZ),
                ),
              );
            },
          ),
        ],
        elevation: 2.0,
      ),
      //------------------------------------------------------------------------
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //TODO 1. Firebase Product Recoment ----------------------------------
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: _collection.asBroadcastStream(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                } else {
                  //TODO 1.1: Fetch Database Query is here -----------<<<
                  dynamic data = snapshot.data;
                  final verify = data!.get('verify');
                  final image = data!.get('image');
                  final name = data!.get('name');
                  final email = data!.get('email');
                  final expFB = data!.get('exp');
                  final levelFB = data!.get('level');

                  var exp_next =
                      (baseXP * (pow(levelFB + 1, exponent))).round();
                  var exp_remain = exp_next - expFB;
                  var exp_percent = expFB / exp_next;
                  dataEZ = data;

                  return ListView(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //TODO 2. Verify Button
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                            child: ElevatedButton.icon(
                              icon: const FaIcon(FontAwesomeIcons.shieldAlt,
                                  size: 14),
                              label: Text(
                                  (verify == true) ? "Verified" : "Not Verify",
                                  style: Roboto14_B_white),
                              style: ElevatedButton.styleFrom(
                                primary: (verify == true)
                                    ? const Color(0xFF00883C)
                                    : const Color(0xFFE45050),
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
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle),
                                    child: Image.network(image),
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
                                    child: (isLoading == true)
                                        ? const SpinKitThreeBounce(
                                            color: Colors.black,
                                            size: 15.0,
                                          )
                                        : Text(
                                            "Lv. $levelFB",
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
                          Center(child: Text(name, style: Roboto20_B_green)),
                          const SizedBox(height: 5.0),
                          Center(child: Text(email, style: Roboto16_black)),
                          const SizedBox(height: 20.0),

                          //TODO 6. Wallet Widget
                          Center(
                            child:
                                Wallet_card(colorEZ: const Color(0xFFEEEEEE)),
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
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 15, 10, 0),
                                  child: Stack(
                                    children: [
                                      //TODO 8. Level Bar
                                      //Black Level Bar
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF6F6F6),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                            width: 1,
                                          ),
                                        ),
                                      ),

                                      //Green Level Bar
                                      Container(
                                        width: (exp_percent == null)
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05
                                            : MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                exp_percent,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: const Color(0xCD00883C),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: (value_level == max_level)
                                            ? Center(
                                                child: Text('Maximum',
                                                    style: Roboto12_B_white),
                                              )
                                            : Container(),
                                      ),
                                    ],
                                  ),
                                ),

                                //TODO 9. EXP Texting
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 5, 15, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/image/exp2.png',
                                            width: 20,
                                            height: 20,
                                            fit: BoxFit.cover,
                                          ),
                                          const SizedBox(width: 5.0),
                                          Text(
                                            (value_level == max_level)
                                                ? "EXP: $exp_next/$exp_next"
                                                : "EXP: $expFB/$exp_next",
                                            style: Roboto14_black,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        (value_level == max_level)
                                            ? "you have $value_exp XP."
                                            : "$exp_remain XP. to level up",
                                        style: Roboto14_black,
                                      ),
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
                                  padding:
                                      const EdgeInsets.only(top: 5, left: 10),
                                  child: Text("การจัดการบัญชี",
                                      style: Roboto14_B_black),
                                ),

                                //TODO 11. Menu Card
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 15, 10, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Card_menuIcon(
                                        icon: FaIcon(
                                          (openProfile)
                                              ? Icons.person_remove
                                              : Icons.person,
                                          color: const Color(0xFF00883C),
                                          size: 35,
                                        ),
                                        title: "รายละเอียด",
                                        press: () {
                                          setState(() {
                                            if (openProfile == false) {
                                              openProfile = true;
                                            } else {
                                              openProfile = false;
                                            }
                                          });
                                        },
                                      ),
                                      Card_menuIcon(
                                        icon: const FaIcon(
                                          Icons.history_sharp,
                                          color: Color(0xFF00883C),
                                          size: 35,
                                        ),
                                        title: "ออเดอร์ฉัน",
                                        press: () {
                                          Navigator.pushNamed(
                                            context,
                                            Member_orderTrading.routeName,
                                          );
                                        },
                                      ),
                                      Card_menuIcon(
                                        icon: const FaIcon(
                                          Icons.location_pin,
                                          color: Color(0xFF00883C),
                                          size: 35,
                                        ),
                                        title: "จัดการที่อยู่",
                                        press: () {
                                          Navigator.pushNamed(
                                            context,
                                            Member_ProfileAddress.routeName,
                                          );
                                        },
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
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          //TODO 12. Expened Profile
                          (openProfile == true)
                              ? _build_profileDetail(
                                  nameEZ: nameEZ,
                                  emailEZ: emailEZ,
                                  phoneEZ: phone,
                                  genderEZ: gender,
                                )
                              : Container(),

                          const SizedBox(height: 25.0),

                          //TODO 13. SignOut Button
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
                                    .catchError(
                                        (err) => print("SignOut Faild : $err"));
                              },
                            ),
                          ),
                          const SizedBox(height: 30.0),
                        ],
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  //================================================================================================================
  //TODO : Widget Profile Detail
  Widget _build_profileDetail({
    required phoneEZ,
    required genderEZ,
    required nameEZ,
    required emailEZ,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //1. Header Detail Profile
            Text(
              "รายละเอียดของฉัน",
              style: Roboto14_B_black,
            ),
            const SizedBox(height: 10.0),

            //2. detail profile
            listUserDetail(
              iconEZ: Icons.person,
              title: "ชื่อผู้ใช้: ",
              value: nameEZ,
            ),
            listUserDetail(
              iconEZ: Icons.email_outlined,
              title: "อีเมล: ",
              value: emailEZ,
            ),
            listUserDetail(
              iconEZ: FontAwesomeIcons.starOfLife,
              title: "เพศ: ",
              value: genderEZ,
            ),
            listUserDetail(
              iconEZ: Icons.call,
              title: "เบอร์โทร: ",
              value: phoneEZ,
            ),
            const SizedBox(height: 15.0),
            const Divider(
              height: 1.0,
              thickness: 2.0,
              color: Color(0xFFC3C3C3),
            ),
          ],
        ),
      ),
    );
  }

  Widget listUserDetail({iconEZ, title, value}) {
    return Row(
      children: [
        FaIcon(
          iconEZ,
          color: Colors.black,
          size: 15,
        ),
        const SizedBox(width: 5.0),
        Text(title, style: Roboto14_B_green),
        const SizedBox(width: 5.0),
        Text(
          (value == null) ? "ไม่ได้ระบุ " : value,
          style: Roboto14_black,
        ),
      ],
    );
  }
}
