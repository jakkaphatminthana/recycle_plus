import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recycle_plus/components/font.dart';

class Order_userPart extends StatefulWidget {
  const Order_userPart({
    Key? key,
    required this.ID_user,
    required this.order_pickup,
    required this.order_address,
  }) : super(key: key);
  final ID_user;
  final order_pickup;
  final order_address;

  @override
  State<Order_userPart> createState() => _Order_userPartState();
}

class _Order_userPartState extends State<Order_userPart> {
  bool delay = false;
  Timer? _timer;
  var user_email;
  var user_phone;

  //TODO : Get User Database
  Future<void> getUserDatabase(id) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .snapshots()
        .listen((event) {
      setState(() {
        user_email = event.get('email');
        user_phone = event.get('phone');
      });
    });
  }

  //TODO : First call whenever run
  @override
  void initState() {
    super.initState();
    getUserDatabase(widget.ID_user);
    _timer = Timer(const Duration(milliseconds: 250), () {
      setState(() {
        delay = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    //================================================================================================================
    return (delay == false)
        ? const SpinKitRing(
            color: Colors.green,
            size: 60.0,
          )
        : Column(
            children: [
              TextRowIcon(
                Icons.location_history,
                'ผู้ใช้: ',
                user_email,
              ),
              const SizedBox(height: 5.0),
              TextRowIcon(
                (widget.order_pickup == "pickup")
                    ? Icons.store_mall_directory_rounded
                    : FontAwesomeIcons.truck,
                'วิธีรับสินค้า: ',
                (widget.order_pickup == "pickup") ? 'รับสินค้าเอง' : 'รถขนส่ง',
              ),
              const SizedBox(height: 5.0),
              TextRowIcon(
                Icons.phone_android,
                'เบอร์โทร: ',
                (user_phone != null) ? user_phone : '-',
              ),
              const SizedBox(height: 5.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextRowIcon(Icons.location_on, 'ที่อยู่: ', ''),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 300.0,
                      maxWidth: MediaQuery.of(context).size.width,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: Text(widget.order_address, style: Roboto14_black),
                    ),
                  ),
                ],
              ),
            ],
          );
  }

  //=================================================================================================================
  Widget TextRowIcon(IconEZ, title, value) {
    return Row(
      children: [
        FaIcon(
          IconEZ,
          color: const Color(0xFF30AE68),
          size: (value == "รถขนส่ง") ? 19 : 25,
        ),
        const SizedBox(width: 5.0),
        Text(title, style: Roboto14_B_green),
        Text(value, style: Roboto14_black),
      ],
    );
  }
}
