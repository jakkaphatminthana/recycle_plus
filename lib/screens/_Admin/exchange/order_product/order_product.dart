import 'package:flutter/material.dart';

import '../../../../components/font.dart';

class Admin_ExchangeOrder extends StatefulWidget {
  const Admin_ExchangeOrder({Key? key}) : super(key: key);
  //Location page
  static String routeName = "/Admin_ExchangeOrder";

  @override
  State<Admin_ExchangeOrder> createState() => _Admin_ExchangeOrderState();
}

class _Admin_ExchangeOrderState extends State<Admin_ExchangeOrder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: const Color(0xFF00883C),
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text("รายการแลกชองรางวัล", style: Roboto16_B_white),
      ),
      body: Column(),
    );
  }
}
