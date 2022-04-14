import 'package:flutter/material.dart';
import 'package:recycle_plus/screens/home/home.dart';
import 'package:recycle_plus/screens/login/body.dart';
import 'package:recycle_plus/screens/start/start.dart';

final Map<String, WidgetBuilder> routes = {
  StartScreen.routeName: (context) => StartScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  LoginScreen.routeName: (context) => LoginScreen(),
};
