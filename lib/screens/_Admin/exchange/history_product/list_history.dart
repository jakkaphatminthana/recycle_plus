import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:recycle_plus/components/font.dart';

class List_history extends StatefulWidget {
  const List_history({
    Key? key,
    required this.userID,
    required this.productID,
    required this.time,
    required this.total,
    required this.status,
    required this.amount,
    required this.category,
    required this.pickup,
  }) : super(key: key);
  final userID;
  final productID;
  final time;
  final total;
  final status;
  final amount;
  final category;
  final pickup;

  @override
  State<List_history> createState() => _List_historyState();
}

class _List_historyState extends State<List_history> {
  bool delay = false;
  Timer? _timer;
  var user_name;
  var user_email;
  String? user_image;

  var product_name;
  String? product_image;

  //TODO : Get User Database
  Future<void> getUserDatabase(id) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .snapshots()
        .listen((event) {
      setState(() {
        user_name = event.get('name');
        user_email = event.get('email');
        user_image = event.get('image');
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
    getUserDatabase(widget.userID);
    getProductDatabase(widget.productID);
    _timer = Timer(const Duration(milliseconds: 500), () {
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
    //=================================================================================================================
    return (delay == false)
        ? const SpinKitThreeBounce(
            color: Colors.black,
            size: 40.0,
          )
        : Container(
            child: Card(
              child: ExpansionTile(
                iconColor: Colors.green,
                //TODO 1: Header Title
                title: Column(
                  children: [
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Text('Product# ', style: Roboto12_B_black),
                        Text('${widget.productID}', style: Roboto12_black),
                      ],
                    ),
                  ],
                ),
                //TODO 2: Subtitle
                subtitle: Column(
                  children: [
                    TextRow('User: ', user_email),
                    TextRow('Date: ', formattedDate(widget.time)),
                    const SizedBox(height: 10.0),
                  ],
                ),

                //TODO 3: Expanded
                children: [
                  const Divider(
                    height: 1.0,
                    thickness: 2.0,
                    color: Color(0xFFC3C3C3),
                  ),
                  Container(
                    height: 120,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              //TODO 3.1: Image Product
                              Image.network(
                                product_image!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 8.0),

                              Container(
                                width: MediaQuery.of(context).size.width * 0.45,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //TODO 3.2 Product Detail
                                    Text(
                                      product_name.length > 22
                                          ? product_name.substring(0, 22) +
                                              '...'
                                          : product_name,
                                      style: Roboto14_B_black,
                                    ),
                                    TextRow('ประเภท: ', "${widget.category}"),
                                    TextRow('จำนวน: ', "${widget.amount}"),
                                    TextRow(
                                      'นำส่งสินค้า: ',
                                      (widget.pickup == "pickup")
                                          ? "รับเอง"
                                          : "รถขนส่ง",
                                    ),
                                    //TOKEN
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/image/token.png',
                                          width: 25,
                                          height: 25,
                                          fit: BoxFit.cover,
                                        ),
                                        const SizedBox(width: 5.0),
                                        Text(
                                          '${widget.total}',
                                          style: Roboto14_B_black,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  (widget.status == "success")
                                      ? Column(
                                          children: [
                                            const Icon(
                                              Icons.check_circle,
                                              color: Colors.green,
                                              size: 24,
                                            ),
                                            Text(
                                              "Success",
                                              style: Roboto14_B_green,
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
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  //===============================================================================================================
  //TODO : Format Time
  String formattedDate(timeStamp) {
    var dateFromTimeStamp =
        DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
    return DateFormat('dd/MM/yyyy').format(dateFromTimeStamp);
  }

  Widget TextRow(titile, content) {
    return Row(
      children: [
        Text(titile, style: Roboto12_B_green),
        Text(content, style: Roboto12_black),
      ],
    );
  }
}
