import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';

class LoginSuccess extends StatefulWidget {
  const LoginSuccess({Key? key}) : super(key: key);
  //Location page
  static String routeName = "/LoginSuccess";

  @override
  State<LoginSuccess> createState() => _LoginSuccessState();
}

class _LoginSuccessState extends State<LoginSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //TODO 1. Appbar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        leading: const SizedBox(),
        flexibleSpace: Align(
          alignment: const AlignmentDirectional(0, 0.55),
          child: Text(
            "Login Success",
            style: Roboto18_gray,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Align(
            alignment: const AlignmentDirectional(0, 0),
            child: Column(
              children: [
                //TODO 2. Image Success
                Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Image.asset(
                    "assets/image/success.png",
                    fit: BoxFit.cover,
                  ),
                ),

                //TODO 3. Text Login Success
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Text(
                    "Login Success",
                    style: Russo26_gray,
                  ),
                ),
                const SizedBox(height: 50.0),

                //TODO 4. Button
                ElevatedButton(
                  child: Text("Back to Home", style: Roboto20_B_white),
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF00883C),
                    fixedSize: const Size(160, 45),
                    elevation: 2.0, //เงา
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onPressed: () {
                    
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
