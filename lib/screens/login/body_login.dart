import 'package:flutter/material.dart';
import 'package:recycle_plus/components/social_card.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/login/form_login.dart';
import 'package:recycle_plus/screens/register/body_register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  //Location Route Page
  static String routeName = "/login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                    //TODO 2. Logo Recycle+
                    Padding(
                      padding: const EdgeInsets.only(top: 80),
                      child: Image.asset(
                        "assets/image/logo.png",
                        width: 110,
                        height: 110,
                        fit: BoxFit.cover,
                      ),
                    ),

                    //TODO 3. HEAD RUSE Text
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        "RECYCLE+",
                        textAlign: TextAlign.center,
                        style: Russo55_B_black,
                      ),
                    ),

                    //TODO 4. Form Login
                    const Form_Login(),

                    //TODO 5. ICON SVG
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50, 25, 50, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Social_Card(
                            icon: "assets/icons/user-circle-plus-bold.svg",
                            press: () {
                              Navigator.pushNamed(
                                  context, RegisterScreen.routeName);
                            },
                          ),
                          Social_Card(
                            icon: "assets/icons/google.svg",
                            press: () {},
                          ),
                        ],
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
