import 'package:flutter/material.dart';

class Sponsor_HomeScreen extends StatefulWidget {
  const Sponsor_HomeScreen({Key? key}) : super(key: key);
  //Location Page
  static String routeName = "/home_sponsor";


  @override
  State<Sponsor_HomeScreen> createState() => _Sponsor_HomeScreenState();
}

class _Sponsor_HomeScreenState extends State<Sponsor_HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('sponsor'),
    );
  }
}
