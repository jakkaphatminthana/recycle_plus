import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recycle_plus/screens/_User/tabbar_control.dart';
import 'package:recycle_plus/screens/scanQR/ObjectDetection/start.dart';
import 'package:recycle_plus/screens/scanQR/PETE/PETE_add.dart';
import 'package:recycle_plus/screens/scanQR/QRscan.dart';

class PETE_detailWidget extends StatefulWidget {
  const PETE_detailWidget({Key? key}) : super(key: key);

  @override
  _PETE_detailWidgetState createState() => _PETE_detailWidgetState();
}

class _PETE_detailWidgetState extends State<PETE_detailWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFF107027),
        automaticallyImplyLeading: true,
        title: Text(
          'รายละเอียดขยะ',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Member_TabbarHome(0)),
              );
            },
          )
        ],
        centerTitle: true,
        elevation: 2,
      ),
//--------------------------------------------------------------------------------------------------------

      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: ListView(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
                    child: Image.asset(
                      //เพิ่มรูปภาพสัญลักษณ์
                      'assets/image/pete.png',
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                    child: Text(
                      //ใส่text
                      'ขยะพลาสติกประเภท',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
                    child: Text(
                      //ใส่text
                      '- พวกขวดพลาสติกใสมองทะลุได้ -',
                      style: TextStyle(
                        color: Color(0xFF107027),
                      ),
                    ),
                  ),

                  Divider(
                    //ใส่เส้น
                    height: 1,
                    thickness: 4,
                    indent: 15,
                    endIndent: 15,
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                    child: Text(
                      //ใส่text
                      'ขวดน้ำดื่ม,ขวดน้ำอัดลม,ขวดน้ำมันพืช',
                      style: TextStyle(
                          color: Colors.orange, fontWeight: FontWeight.w600),
                    ),
                  ),
//--------------------------------------------------------------------------------------------------------
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                    child: Row(
                      //เพิ่มrow
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          //ใส่containerในrow
                          width: 80,
                          height: 80,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            //เพิ่มรูปภาพขวดน้ำ1
                            'assets/image/pete1_(1).jpg',
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(30, 0, 30, 0),
                          child: Container(
                            //ใส่container
                            width: 80,
                            height: 80,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              //ใส่รูปขวดน้ำ2
                              'assets/image/pete2_(1).jpg',
                            ),
                          ),
                        ),
                        Container(
                          //ใส่container
                          width: 80,
                          height: 80,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            //ใสรูปขวดน้ำ3
                            'assets/image/pete3_(1).jpg',
                          ),
                        ),
                      ],
                    ),
                  ),
//--------------------------------------------------------------------------------------------------------
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 200, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PETE_addWidget(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFF107027),
                                fixedSize: Size(250, 40),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                              child: const Text(
                                'Continue',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            const SizedBox(width: 5.0),

                            //TODO : Image Processing Navigator
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: FittedBox(
                                child: FloatingActionButton(
                                  backgroundColor: Colors.amberAccent,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => StratAiMode()),
                                    );
                                  },
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.only(right: 6.0, bottom: 2),
                                    child: Icon(
                                      FontAwesomeIcons.robot,
                                      size: 25,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
