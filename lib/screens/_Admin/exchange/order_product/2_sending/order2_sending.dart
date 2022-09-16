import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:recycle_plus/components/font.dart';


import '../../../../../service/database.dart';
import '../listtile_order.dart';

class Order2_productSended extends StatefulWidget {
  const Order2_productSended({Key? key}) : super(key: key);

  @override
  State<Order2_productSended> createState() => _Order2_productSendedState();
}

class _Order2_productSendedState extends State<Order2_productSended> {
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
        .where('status', isEqualTo: 'sending')
        .get();
    var result = await _collection.then((value) {
      data_length = value.size;
      setState(() {});
    });
  }

  final Stream<QuerySnapshot> _Order_sending = FirebaseFirestore.instance
      .collection('orders')
      .doc('trading')
      .collection('order')
      .where('status', isEqualTo: 'sending')
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
                      stream: _Order_sending,
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
