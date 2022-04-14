import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/components/textfield.dart';
import 'package:recycle_plus/models/user_model.dart';
import 'package:recycle_plus/models/varidator.dart';

class Form_Login extends StatefulWidget {
  const Form_Login({Key? key}) : super(key: key);

  @override
  State<Form_Login> createState() => _Form_LoginState();
}

class _Form_LoginState extends State<Form_Login> {
  //formkey = ตัวแสดงตัวแบบยูนืคของฟอร์มนี้
  //LoginEmailModel = ภายในประกอบด้วย ตัวแปร email, pass, name
  final _formKey = GlobalKey<FormState>();
  LoginEmailModel inputlModel = LoginEmailModel();

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
            child: buildEmailFormField(inputlModel),
          ),

          //TODO 2. Form Password
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 15, 25, 0),
            child: buildPasswordFormField(inputlModel),
          ),

          //TODO 3. Forgot password
          Padding(
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
          const SizedBox(height: 30),

          //TODO 4. Button LOGIN
          ElevatedButton(
            child: Text("LOGIN", style: Roboto20_B_white),
            style: ElevatedButton.styleFrom(
              primary: Colors.black,
              fixedSize: const Size(350, 45),
              side: const BorderSide(width: 2.0, color: Colors.white), //ขอบ
              elevation: 2.0, //เงา
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            onPressed: () {},
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
