import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_Admin/sponsor/bill/add_bill/add_bill.dart';
import 'package:recycle_plus/screens/_Admin/sponsor/bill/list_bill.dart';

class Admin_BillScreen extends StatefulWidget {
  const Admin_BillScreen({Key? key}) : super(key: key);
  //Location page
  static String routeName = "/Admin_BillPage";

  @override
  State<Admin_BillScreen> createState() => _Admin_BillScreenState();
}

class _Admin_BillScreenState extends State<Admin_BillScreen> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _stream_bill =
        FirebaseFirestore.instance.collection('bill_sponsor').snapshots();
    //==============================================================================================================
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00883C),
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text("ความเคลื่อนไหวเงินทุน", style: Roboto16_B_white),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _stream_bill.asBroadcastStream(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const SpinKitCircle(
                    color: Colors.green,
                    size: 40,
                  );
                } else {
                  return ListView(
                    children: [
                      //TODO : Fetch data here
                      ...snapshot.data!.docs
                          .map((QueryDocumentSnapshot<Object?> data) {
                        //ได้ตัว Data มาละ ----------<<<
                        final time = data.get("timestamp");
                        final title = data.get("title");
                        final money = data.get("money");
                        final file = data.get('file');

                        return ListTile_Bill(
                          file: file,
                          time: time,
                          title: title,
                          money: money,
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
      //TODO : ปุ่มกดมุมขวาล่าง
      floatingActionButton: buildFloatingButton(),
    );
  }

  //===============================================================================================================
  //TODO : Action Add Sponsor
  Widget buildFloatingButton() => FloatingActionButton(
        child: const Icon(Icons.post_add_sharp, size: 35),
        backgroundColor: const Color(0xFF00883C),
        onPressed: () {
          Navigator.pushNamed(context, Admin_BillAdd.routeName);
        },
      );

  //TODO : Format time
  String formattedDate(timeStamp) {
    var dateFromTimeStamp =
        DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
    return DateFormat('dd/MM/yyyy').format(dateFromTimeStamp);
  }
}
