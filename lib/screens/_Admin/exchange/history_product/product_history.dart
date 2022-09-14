import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_Admin/exchange/history_product/list_history.dart';
import 'package:recycle_plus/service/database.dart';

class Admin_exchange_History extends StatefulWidget {
  const Admin_exchange_History({Key? key}) : super(key: key);
  //Location page
  static String routeName = "/Admin_ExchangeHistory";

  @override
  State<Admin_exchange_History> createState() => _Admin_exchange_HistoryState();
}

class _Admin_exchange_HistoryState extends State<Admin_exchange_History> {
  DatabaseEZ db = DatabaseEZ.instance;
  var user_name;

  //TODO : Get User Database
  Future<void> getUserData(Id_user) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Id_user)
        .snapshots()
        .listen((event) {
      setState(() {
        user_name = event.get('name');
      });
    });
  }

  //TODO : Get Product Database
  Future<void> getProductDatabase(Id_product) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Id_product)
        .snapshots()
        .listen((event) {
      setState(() {
        user_name = event.get('name');
      });
    });
  }

  final Stream<QuerySnapshot> _order_success = FirebaseFirestore.instance
      .collection('orders')
      .doc('trading')
      .collection('order')
      .snapshots();

  @override
  //================================================================================================================
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00883C),
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text("การแลกเปลี่ยนที่เสร็จสิ้น", style: Roboto16_B_white),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _order_success,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ListView(
                      children: [
                        const SizedBox(height: 5.0),
                        //TODO : Fetch data here
                        ...snapshot.data!.docs.map(
                          (QueryDocumentSnapshot<Object?> data) {
                            //ได้ตัว Data มาละ ----------<<<
                            final userID = data.get('ID_user');
                            final productID = data.get('ID_product');
                            final timestamp = data.get('timestamp');
                            final total = data.get('price');
                            final status = data.get('status');
                            final amount = data.get('amount');
                            final category = data.get('category');
                            final pickup = data.get('pickup');

                            return List_history(
                              userID: userID,
                              productID: productID,
                              time: timestamp,
                              total: total,
                              status: status,
                              amount: amount,
                              category: category,
                              pickup: pickup,
                            );
                          },
                        )
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
