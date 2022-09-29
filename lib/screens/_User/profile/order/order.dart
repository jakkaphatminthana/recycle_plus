import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_User/profile/order/list_order.dart';

class Member_orderTrading extends StatefulWidget {
  const Member_orderTrading({Key? key}) : super(key: key);
  //Location Page
  static String routeName = "/MyOrder";

  @override
  State<Member_orderTrading> createState() => _Member_orderTradingState();
}

class _Member_orderTradingState extends State<Member_orderTrading> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _order_trading = FirebaseFirestore.instance
        .collection('orders')
        .doc('trading')
        .collection('order')
        .orderBy('timestamp', descending: true)
        .snapshots();
    //=============================================================================================================
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00883C),
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text("Order Trading", style: Roboto18_B_white),
        //Icon Menu bar
        elevation: 2.0,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _order_trading,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const SpinKitCircle(
                    color: Colors.green,
                    size: 50,
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ListView(
                      children: [
                        //TODO : Fetch data here
                        ...snapshot.data!.docs
                            .map((QueryDocumentSnapshot<Object?> data) {
                          //ได้ตัว Data มาละ ----------<<<
                          final userID = data.get('ID_user');
                          final productID = data.get('ID_product');
                          final timestamp = data.get('timestamp');
                          final total = data.get('price');
                          final status = data.get('status');
                          final amount = data.get('amount');
                          final category = data.get('category');
                          final pickup = data.get('pickup');

                          if (userID == user!.uid) {
                            return ListOrderTrading(
                              userID: userID,
                              productID: productID,
                              time: timestamp,
                              total: total,
                              status: status,
                              amount: amount,
                              category: category,
                              pickup: pickup,
                              order_data: data,
                            );
                          } else {
                            return Container();
                          }
                        }),
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
