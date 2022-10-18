import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/models/user_model.dart';
import 'package:recycle_plus/models/varidator.dart';
import 'package:recycle_plus/screens/success/success_register.dart';
import 'package:recycle_plus/screens/success/verify_email.dart';
import 'package:recycle_plus/service/auth.dart';

import '../../components/textfield.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  //formkey = ตัวแสดงตัวแบบยูนืคของฟอร์มนี้
  //AuthService = ตัวเรียกฟังก์ชันที่เกี่ยวกับ user
  //EmailModel = ภายในประกอบด้วย ตัวแปร email, pass, name
  //isLoading = ใช้ในตอนกดปุ่มแล้วรอโหลด
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  EmailModel inputEmail = EmailModel();
  bool isLoading = false;

//==================================================================================================================
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          //TODO 1. Form Name
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 50, 25, 0),
            child: buildNameFormField(inputEmail),
          ),

          //TODO 2. Form Email
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 15, 25, 0),
            child: buildEmailFormField(inputEmail),
          ),

          //TODO 3. Form Password
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 15, 25, 0),
            child: buildPasswordFormField(inputEmail),
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

                if (isLoading) return;
                setState(() => isLoading = true); //Loading

                await _auth
                    .registerEmail(
                        inputEmail.email, inputEmail.password, inputEmail.name)
                    .then((value) {
                  //Check error register
                  if (value != "not_work") {
                    _formKey.currentState?.reset();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VerifyEmail(
                          name: inputEmail.name,
                          who: 'user',
                        ),
                      ),
                    );
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

//TODO : Name Form
TextFormField buildNameFormField(inputModel) {
  return TextFormField(
    keyboardType: TextInputType.text,
    obscureText: false,
    decoration: styleTextField("Enter Name", Icons.person),
    validator: ValidatorEmpty,
    onSaved: (nameEZ) {
      inputModel.name = nameEZ!;
    },
  );
}
