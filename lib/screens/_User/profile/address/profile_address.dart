import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_User/profile/address/dialog_add.dart';
import 'package:recycle_plus/screens/_User/profile/address/listtile_address.dart';
import 'package:recycle_plus/service/database.dart';

class Member_ProfileAddress extends StatefulWidget {
  const Member_ProfileAddress({Key? key}) : super(key: key);
  //Location Page
  static String routeName = "/MyAddressList";

  @override
  State<Member_ProfileAddress> createState() => _Member_ProfileAddressState();
}

class _Member_ProfileAddressState extends State<Member_ProfileAddress> {
  User? user = FirebaseAuth.instance.currentUser;
  DatabaseEZ db = DatabaseEZ.instance;
  //Delay Database
  var data_length;
  Timer? _timer_daley;
  bool daley = false;

  //TODO 1: get length data
  Future<void> getLengthData() async {
    final _collection = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('address')
        .get();
    var result = await _collection.then((value) {
      data_length = value.size;
      setState(() {});
    });
  }

  //TODO 2: Always call first run
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
  void dispose() {
    _timer_daley?.cancel();
    super.dispose();
  }

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
          title: Text("จัดการที่อยู่", style: Roboto18_B_white),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: (data_length == 0)
                    ? build_notFound()
                    : StreamBuilder<QuerySnapshot>(
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
                                    .map((QueryDocumentSnapshot<Object?> data) {
                                  //ได้ตัว Data มาละ -------------------------<<<
                                  final address = data.get('address');
                                  final phone = data.get('phone');

                                  return ListTile_address(
                                    data: data,
                                    address: address,
                                    phone: phone,
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

  //================================================================================================================
  Widget build_notFound() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20.0),
          const Icon(
            Icons.location_off_rounded,
            color: Color(0xFFCCCCCC),
            size: 80,
          ),
          const SizedBox(height: 5.0),
          Text('Not Found', style: Roboto20_B_gray2),
          Text(
            'ไม่พบที่อยู่จัดส่ง โปรดทำการเพิ่มข้อมูล',
            style: Roboto16_B_gray2,
          ),
        ],
      ),
    );
  }
}
