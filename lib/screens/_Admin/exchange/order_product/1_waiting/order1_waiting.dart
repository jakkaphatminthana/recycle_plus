import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/service/database.dart';

import '../listtile_order.dart';

class Order1_productWait extends StatefulWidget {
  const Order1_productWait({Key? key}) : super(key: key);

  @override
  State<Order1_productWait> createState() => _Order1_productWaitState();
}

class _Order1_productWaitState extends State<Order1_productWait> {
  //เรียก firebase database
  DatabaseEZ db = DatabaseEZ.instance;
  var data_length;
  Timer? _timer_daley;
  bool daley = false;

  //TODO : get length data
  Future<void> getLengthData() async {
    final _collection = FirebaseFirestore.instance
        .collection('orders')
        .doc('trading')
        .collection('order')
        .where('status', isEqualTo: 'pending')
        .get();
    var result = await _collection.then((value) {
      data_length = value.size;
      setState(() {});
    });
  }

  final Stream<QuerySnapshot> _Order_pending = FirebaseFirestore.instance
      .collection('orders')
      .doc('trading')
      .collection('order')
      .where('status', isEqualTo: 'pending')
      .snapshots();

  //TODO 1: Always call first run
  @override
  void initState() {
    super.initState();
    getLengthData();
    _timer_daley = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        daley = true;
        print("len: $data_length");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //==================================================================================================================
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: (data_length == 0)
                  ? build_Nothing()
                  : StreamBuilder<QuerySnapshot>(
                      stream: _Order_pending,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator();
                        } else {
                          return ListView(
                            children: [
                              //TODO : Fetch data here
                              ...snapshot.data!.docs.map(
                                (QueryDocumentSnapshot<Object?> data) {
                                  //ได้ตัว Data มาละ ----------<<<
                                  final String ID_user = data.get("ID_user");
                                  final String ID_product =
                                      data.get("ID_product");
                                  final amount = data.get("amount");
                                  final total = data.get("price");
                                  final timestamp = data.get('timestamp');
                                  final status = data.get('status');
                                  final id = data.id;

                                  return (daley == false)
                                      ? const SpinKitRing(
                                          color: Colors.green,
                                          size: 60.0,
                                        )
                                      : ListTile_Order(
                                          dataOrder: data,
                                          ID_user: ID_user,
                                          ID_product: ID_product,
                                          product_amount: amount,
                                          order_total: total,
                                          order_date: timestamp,
                                          order_status: status,
                                        );
                                },
                              ),
                            ],
                          );
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  //===============================================================================================================
  Widget build_Nothing() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 15.0),
          const Icon(
            Icons.insert_drive_file_outlined,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 5.0),
          Text("Not found", style: Roboto20_grey),
        ],
      ),
    );
  }
}
