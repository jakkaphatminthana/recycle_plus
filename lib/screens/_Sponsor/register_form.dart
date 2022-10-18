import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/models/user_model.dart';
import 'package:recycle_plus/models/varidator.dart';
import 'package:recycle_plus/screens/_User/achievement/dialog_claim.dart';
import 'package:recycle_plus/screens/success/success_register.dart';
import 'package:recycle_plus/screens/success/verify_email.dart';
import 'package:recycle_plus/service/auth.dart';

import '../../components/textfield.dart';

class SponserRegisterForm extends StatefulWidget {
  const SponserRegisterForm({Key? key}) : super(key: key);

  @override
  State<SponserRegisterForm> createState() => _SponserRegisterFormState();
}

class _SponserRegisterFormState extends State<SponserRegisterForm> {
  //formkey = ตัวแสดงตัวแบบยูนืคของฟอร์มนี้
  //AuthService = ตัวเรียกฟังก์ชันที่เกี่ยวกับ user
  //EmailModel = ภายในประกอบด้วย ตัวแปร email, pass, name
  //isLoading = ใช้ในตอนกดปุ่มแล้วรอโหลด
  final _formKey = GlobalKey<FormState>();
  final AuthService auth = AuthService();
  SponserEmailModel inputSponserEmail = SponserEmailModel();
  bool isLoading = false;
  Timer? _timer;

  var otp_status;

  //TODO 1: Check OTP Firebase
  Future<void> CheckOTP({required String OTP}) async {
    //1.1 check isEmpty
    await FirebaseFirestore.instance
        .collection('sponsor_test')
        .doc(OTP)
        .get()
        .then((value) {
      if (value.data() != null) {
        //1.2 get status
        final col_otp = FirebaseFirestore.instance
            .collection('sponsor_test')
            .doc(OTP)
            .snapshots()
            .listen((event) {
          setState(() {
            otp_status = event.get('status');
          });
        });
      } else {
        setState(() {
          otp_status = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
//==================================================================================================================

    return Form(
      key: _formKey,
      child: Column(
        children: [
          //TODO 2. Form Email
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 15, 25, 0),
            child: buildEmailFormField(inputSponserEmail),
          ),

          //TODO 3. Form Password
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 15, 25, 0),
            child: buildPasswordFormField(inputSponserEmail),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(25, 15, 25, 0),
            child: buildOTPFormField(inputSponserEmail),
          ),
          const SizedBox(height: 30),

          //TODO 5. Button Register
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.black,
              fixedSize: const Size(350, 50),
              side: const BorderSide(width: 2.0, color: Colors.white), //ขอบ
              elevation: 2.0, //เงา
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            // Loading ?
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text("REGISTER", style: Roboto20_B_white),

            //TODO 6. เมื่อกดปุ่มให้ทำการส่งข้อมูล TextField
            onPressed: () async {
              //เมื่อกรอกข้อมูลถูกต้อง
              if (_formKey.currentState!.validate()) {
                _formKey.currentState?.save(); //สั่งประมวลผลข้อมูลที่กรอก

                await CheckOTP(OTP: inputSponserEmail.otp);
                if (isLoading) return;
                setState(() => isLoading = true); //Loading

                //Delay time
                _timer = Timer(const Duration(milliseconds: 500), () {
                  print('STATUS  ==> $otp_status');

                  //1. กรณีที่กรอกผิด ไม่มีในระบบ
                  if (otp_status == null) {
                    Fluttertoast.showToast(
                      msg: "OTP ไม่ถูกต้อง",
                      gravity: ToastGravity.BOTTOM,
                    );
                    //2. กรณีที่ OTP ใช้งานไปแล้ว
                  } else if (otp_status == true) {
                    Fluttertoast.showToast(
                      msg: "OTP นี้ถูกใช้งานไปแล้ว",
                      gravity: ToastGravity.BOTTOM,
                    );
                    //3. กรณีที่ OTP ยังว่างอยู่พร้อมใช้งาน
                  } else if (otp_status == false) {
                    //TODO : UPDATE status OTP on Firebase -----------------------------------<<<<
                    auth.SponserregisterEmail(inputSponserEmail.email,
                            inputSponserEmail.password, inputSponserEmail.otp)
                        .then((value) {
                      //Check error register
                      if (value != "not_work") {
                        _formKey.currentState?.reset();

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VerifyEmail(
                              name: inputSponserEmail.email,
                              who: 'sponsor',
                            ),
                          ),
                        );
                      } else {
                        setState(() => isLoading = false);
                      }
                    });
                  } else {
                    Fluttertoast.showToast(
                      msg: "Something is wrong",
                      gravity: ToastGravity.BOTTOM,
                    );
                  }
                });
              }
            },
          ),
        ],
      ),
    );
  }
}

//========================================================================================================================
//TODO : Form Email
TextFormField buildEmailFormField(inputModel) {
  return TextFormField(
    keyboardType: TextInputType.emailAddress,
    obscureText: false, //ปิดตา
    decoration: styleTextField("Enter Email", Icons.mail_outline_sharp),
    validator: ValidatorEmail,
    onSaved: (SponseremailEZ) {
      inputModel.email = SponseremailEZ!;
    },
  );
}

//TODO : Password Form
TextFormField buildPasswordFormField(inputModel) {
  return TextFormField(
    keyboardType: TextInputType.visiblePassword,
    obscureText: true,
    decoration: styleTextField("Enter Password", Icons.lock),
    validator: ValidatorPassword,
    onSaved: (SponserpasswordEZ) {
      inputModel.password = SponserpasswordEZ!;
    },
  );
}

TextFormField buildOTPFormField(inputModel) {
  return TextFormField(
    keyboardType: TextInputType.text,
    obscureText: false,
    decoration: styleTextField("Enter OTP", Icons.key),
    maxLength: 6,
    validator: ValidatorOTP,
    onSaved: (SponserOTPEZ) {
      inputModel.otp = SponserOTPEZ!;
    },
  );
}
