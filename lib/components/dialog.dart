// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/login/body_login.dart';

class sucessDialog extends StatelessWidget {
  const sucessDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        height: 240,
        decoration: BoxDecoration(
          color: const Color(0xFFfcfefc),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/image/check-green.gif",
                width: 100,
                height: 100,
              ),
              Text(
                "Success!!",
                style: Roboto20_B_black,
              ),
              const Text("โปรดตรวจสอบในกล่องอีเมลของคุณ"),
              const SizedBox(height: 8.0),
              TextButton(
                child: const Text("ตกลง"),
                onPressed: () {
                  Navigator.of(context).pushNamed(LoginScreen.routeName);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
