import 'package:flutter/material.dart';
import 'package:recycle_plus/screens/_Admin/member/member.dart';
import 'package:recycle_plus/screens/_Admin/tabbar_control.dart';
import 'package:recycle_plus/screens/_NoLogin/tabbar_control.dart';
import 'package:recycle_plus/screens/forgotPass/forgotPass.dart';
import 'package:recycle_plus/screens/login/body_login.dart';
import 'package:recycle_plus/screens/login_no/login_no.dart';
import 'package:recycle_plus/screens/register/body_register.dart';
import 'package:recycle_plus/screens/start/start.dart';
import 'package:recycle_plus/screens/success/success_login.dart';
import 'package:recycle_plus/screens/success/success_register.dart';

final Map<String, WidgetBuilder> routes = {
  StartScreen.routeName: (context) => StartScreen(),
  LoginScreen.routeName: (context) => LoginScreen(),
  RegisterScreen.routeName: (context) => RegisterScreen(),
  PleaseLogin.routeName: (context) => PleaseLogin(),
  ForgotPasswordScreen.routeName:(context) => ForgotPasswordScreen(),
  LoginSuccess.routeName: (context) => LoginSuccess(),
  RegisterSuccess.routeName: (context) => RegisterSuccess(),
  Member_TabbarHome.routeName: (context) => Member_TabbarHome(),
  Admin_TabbarHome.routeName: (context) => Admin_TabbarHome(),
  Admin_MemberScreen.routeName: (context) => Admin_MemberScreen(),
};
