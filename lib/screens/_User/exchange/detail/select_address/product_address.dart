import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_User/exchange/detail/select_address/dialog_add.dart';
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
        .orderBy('tag', descending: true)
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
                showDialogAddAddress_exchange(
                  context: context,
                  user_ID: 'user_ID',
                  data_pro: widget.data,
                  amounts: widget.amounts,
                  total: widget.total,
                  session: widget.session,
                  ethClient: widget.ethClient,
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                child: (data_length == 0)
                    ? build_notFound()
                    : StreamBuilder<QuerySnapshot>(
                        stream: _stream_address,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          int count_home = 0;
                          int count_work = 0;
                          int count_simple = 0;
                          if (!snapshot.hasData) {
                            return const SpinKitCircle(
                              color: Colors.green,
                              size: 50,
                            );
                          } else {
                            return ListView(
                              children: [
                                //TODO : Fetch data here
                                ...snapshot.data!.docs.map(
                                    (QueryDocumentSnapshot<Object?>
                                        data_address) {
                                  //ได้ตัว Data มาละ -------------------------<<<
                                  final address = data_address.get('address');
                                  final phone = data_address.get('phone');
                                  final tag = data_address.get('tag');

                                  //ไว้นับเลข
                                  if (tag == 'Home') {
                                    count_home++;
                                  } else if (tag == 'Work') {
                                    count_work++;
                                  } else if (tag == "") {
                                    count_simple++;
                                  }

                                  return ListTile_SelectAddress(
                                    data_address: data_address,
                                    address: address,
                                    phone: phone,
                                    tag: tag,
                                    data: widget.data,
                                    amounts: widget.amounts,
                                    total: widget.total,
                                    session: widget.session,
                                    ethClient: widget.ethClient,
                                    number: (tag == "Home")
                                        ? count_home
                                        : (tag == "Work")
                                            ? count_work
                                            : count_simple,
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
