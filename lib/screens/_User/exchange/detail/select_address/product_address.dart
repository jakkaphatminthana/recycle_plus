import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_User/exchange/detail/select_address/listtile_selectAddress.dart';
import 'package:recycle_plus/screens/_User/profile/address/dialog_add.dart';
import 'package:recycle_plus/screens/_User/profile/address/listtile_address.dart';
import 'package:recycle_plus/service/database.dart';

class Member_SelectAddress extends StatefulWidget {
  const Member_SelectAddress({
    Key? key,
    required this.data,
    required this.amounts,
    required this.total,
    required this.session,
    required this.ethClient,
  }) : super(key: key);
  final data;
  final amounts;
  final total;
  final session;
  final ethClient;

  @override
  State<Member_SelectAddress> createState() => _Member_SelectAddressState();
}

class _Member_SelectAddressState extends State<Member_SelectAddress> {
  User? user = FirebaseAuth.instance.currentUser;
  DatabaseEZ db = DatabaseEZ.instance;

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _stream_address = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('address')
        .orderBy('timestamp', descending: false)
        .snapshots();
    //==============================================================================================================
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF00883C),
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: Text("เลือกที่อยู่จัดส่ง", style: Roboto18_B_white),
          //Icon Menu bar
          elevation: 2.0,
          actions: [
            IconButton(
              icon: const FaIcon(
                Icons.add,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                showDialogAddAddress(context: context, user_ID: 'user_ID');
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _stream_address,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const SpinKitCircle(
                        color: Colors.green,
                        size: 50,
                      );
                    } else {
                      return ListView(
                        children: [
                          //TODO : Fetch data here
                          ...snapshot.data!.docs
                              .map((QueryDocumentSnapshot<Object?> data_address) {
                            //ได้ตัว Data มาละ -------------------------<<<
                            final address = data_address.get('address');
                            final phone = data_address.get('phone');

                            return ListTile_SelectAddress(
                              data_address: data_address,
                              address: address,
                              phone: phone,
                              data: widget.data,
                              amounts: widget.amounts,
                              total: widget.total,
                              session: widget.session,
                              ethClient: widget.ethClient,
                            );
                          }),
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
