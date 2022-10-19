import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:recycle_plus/screens/_Admin/sponsor/bill/list_bill.dart';
import 'package:recycle_plus/screens/_Sponsor/Status/list_bill.dart';

class Supportstatus extends StatefulWidget {
  const Supportstatus({Key? key}) : super(key: key);

  @override
  State<Supportstatus> createState() => _SupportstatusState();
}

class _SupportstatusState extends State<Supportstatus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ความเคลื่อนใหวการสนับสนุน',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xFF00883C),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('bill_sponsor').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((document) {
              var datedata = document['timestamp'].toDate();
              var time = document['timestamp'];
              var title = document['title'].toString();
              var file = document['file'].toString();
              var money = document['money'].toString();
              return ListTile_Bill(
                file: file,
                time: time,
                title: title,
                money: money,
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
