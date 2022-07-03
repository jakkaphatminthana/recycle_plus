import 'package:flutter/material.dart';
import 'package:recycle_plus/screens/login/body_login.dart';
import 'package:recycle_plus/screens/register/form_register.dart';

import '../../components/font.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  //Location Page
  static String routeName = "/register";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              //TODO 1. Background
              Image.asset(
                "assets/image/bg-green1.jpg",
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 1,
                fit: BoxFit.cover,
              ),

              Align(
                alignment: const AlignmentDirectional(0, 0),
                child: Column(
                  children: [
                    //TODO 2. LOGO App
                    Padding(
                      padding: const EdgeInsets.only(top: 80),
                      child: Image.asset(
                        "assets/image/logo.png",
                        width: 110,
                        height: 110,
                        fit: BoxFit.cover,
                      ),
                    ),
                    //TODO 3. Header
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        "RECYCLE+",
                        textAlign: TextAlign.center,
                        style: Russo55_B_black,
                      ),
                    ),

                    //TODO 4. Form Register
                    const RegisterForm(),

                    //TODO 5. subtitle text
                    const SizedBox(height: 30.0),
                    Text(
                      "ฉันมีบัญชีเข้าใช้งานอยู่แล้ว",
                      style: Roboto17_black,
                    ),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, LoginScreen.routeName),
                      child: Text(
                        "Login",
                        style: Roboto18_B_green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
