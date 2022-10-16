import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/models/varidator.dart';
import 'package:recycle_plus/screens/_Admin/sponsor/add%20sponsor/styleTextfield.dart';
import 'dart:math';

import 'package:recycle_plus/service/database.dart';

showDialogAddSponsor({required BuildContext context}) async {
  //formkey = ตัวแสดงตัวแบบยูนืคของฟอร์มนี้
  //db = ติดต่อ firebase
  final _formKey = GlobalKey<FormState>();
  DatabaseEZ db = DatabaseEZ.instance;

  TextEditingController company = TextEditingController();
  TextEditingController otp = TextEditingController();

  //Random Part
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  //-----------------------------------------------------------------------------------------------------------------
  //TODO 1: Cancle Button
  Widget cancelButton(BuildContext context) {
    return FlatButton(
      child: Text("ยกเลิก", style: Roboto16_B_gray),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  //TODO 2: Cancle Button
  Widget continueButton(BuildContext context) {
    return FlatButton(
      child: Text("ยืนยัน", style: Roboto16_B_greenB),
      onPressed: ConfrimContinue(
        context: context,
        formKey: _formKey,
        otpEZ: otp.text,
      ),
    );
  }

//===================================================================================================================
  //TODO 0: Main
  return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text("เพิ่มสมาชิกผู้สนับสนุน", style: Roboto18_B_black),
            actions: [continueButton(context), cancelButton(context)],
            content: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //TODO 2.1: Input Company
                    TextFormField(
                      controller: company,
                      obscureText: false,
                      style: Roboto14_black,
                      validator: ValidatorEmpty,
                      decoration: styleTextFieldSponsor(
                        'Company',
                        'ชื่อบริษัทหรือองค์กร',
                      ),
                    ),
                    const SizedBox(height: 20.0),

                    //TODO 2.2: Input OTP
                    TextFormField(
                      controller: otp,
                      obscureText: false,
                      style: Roboto14_black,
                      maxLength: 6,
                      validator: ValidatorOTP,
                      decoration: styleTextFieldSponsor(
                        'OTP',
                        'กำหนดรหัสประจำตัว',
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    //TODO 3: Random OTP String
                    TextButton(
                      child: Text(
                        'Random OTP?',
                        style: Roboto14_U_black,
                      ),
                      onPressed: () {
                        String randomOTP = getRandomString(6);
                        otp.text = randomOTP;
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      });
}

//===================================================================================================================
//TODO : Chcek OTP ซ้ำกันหรือไม่
Future<bool> CheckOTP(OTP) async {
  final col_sponsor =
      FirebaseFirestore.instance.collection('sponsor').doc(OTP).get();

  var result = await col_sponsor.then((value) {
    if (value.data() != null) {
      print('value = ${value.data()}');
      return true;
    } else {
      return false;
    }
  });
  return result;
}

//TODO : เมือกดปุ่มยืนยัน
GestureTapCallback ConfrimContinue({
  required BuildContext context,
  required formKey,
  required String otpEZ,
}) {
  return () {
    if (formKey.currentState!.validate()) {
      //สั่งประมวลผลข้อมูลที่กรอก
      formKey.currentState?.save();
      var isOTP_Duplicate = CheckOTP(otpEZ);

      //กรณีที่เลข OTP ซ้ำ
      if (isOTP_Duplicate == true) {
        Fluttertoast.showToast(
          msg: "OTP นี้มีอยู่แล้วในระบบ",
          gravity: ToastGravity.BOTTOM,
        );
      } else {
        print('ok');
      }
    }
  };
}
