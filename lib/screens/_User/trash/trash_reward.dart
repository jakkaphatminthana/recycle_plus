import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:recycle_plus/components/appbar/appbar_title.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recycle_plus/screens/_User/trash/list_trash.dart';
import 'package:recycle_plus/screens/login_no/login_no.dart';
import 'package:recycle_plus/screens/scanQR/LDPE/LDPE_detail.dart';
import 'package:recycle_plus/screens/scanQR/PETE/PETE_detail.dart';
import 'package:recycle_plus/screens/scanQR/PP/PP_detail.dart';
import 'package:recycle_plus/screens/scanQR/QRscan.dart';
import 'package:recycle_plus/service/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../profile/profile.dart';
import '../tabbar_control.dart';

class Member_TrashRate extends StatefulWidget {
  //Location page
  static String routeName = "/Member_TrashRate";

  @override
  State<Member_TrashRate> createState() => _Member_TrashRateState();
}

class _Member_TrashRateState extends State<Member_TrashRate> {
  User? user = FirebaseAuth.instance.currentUser;
  //เรียก firebase database
  DatabaseEZ db = DatabaseEZ.instance;
  //firebase collection Trash
  final CollectionReference _collectionTrash =
      FirebaseFirestore.instance.collection('trash');

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

  @override
  Widget build(BuildContext context) {
    //================================================================================================
    return Scaffold(
      //TODO 1. Appbar Header
      appBar: AppBar(
        backgroundColor: const Color(0xFF00883C),
        centerTitle: true,
        title: AppbarTitle(
          press: () {
            Navigator.pushNamed(context, Member_TabbarHome.routeName);
          },
        ),
        //Icon Menu
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
            },
          ),
        ],
      ),
      //------------------------------------------------------------------------------
      body: Column(
        children: [
          Expanded(
            //TODO : ดึงตัว firebase มาก่อนเพื่อให้อยู่ใน ListView เดียวกัน
            child: StreamBuilder<QuerySnapshot>(
              stream: _collectionTrash.snapshots().asBroadcastStream(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  //TODO : Fetch data here
                  return ListView(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //TODO 2. Image Banner
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                            child: Align(
                              alignment: const AlignmentDirectional(0, 0),
                              child: Image.asset(
                                "assets/image/reward_banner.png",
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height * 1,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const Divider(
                            height: 10.0,
                            thickness: 10,
                            color: Color(0xFFC4C4C4),
                          ),
                          const SizedBox(height: 20.0),

                          //TODO 3.Reward Rate
                          ...snapshot.data!.docs.map(
                            (QueryDocumentSnapshot<Object?> data) {
                              //ได้ตัว Data มาละ ----------<<<
                              final String image = data.get('image');
                              final String title = data.get("title");
                              final String subtitle = data.get("subtitle");
                              final String token = data.get("token");
                              final String exp = data.get("exp");
                              final String nature = data.get("nature");

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: List_TrashRate(
                                  image: image,
                                  title: title,
                                  subtitle: subtitle,
                                  nature: nature,
                                  token: token,
                                  exp: exp,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
