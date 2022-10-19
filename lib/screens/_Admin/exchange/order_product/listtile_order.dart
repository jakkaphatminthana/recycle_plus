import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_Admin/exchange/order_product/order_update/order_update.dart';



class ListTile_Order extends StatefulWidget {
  const ListTile_Order({
    Key? key,
    required this.dataOrder,
    required this.ID_user,
    required this.ID_product,
    required this.order_total,
    required this.product_amount,
    required this.order_status,
    required this.order_date,
  }) : super(key: key);

  final dataOrder;
  final ID_user;
  final ID_product;
  final order_total;
  final product_amount;
  final order_status;
  final order_date;

  @override
  State<ListTile_Order> createState() => _ListTile_OrderState();
}

class _ListTile_OrderState extends State<ListTile_Order> {
  bool delay = false;
  Timer? _timer;
  var product_name;
  var product_image;
  var user_email;

  //TODO : Get User Database
  Future<void> getUserDatabase(id) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .snapshots()
        .listen((event) {
      setState(() {
        user_email = event.get('email');
      });
    });
  }

  //TODO : Get Product Database
  Future<void> getProductDatabase(id) async {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(id)
        .snapshots()
        .listen((event) {
      setState(() {
        product_name = event.get('name');
        product_image = event.get('image');
      });
    });
  }

  //TODO : First call whenever run
  @override
  void initState() {
    super.initState();
    getUserDatabase(widget.ID_user);
    getProductDatabase(widget.ID_product);
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
        : Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Admin_OrderUpdate(data: widget.dataOrder),
                  ),
                );
              },
              child: Material(
                //เงา
                color: Colors.transparent,
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Container(
                  //กล่องใส่เนื้อหา
                  width: MediaQuery.of(context).size.width,
                  height: 110,
                  decoration: BoxDecoration(
                    //กรณีสินค้าหมด
                    color: const Color(0xFFEEEEEE),
                    boxShadow: const [
                      BoxShadow(
                        //กำหนดเงา
                        color: Color(0x7F000000),
                        offset: Offset(1, 1.5),
                      )
                    ],
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: const Color(0xB29F9F9F),
                      width: 1,
                    ),
                  ),
                  //TODO 1. เนื้อหาในกล่อง Container
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: [
                        //TODO 2. Container 80%
                        Container(
                          width: MediaQuery.of(context).size.width * 0.75,
                          height: MediaQuery.of(context).size.height,
                          child: Row(
                            children: [
                              //TODO 2.1 Image Product
                              Container(
                                width: 90,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEEEEEE),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.network(
                                    product_image,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),

                              //TODO 2.3 Title name product
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //TEXT Product name
                                    Text(
                                      (product_name.length > 22)
                                          ? product_name.substring(0, 22) +
                                              "..."
                                          : product_name,
                                      style: Roboto14_B_greenB,
                                    ),
                                    //TEXT User email
                                    Row(
                                      children: [
                                        Text('User: ', style: Roboto14_B_black),
                                        Text(
                                          (user_email.length > 22)
                                              ? user_email.substring(0, 22) +
                                                  "..."
                                              : user_email,
                                          style: Roboto12_black,
                                        ),
                                      ],
                                    ),

                                    //TODO 2.4 Timestamp
                                    Row(
                                      children: [
                                        Text('Time: ', style: Roboto14_B_black),
                                        Text(
                                          formattedDate(widget.order_date),
                                          style: Roboto12_black,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 7.0),

                                    //TODO 2.5 Amout and Price
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        //Amount product
                                        Row(
                                          children: [
                                            const FaIcon(
                                              FontAwesomeIcons.box,
                                              color: Color(0xFF2975C0),
                                              size: 20,
                                            ),
                                            const SizedBox(width: 5.0),
                                            Text(
                                              "${widget.product_amount}",
                                              style: Roboto16_B_blue,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 10.0),

                                        //Token Price
                                        Row(
                                          children: [
                                            Image.asset(
                                              "assets/image/token.png",
                                              width: 25,
                                              height: 25,
                                              fit: BoxFit.cover,
                                            ),
                                            const SizedBox(width: 5.0),
                                            Text(
                                              '${widget.order_total}',
                                              style: Roboto16_B_black,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        //TODO 3. Container 10%
                        Container(
                          width: MediaQuery.of(context).size.width * 0.15,
                          height: MediaQuery.of(context).size.height * 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              (widget.order_status == "sending")
                                  ? Column(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: Colors.lightBlue.shade900,
                                          size: 24,
                                        ),
                                        Text(
                                          "Sending",
                                          style: Roboto14_B_blueDeep,
                                        ),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        const Icon(
                                          Icons.access_time,
                                          color: Colors.orangeAccent,
                                          size: 24,
                                        ),
                                        Text(
                                          "Pending",
                                          style: Roboto14_B_orange,
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  //===============================================================================================================
  //TODO : Format Time
  String formattedDate(timeStamp) {
    var dateFromTimeStamp =
        DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
    return DateFormat('dd/MM/yyyy (hh:mm a)').format(dateFromTimeStamp);
  }
}
