import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/models/user_model.dart';
import 'package:recycle_plus/models/varidator.dart';

import '../../components/textfield.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  //formkey = ตัวแสดงตัวแบบยูนืคของฟอร์มนี้
  //EmailModel = ภายในประกอบด้วย ตัวแปร email, pass, name
  final _formKey = GlobalKey<FormState>();
  EmailModel inputEmail = EmailModel();

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
            child: Text("REGISTER", style: Roboto20_B_white),
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
