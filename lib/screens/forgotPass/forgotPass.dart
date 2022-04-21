import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recycle_plus/components/dialog.dart';
import 'package:recycle_plus/components/font.dart';

import '../../components/textfield.dart';
import '../../models/user_model.dart';
import '../../models/varidator.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);
  //Location Route Page
  static String routeName = "/forgot";

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  EmailModel inputEmail = EmailModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //TODO 1. Back Page
              Align(
                alignment: const AlignmentDirectional(-1, 0),
                child: Padding(
                  padding: EdgeInsets.only(left: 10, top: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const FaIcon(
                      FontAwesomeIcons.arrowCircleLeft,
                      color: Color(0xFF00883C),
                      size: 30.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),

              //TODO 2. Image
              Image.asset(
                "assets/image/forgotPass.png",
                width: 300,
                height: 300,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20.0),

              //TODO 3. Header forgot
              Text("Forgot Password?", style: Roboto25_B_black),
              const SizedBox(height: 10.0),

              //TODO 4. Subtitle
              Text("แค่กรอกอีเมล์ที่ได้ลงทะเบียนไว้ เราจะทำการส่งส่งลิงค์",
                  style: Roboto14_black),
              Text("รีเซ็ตรหัสผ่านไปยังอีเมลของคุณ", style: Roboto14_black),

              //TODO 5. TextField
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: buildEmailFormField(inputEmail),
              ),
              const SizedBox(height: 30.0),

              //TODO 6. Button
              ElevatedButton(
                child: Text("SEND", style: Roboto20_B_white),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  fixedSize: const Size(220, 45),
                  side: const BorderSide(width: 2.0, color: Colors.white), //ขอบ
                  elevation: 2.0, //เงา
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                onPressed: () {
                  //TODO 7. Dialog Success
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return sucessDialog();
                      });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//============================================================================================================
//TODO : Form Email
TextFormField buildEmailFormField(inputModel) {
  return TextFormField(
    keyboardType: TextInputType.emailAddress,
    obscureText: false, //ปิดตา
    decoration: styleTextField_Radius30(""),
    validator: ValidatorEmail,
    onSaved: (emailEZ) {
      inputModel.email = emailEZ!;
    },
  );
}
