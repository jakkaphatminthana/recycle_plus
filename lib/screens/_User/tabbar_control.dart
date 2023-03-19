import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recycle_plus/components/appbar/appbar_title.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/routes.dart';
import 'package:recycle_plus/screens/_User/achievement/achievement.dart';
import 'package:recycle_plus/screens/_User/mission/misson.dart';
import 'package:recycle_plus/screens/_User/test.dart';
import 'package:recycle_plus/screens/login_no/login_no.dart';
import 'package:recycle_plus/screens/scanQR/LDPE/LDPE_detail.dart';
import 'package:recycle_plus/screens/scanQR/PETE/PETE_detail.dart';
import 'package:recycle_plus/screens/scanQR/PP/PP_detail.dart';
import 'package:recycle_plus/screens/scanQR/Qrscan.dart';
import 'package:recycle_plus/screens/scanQR/TEST_before.dart';
import 'package:recycle_plus/screens/scanQR/TEST_trash_reward.dart';
import 'package:recycle_plus/screens/success/verify_email.dart';

import 'exchange/exchange.dart';
import 'home/user_home.dart';
import 'profile/profile.dart';

class Member_TabbarHome extends StatefulWidget {
  int selectPage;
  Member_TabbarHome(this.selectPage, {Key? key}) : super(key: key);

  //Location Page
  static String routeName = "/home";

  @override
  State<Member_TabbarHome> createState() => _Member_TabbarHomeState();
}

class _Member_TabbarHomeState extends State<Member_TabbarHome> {
  User? user = FirebaseAuth.instance.currentUser;

  //TODO 1. Set Tabbar list here
  TabBar get _tabbar {
    return const TabBar(
      labelColor: Colors.white,
      unselectedLabelColor: Color(0xFFDFDFDF),
      indicatorWeight: 4,
      indicatorColor: Colors.white,
      //labelPadding: EdgeInsets.only(top: 10.0),
      tabs: [
        Tab(
          text: 'หน้าแรก',
          icon: FaIcon(FontAwesomeIcons.home, size: 30),
          iconMargin: EdgeInsets.only(top: 10.0),
        ),
        Tab(
          text: 'ภารกิจ',
          icon: FaIcon(FontAwesomeIcons.compass, size: 32),
          iconMargin: EdgeInsets.only(top: 10.0),
        ),
        Tab(
          text: 'ของรางวัล',
          icon: Icon(Icons.swap_horizontal_circle_outlined, size: 35),
          iconMargin: EdgeInsets.only(top: 10.0),
        ),
        Tab(
          text: 'ควาสำเร็จ',
          icon: FaIcon(FontAwesomeIcons.trophy, size: 30),
          iconMargin: EdgeInsets.only(top: 10.0),
        ),
      ],
    );
  }

  Future<void> scanQR() async {
    try {
      FlutterBarcodeScanner.scanBarcode('#2A99CF', 'Cancel', true, ScanMode.QR)
          .then((value) {
        setState(() {
          qrString = value;
        });
        if (qrString == 'Recycle+_PETE') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => PETE_detailWidget()),
            ),
          );
        } else if (qrString == 'Recycle+_LDPE') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => LDPE_detailWidget()),
            ),
          );
        } else if (qrString == 'Recycle+_PP') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => PP_detailWidget()),
            ),
          );
        }
      });
    } catch (e) {
      setState(() {
        qrString = 'unable to read the qr';
      });
    }
  }

//==================================================================================================================
  @override
  Widget build(BuildContext context) {
    //TODO : ทำให้ไม่สามารถกด back page ได้
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("The System Back Button is Deactivated")),
        );
        return false;
      },
      child: DefaultTabController(
        initialIndex: widget.selectPage,
        length: 4,
        child: Scaffold(
          //TODO 2. Appbar Header
          appBar: AppBar(
            backgroundColor: const Color(0xFF00883C),
            automaticallyImplyLeading: false,
            title: AppbarTitle(
              press: () => Navigator.popAndPushNamed(
                context,
                Member_TabbarHome.routeName,
              ),
            ),
            //Icon Menu bar
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.qr_code,
                  color: Colors.white,
                  size: 35,
                ),
                onPressed: () async {
                  if (user != null) {
                    await scanQR();
                  } else {
                    Navigator.pushNamed(context, PleaseLogin.routeName);
                  }

                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => QRscanWidget()),
                  // );
                },
              ),
              IconButton(
                icon: const FaIcon(
                  FontAwesomeIcons.solidUserCircle,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  if (user != null) {
                    Navigator.pushNamed(
                      context,
                      Member_ProfileScreen.routeName,
                    );
                  } else {
                    Navigator.pushNamed(context, PleaseLogin.routeName);
                  }

                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => PleaseLogin()));
                },
              ),
            ],
            elevation: 2.0,

            //TODO 3. Tabbar in Appbar
            bottom: PreferredSize(
              preferredSize: _tabbar.preferredSize,
              child: ColoredBox(
                color: const Color(0xFF15924C),
                child: Container(
                  height: 75.0,
                  child: _tabbar,
                ),
              ),
            ),
          ),

          //========================================================================================================
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(), //ไม่ต้องเลื่อนได้,
            children: [
              User_HomeScreen(),
              Member_MissionScreen(),
              Member_ExchangeScreen(),
              Member_AchievementScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
