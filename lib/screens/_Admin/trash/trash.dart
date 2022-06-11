import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recycle_plus/screens/_Admin/trash/list_trash.dart';
import 'package:recycle_plus/screens/_Admin/trash/trash_edit.dart';
import 'package:recycle_plus/service/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Admin_TrashControl extends StatefulWidget {
  const Admin_TrashControl({Key? key}) : super(key: key);

  //Location page
  static String routeName = "/Admin_Trash";

  @override
  State<Admin_TrashControl> createState() => _Admin_TrashControlState();
}

class _Admin_TrashControlState extends State<Admin_TrashControl> {
  //เรียก firebase database
  DatabaseEZ db = DatabaseEZ.instance;
  //firebase collection Trash
  final CollectionReference _collectionTrash =
      FirebaseFirestore.instance.collection('trash');

  @override
  Widget build(BuildContext context) {
    //======================================================================================================
    return Scaffold(
      //TODO 1. Appbar Header
      appBar: AppBar(
        backgroundColor: const Color(0xFF00883C),
        centerTitle: true,
        title: Text("ข้อมูลขยะในระบบ", style: Roboto18_B_white),
        elevation: 2.0,
      ),
      //---------------------------------------------------------------------------------
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 10.0),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _collectionTrash.snapshots().asBroadcastStream(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    //TODO : Fetch data here
                    return ListView(
                      children: [
                        ...snapshot.data!.docs.map(
                          (QueryDocumentSnapshot<Object?> data) {
                            //ได้ตัว Data มาละ ----------<<<
                            final String image = data.get('image');
                            final String title = data.get("title");
                            final String subtitle = data.get("subtitle");
                            final String token = data.get("token");
                            final String exp = data.get("exp");
                            final String description = data.get("description");

                            var token_double = double.parse(token);
                            var exp_double = double.parse(exp);

                            return Column(
                              children: [
                                ListTrash(
                                  image: image,
                                  title: title,
                                  subtitle: subtitle,
                                  token: token_double,
                                  exp: exp_double,
                                  description: description,
                                  press: () {
                                    //ไปหน้าแก้ไขโดยที่ ส่งค่าข้อมูลไปด้วย
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Admin_TrashEdit(data: data),
                                      ),
                                    );
                                    // print("token = ${token.runtimeType}");
                                    // print("token change = ${token_double.runtimeType}");
                                  },
                                ),
                                const SizedBox(height: 17.0),
                              ],
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
}
