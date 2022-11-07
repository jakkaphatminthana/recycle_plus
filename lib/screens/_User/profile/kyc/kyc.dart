import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nextflow_thai_personal_id/nextflow_thai_personal_id.dart';
import 'package:recycle_plus/screens/_User/home/googleform.dart';
import 'package:recycle_plus/service/database.dart';

import '../profile.dart';

class KYCscreen extends StatefulWidget {
  const KYCscreen({Key? key}) : super(key: key);
  //Location Page
  static String routeName = "/KYC";

  @override
  _KYCscreenState createState() => _KYCscreenState();
}

class _KYCscreenState extends State<KYCscreen> {
  TextEditingController? textController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DatabaseEZ db = DatabaseEZ.instance;
  User? user = FirebaseAuth.instance.currentUser;

  ThaiIdValidator thaiIdValidator =
      ThaiIdValidator(errorMessage: 'เลขบัตรประชาชนของท่านไม่ถูกต้อง');

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  Future checkdataKYC({required String ID_Card_Number}) async {
    FirebaseFirestore.instance
        .collection('CheckKYC_Member')
        .doc(ID_Card_Number)
        .get()
        .then((value) {
      if (value.exists) {
        print("มีแล้ว");
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text(
              'เลขบัตรประชาชนนี้ได้ถูกใช้ไปแล้ว โปรดตรวจสอบเลขบัตรปประชาชนของท่านให้ถูกต้อง',
              style: TextStyle(fontSize: 16),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text(
                  'ตกลง',
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
              ),
            ],
          ),
        );
      } else {
        print("ไม่มี");
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Member_ProfileScreen()),
        );
        db.updateKyc(user_ID: user!.uid, ID_Card_Number: textController!.text);
        db.updateCheckKyc(
            user_ID: user!.uid, ID_Card_Number: textController!.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // int textLen = 5;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF107027),
        automaticallyImplyLeading: true,
        title: const Text(
          'โปรดกรอกเลขบัตรประชาชน',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [],
        centerTitle: true,
        elevation: 2,
      ),
      body: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
                    child: Text(
                      'ข้อกำหนดและเงื่อนไข',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                    child: Text(
                      'แอปพลิเคชันจะเก็บข้อมูลเลขบัตรประจำตัวประชาชนของ\nคุณสําหรับการยืนยันตัวตนเพื่อใช้ในการใช้ฟีเจอร์ต่างๆใน\nแอปพลิเคชัน\n\nหมายเหตุ : หากคุณไม่ได้กดตกลงเพื่อที่จะยืนยันตัวตน\nคุณจะไม่สามารถทำการแลกของรางวัลในแอปพลิเคชัน\nได้ เนื่องจากแอปพลิเคชันจําเป็นต้องพิสูจน์และยืนยัน\nตัวตนของคุณ\n',
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 80,
                      child: TextFormField(
                        validator: thaiIdValidator.validate,
                        maxLength: 13,
                        controller: textController,
                        autofocus: false,
                        obscureText: false,
                        decoration: InputDecoration(
                          isDense: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          counterText: '',
                          hintText: 'กรอกเลขบัตรประชาชน',
                          hintStyle: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('กดตกลงเพื่อบันทึกข้อมูล'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    checkdataKYC(
                                        ID_Card_Number: textController!.text);
                                  },
                                  child: const Text(
                                    'ตกลง',
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'ตกลง',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF107027),
                        fixedSize: const Size(150, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
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
