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
                            final String id_trash = data.get('id');
                            final String image = data.get('image');
                            final String image_white = data.get('image_white');
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
                                    //TODO : แปลงค่า String to Int[0,1]
                                    final data_map_token =
                                        data_SplitText(token);
                                    final token1 = data_map_token[0];
                                    final token2 = data_map_token[1];
                                    var token1_int = int.parse(token1!);
                                    var token2_int = int.parse(token2!);

                                    final data_map_exp = data_SplitText(exp);
                                    final exp1 = data_map_exp[0];
                                    final exp2 = data_map_exp[1];
                                    var exp1_int = int.parse(exp1!);
                                    var exp2_int = int.parse(exp2!);

                                    //ไปหน้าแก้ไขโดยที่ ส่งค่าข้อมูลไปด้วย
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Admin_TrashEdit(
                                          id_trash: id_trash,
                                          image: image_white,
                                          subtitle: subtitle,
                                          token1: token1_int,
                                          token2: token2_int,
                                          exp1: exp1_int,
                                          exp2: exp2_int,
                                        ),
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

  data_SplitText(data) {
    List<String> data_split = data.split(".");
    final data_map = data_split.asMap();
    return data_map;
  }
}
