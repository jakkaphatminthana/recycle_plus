import 'package:flutter/material.dart';
import 'package:recycle_plus/screens/_Admin/exchange/add_product/add_product.dart';
import 'package:recycle_plus/screens/_Admin/exchange/history_product/product_history.dart';
import 'package:recycle_plus/screens/_Admin/exchange/more_product.dart/exchange_more.dart';
import 'package:recycle_plus/screens/_Admin/exchange/order_product/order_product.dart';
import 'package:recycle_plus/screens/_Admin/member/member.dart';
import 'package:recycle_plus/screens/_Admin/news/news.dart';
import 'package:recycle_plus/screens/_Admin/news/news_add.dart';
import 'package:recycle_plus/screens/_Admin/setting/setting.dart';
import 'package:recycle_plus/screens/_Admin/setting/sponsor%20logo/sponsor_logo.dart';
import 'package:recycle_plus/screens/_Admin/tabbar_control.dart';
import 'package:recycle_plus/screens/_Admin/trash/trash.dart';
import 'package:recycle_plus/screens/_User/exchange/detail/dialog_success.dart';
import 'package:recycle_plus/screens/_User/exchange/exchange_more/product_recomend.dart';
import 'package:recycle_plus/screens/_User/profile/edit_profile/profile_edit.dart';
import 'package:recycle_plus/screens/forgotPass/forgotPass.dart';
import 'package:recycle_plus/screens/login/body_login.dart';
import 'package:recycle_plus/screens/login_no/login_no.dart';
import 'package:recycle_plus/screens/register/body_register.dart';
import 'package:recycle_plus/screens/scanQR/Qrscan.dart';
import 'package:recycle_plus/screens/start/start.dart';
import 'package:recycle_plus/screens/success/success_login.dart';
import 'package:recycle_plus/screens/success/welcome.dart';
import 'package:recycle_plus/screens/success/success_register.dart';
import 'package:recycle_plus/screens/success/verify_email.dart';
import 'package:recycle_plus/screens/test/test_MutiAddData.dart';
import 'package:recycle_plus/screens/test/test_blockchain.dart';
import 'package:recycle_plus/screens/test/test_metamask.dart';
import 'package:recycle_plus/screens/test/test_showdata.dart';
import 'package:recycle_plus/screens/wallet/wallet_connecting.dart';

import 'screens/_User/exchange/exchange.dart';
import 'screens/_User/profile/profile.dart';
import 'screens/_User/tabbar_control.dart';
import 'screens/_User/trash/trash_reward.dart';

final Map<String, WidgetBuilder> routes = {
  Test1_listData.routeName: (context) => Test1_listData(),
  Test_MutiData.routeName: (context) => Test_MutiData(),
  Test_MetaMask.routeName: (context) => Test_MetaMask(),
  
  Wallet_Connecting.routeName: (context) => Wallet_Connecting(),
  StartScreen.routeName: (context) => StartScreen(),
  LoginScreen.routeName: (context) => LoginScreen(),
  RegisterScreen.routeName: (context) => RegisterScreen(),
  PleaseLogin.routeName: (context) => PleaseLogin(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  WelcomeScreen.routeName: (context) => WelcomeScreen(),
  LoginSuccess.routeName: (context) => LoginSuccess(),
  RegisterSuccess.routeName: (context) => RegisterSuccess(),
  Dialog_SucessBuy.routeName: (context) => Dialog_SucessBuy(),
  Member_TabbarHome.routeName: (context) => Member_TabbarHome(0),
  Member_ProfileScreen.routeName: (context) => Member_ProfileScreen(),
  Member_TrashRate.routeName: (context) => Member_TrashRate(),
  Member_ExchangeScreen.routeName: (context) => Member_ExchangeScreen(),
  Member_ProductRC_More.routeName: (context) => Member_ProductRC_More(),


  Admin_TabbarHome.routeName: (context) => Admin_TabbarHome(0),
  Admin_MemberScreen.routeName: (context) => Admin_MemberScreen(),
  Admin_NewsScreen.routeName: (context) => Admin_NewsScreen(),
  Admin_NewsAdd.routeName: (context) => Admin_NewsAdd(),
  Admin_SettingMore.routeName: (context) => Admin_SettingMore(),
  Admin_LogoSponsor.routeName: (context) => Admin_LogoSponsor(),
  Admin_TrashControl.routeName: (context) => Admin_TrashControl(),
  Admin_AddProduct.routeName: (context) => Admin_AddProduct(),
  Admin_MoreProduct.routeName: (context) => Admin_MoreProduct(),
  Admin_exchange_History.routeName: (context) => Admin_exchange_History(),
  Admin_ExchangeOrder.routeName:(context) => Admin_ExchangeOrder(),
};
