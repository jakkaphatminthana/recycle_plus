// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_User/tabbar_control.dart';
import 'package:recycle_plus/screens/login/body_login.dart';

class Dialog_SucessBuy extends StatelessWidget {
  const Dialog_SucessBuy({Key? key}) : super(key: key);
  //Location page
  static String routeName = "/Dialog_success";

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        height: 320,
        width: MediaQuery.of(context).size.width * 0.85,
        decoration: BoxDecoration(
          color: const Color(0xFFfcfefc),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/image/timeing2.gif",
                width: 150,
                height: 150,
              ),
              Text("Success!", style: Roboto20_B_black),
              const SizedBox(height: 8.0),
              const Text("กำลังทำรายการอาจใช้เวลา 1 นาที"),
              const Text("ระหว่างนี้ท่านสามารถออกไปทำอย่างอื่นได้เลย"),
              const SizedBox(height: 8.0),
              TextButton(
                child: const Text("ตกลง"),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Member_TabbarHome(2), //หน้าแลกของ
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
