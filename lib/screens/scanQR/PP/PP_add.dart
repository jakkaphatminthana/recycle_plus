import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:recycle_plus/screens/_User/tabbar_control.dart';
import 'package:recycle_plus/screens/scanQR/PP/PP_added.dart';
import 'package:recycle_plus/screens/scanQR/Qrscan.dart';
import 'package:uuid/uuid.dart';

class PP_addWidget extends StatefulWidget {
  PP_addWidget({Key? key}) : super(key: key);

  @override
  _PP_addWidgetState createState() => _PP_addWidgetState();
}

class _PP_addWidgetState extends State<PP_addWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController trash = TextEditingController();
  String? image_name;

  //url รูปที่อัพโหลด
  File? value_image;
  var image_path;
  var image_file;

  //เลือกรูปภาพจาก gallery
  Future pickImage() async {
    try {
      //นำภาพที่เลือกมาเก็บไว้ใน image
      final value_image =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      //เช็คว่าถ้าไม่ได้เลือกก็ออก
      if (value_image == null) return;
      // นำ path image ที่เราเลือกไปเก็บไว้ใน image_file เพื่อเอาไปใช้ในส่วนของการบันทึก
      image_path = value_image.path;
      // เอาภาพที่เลือกไว้มาเก็บไว้ใน image_path เพื่อเอาไปใช้ในส่วนของการบันทึก
      image_file = value_image;
      //แปลงเป็น File
      final imageTemporary = File(value_image.path);
      //ชื่อไฟล์ของภาพที่เลือก
      String basename = value_image.path.split('/').last;

      setState(() {
        // เอาไปเก็บไว้ใน image เเล้วอัพเดดเเล้วภาพจะขึ้น
        this.value_image = imageTemporary;
        this.image_name = basename;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFF107027),
        automaticallyImplyLeading: true,
        title: Text(
          'กรอกข้อมูลรายละเอียด',
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
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
                        child: Image.asset(
                          //ใส่รูปสัญลักษณ์
                          'assets/image/pp.png',
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
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
                        child: Text(
                          //ใส่text
                          '- พลาสติกประเภททนต่อความร้อนสูง -',
                          style: TextStyle(
                            color: Color(0xFF107027),
                          ),
                        ),
                      ),
                    ],
                  ),
//--------------------------------------------------------------------------------------------------------
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(25, 0, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          //ใส่text
                          'จำนวนขยะที่อยู่ในมือ',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                    child: Container(
                      //ใส่container
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Color(0x82E0E3E7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                        child: Row(
                          //ใส่row
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: TextFormField(
                                  //ใส่texxtfield
                                  controller: trash,
                                  autofocus: false,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    hintText: 'กรอกจำนวนขยะ',
                                    hintStyle: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
//--------------------------------------------------------------------------------------------------------
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(25, 5, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          //ใส่text
                          'รูปภาพขยะ',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  (value_image != null)
                      ? Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color.fromARGB(57, 0, 0, 0),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Image.file(
                                  value_image!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      15, 0, 0, 0),
                                  child: Container(
                                    width: 130,
                                    height: 100,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            image_name!,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      30, 0, 0, 0),
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.close_outlined,
                                        size: 25,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          value_image = null;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
//--------------------------------------------------------------------------------------------------------
                      : GestureDetector(
                          onTap: () {
                            // เรียกใช้ฟังก์ชันpickimage
                            pickImage();
                          },
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                            child: Container(
                              //ใส่container
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 45,
                              decoration: BoxDecoration(
                                color: Color(0x82E0E3E7),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                                child: Row(
                                  //ใส่rowในcontainer
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      //ใส่text
                                      'อัพโหลดรูปภาพ',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color:
                                              Color.fromARGB(255, 96, 96, 96)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
//--------------------------------------------------------------------------------------------------------
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 60, 0, 0),
                    child: ElevatedButton(
                      //ใส่ปุ่ม
                      onPressed: () async {
                        var amount = int.parse(trash.text);
                        
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PP_addedWidget(
                              amount: amount,
                              value_image: value_image,
                              image_name: image_name,
                              image_file: image_file,
                              image_path: image_path,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF107027),
                        fixedSize: Size(200, 45),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      child: Text(
                        'Confirm',
                        style: TextStyle(fontSize: 18),
                      ),
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
