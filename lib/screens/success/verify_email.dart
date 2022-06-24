import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);
  //Location page
  static String routeName = "/Verify_Email";

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
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
            "Verify email",
            style: Roboto18_gray,
          ),
        ),
      ),
      //------------------------------------------------------------------------------------
      body: SafeArea(
        child: SingleChildScrollView(
          child: Align(
            alignment: const AlignmentDirectional(0, 0),
            child: Column(
              children: [
                //TODO 2. Image Main
                Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Image.asset("name"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
