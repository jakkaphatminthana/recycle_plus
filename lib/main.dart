//หน้ารันสั่งแอป ให้ทำงาน

import 'package:flutter/material.dart';
import 'package:recycle_plus/routes.dart';
import 'package:recycle_plus/screens/forgotPass/forgotPass.dart';
import 'package:recycle_plus/screens/login_no/login_no.dart';
import 'package:recycle_plus/screens/register/body_register.dart';
import 'package:recycle_plus/screens/start/start.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recycle +',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: ForgotPasswordScreen.routeName,
      routes: routes,
    );
  }
}