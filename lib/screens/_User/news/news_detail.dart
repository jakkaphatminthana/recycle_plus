import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:recycle_plus/components/appbar/appbar_title.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recycle_plus/screens/_User/profile/profile.dart';
import 'package:recycle_plus/screens/login_no/login_no.dart';
import 'package:recycle_plus/screens/scanQR/LDPE/LDPE_detail.dart';
import 'package:recycle_plus/screens/scanQR/PETE/PETE_detail.dart';
import 'package:recycle_plus/screens/scanQR/PP/PP_detail.dart';
import 'package:recycle_plus/screens/scanQR/QRscan.dart';
import 'package:recycle_plus/service/database.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../tabbar_control.dart';

class NewsDetailScreen extends StatefulWidget {
  //ก่อนจะเรียกหน้านี้จำเป็นต้องมี paramiter data
  const NewsDetailScreen({required this.data});
  final data;

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  //db = ติดต่อ firebase
  DatabaseEZ db = DatabaseEZ.instance;
  User? user = FirebaseAuth.instance.currentUser;

  //TODO : QR Scan
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
    final image = widget.data!.get('image');
    final title = widget.data!.get('title');
    final content = widget.data!.get('content');
    final timedate = widget.data!.get('timeUpdate');

//=====================================================================================================
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00883C),
        centerTitle: true,
        title: AppbarTitle(
          press: () => Navigator.popAndPushNamed(
            context,
            Member_TabbarHome.routeName,
          ),
        ),
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
        elevation: 2.0,
      ),
      //---------------------------------------------------------------------------------------
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //TODO 2. Image News
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 240,
                    child: Align(
                      alignment: const AlignmentDirectional(0, 0),
                      child: Image.network(
                        image,
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

                  //TODO 3. Header News
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 200.0,
                            maxWidth: MediaQuery.of(context).size.width,
                          ),
                          child: Text(
                            title,
                            style: Roboto18_B_green,
                          ),
                        ),
                        const SizedBox(height: 10.0),

                        //TODO : Timedate and Auther
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 20,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 5.0),
                            Text(
                              formattedDate(timedate),
                              style: Roboto14_gray,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  //TODO 4. Content News
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 1000.0,
                            maxWidth: MediaQuery.of(context).size.width,
                          ),
                          child: Text(
                            content,
                            style: Roboto14_black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  //===================================================================================================

  //TODO : Format Time
  String formattedDate(timeStamp) {
    var dateFromTimeStamp =
        DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
    return DateFormat('dd/MM/yyyy').format(dateFromTimeStamp);
  }
}
