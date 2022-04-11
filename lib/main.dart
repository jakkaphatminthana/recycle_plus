//หน้ารันสั่งแอป ให้ทำงาน

import 'package:flutter/material.dart';
import 'package:recycle_plus/routes.dart';
import 'package:recycle_plus/screens/start.dart';

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
      initialRoute: StartScreen.routeName,
      routes: routes,
    );
  }
}