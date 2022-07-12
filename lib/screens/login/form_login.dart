import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/components/textfield.dart';
import 'package:recycle_plus/models/user_model.dart';
import 'package:recycle_plus/models/varidator.dart';
import 'package:recycle_plus/screens/forgotPass/forgotPass.dart';
import 'package:recycle_plus/screens/success/success_login.dart';
import 'package:recycle_plus/screens/success/verify_email.dart';
import 'package:recycle_plus/screens/success/welcome.dart';
import 'package:recycle_plus/service/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Form_Login extends StatefulWidget {
  const Form_Login({Key? key}) : super(key: key);

  @override
  State<Form_Login> createState() => _Form_LoginState();
}

class _Form_LoginState extends State<Form_Login> {
  //formkey = ตัวแสดงตัวแบบยูนืคของฟอร์มนี้
  //AuthService = ตัวเรียกฟังก์ชันที่เกี่ยวกับ user
  //EmailModel = ภายในประกอบด้วย ตัวแปร email, pass, name
  //isLoading = ใช้ในตอนกดปุ่มแล้วรอโหลด
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  EmailModel inputEmail = EmailModel();
  bool isLoading = false;

  //-----------------------------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          //TODO 1. Form Email
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 50, 25, 0),
            child: buildEmailFormField(inputEmail),
          ),

          //TODO 2. Form Password
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 15, 25, 0),
            child: buildPasswordFormField(inputEmail),
          ),

          //TODO 3. Forgot password
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(ForgotPasswordScreen.routeName);
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 10, 28, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Forgot password?",
                    style: Roboto14_U_black,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),

          //TODO 4. Button LOGIN
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
            //TODO : Click Loading?
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text("LOGIN", style: Roboto20_B_white),

            //TODO 5. กดปุ่มแล้วทำอะไร
            onPressed: () async {
              //เมื่อกรอกข้อมูลถูกต้อง
              if (_formKey.currentState!.validate()) {
                _formKey.currentState?.save(); //สั่งประมวลผลข้อมูลที่กรอก

                if (isLoading) return;
                setState(() => isLoading = true); //Loading

                //TODO 6. Login with email
                await _auth.LoginEmail(inputEmail.email, inputEmail.password)
                    .then((value) {
                  //Check error register
                  if (value != "not_work") {
                    _formKey.currentState?.reset();
                    User? user = FirebaseAuth.instance.currentUser;
                    print("Login User = $user");

                    //ตรวจสอบว่ายืนยันอีเมลยัง?
                    if (user?.emailVerified == true) {
                      Navigator.pushNamed(context, WelcomeScreen.routeName);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VerifyEmail(name: null)),
                      );
                    }
                  } else {
                    setState(() => isLoading = false);
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
    onSaved: (emailEZ) {
      inputModel.email = emailEZ!;
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
    onSaved: (passwordEZ) {
      inputModel.password = passwordEZ!;
    },
  );
}
