import 'dart:async';
import 'dart:math';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_Admin/tabbar_control.dart';
import 'package:recycle_plus/screens/_User/tabbar_control.dart';
import 'package:recycle_plus/service/database.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:walletconnect_secure_storage/walletconnect_secure_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:web3dart/web3dart.dart' as web3;

class RewardWidget extends StatefulWidget {
  const RewardWidget({
    Key? key,
    required this.token,
    required this.exp,
  }) : super(key: key);
  final token;
  final exp;

  @override
  _RewardWidgetState createState() => _RewardWidgetState();
}

class _RewardWidgetState extends State<RewardWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    //==============================================================================================================
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("The System Back Button is Deactivated"),
          ),
        );
        return false;
      },
      child: Scaffold(
        key: scaffoldKey,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: ListView(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.95,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: Image.asset(
                      'assets/image/bg-green2.jpg',
                    ).image,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Align(
                      alignment: const AlignmentDirectional(0, 0),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 60, 0, 0),
                        child: Image.asset(
                          'assets/image/success.png',
                          width: 300,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                      child: Text('ทำรายการสำเร็จ',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400)),
                    ),
                    const Divider(
                      height: 15,
                      thickness: 3,
                      indent: 100,
                      endIndent: 100,
                      color: Color(0x3B6E6E6F),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.access_time,
                            color: Color(0xE7FF0000),
                            size: 24,
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                            child: Text('ระบบจะทำการตรวจสอบและส่งรางวัลไปให้ ',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xE7FF0000),
                                )),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                      child: Text(
                        'รางวัลที่จะได้รับ',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: const Color.fromARGB(231, 0, 0, 0),
                          ),
                        ),
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    'assets/image/token.png',
                                    width: 35,
                                    height: 35,
                                    fit: BoxFit.cover,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            5, 0, 0, 0),
                                    child: Text(
                                      '${widget.token}',
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  15, 0, 0, 0),
                              child: Container(
                                width: 100,
                                height: 100,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Image.asset(
                                      'assets/image/exp2.png',
                                      width: 35,
                                      height: 35,
                                      fit: BoxFit.cover,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              5, 0, 0, 0),
                                      child: Text(
                                        '${widget.exp}',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                          fixedSize: const Size(200, 50),
                          side: const BorderSide(
                              width: 2.0, color: Colors.white), //ขอบ
                          elevation: 2.0, //เงา
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: Text(
                          'Back to Home',
                          style: Roboto16_B_white,
                        ),
                        onPressed: () async {
                          Navigator.pushReplacementNamed(
                            context,
                            Member_TabbarHome.routeName,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
