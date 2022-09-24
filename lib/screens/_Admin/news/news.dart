import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_Admin/news/listWidget.dart';
import 'package:recycle_plus/screens/_Admin/news/news_add.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:recycle_plus/screens/_Admin/news/news_edit.dart';
import 'package:recycle_plus/service/database.dart';
import 'package:intl/intl.dart';

class Admin_NewsScreen extends StatefulWidget {
  //Location page
  static String routeName = "/Admin_News";

  @override
  State<Admin_NewsScreen> createState() => _Admin_NewsScreenState();
}

class _Admin_NewsScreenState extends State<Admin_NewsScreen> {
  //เรียก firebase database
  DatabaseEZ db = DatabaseEZ.instance;
  //firebase collection news
  final CollectionReference _collectionNews =
      FirebaseFirestore.instance.collection('news');

  @override
  Widget build(BuildContext context) {
    //====================================================================================================
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10.0),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _collectionNews
                    .where('status', isEqualTo: true)
                    .snapshots()
                    .asBroadcastStream(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    //TODO : Fetch data here
                    return ListView(
                      children: [
                        ...snapshot.data!.docs
                            .map((QueryDocumentSnapshot<Object?> data) {
                          //ได้ตัว Data มาละ ----------<<<
                          final String title = data.get("title");
                          final String content = data.get("content");
                          final String image = data.get("image");
                          final datetime = data.get("timeUpdate");

                          //จะแสดงผลข้อมูลที่ได้ในรูปแบบไหน =---------------------------
                          return ListWidget(
                            imageURL: image,
                            title: title,
                            content: content,
                            dateTimeEZ: datetime,
                            press: () {
                              //ไปหน้าแก้ไขโดยที่ ส่งค่าข้อมูลไปด้วย
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Admin_NewsEdit(data: data),
                                ),
                              );
                            },
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

      //TODO : ปุ่มกดมุมขวาล่าง
      floatingActionButton: buildFloatingButton(),
    );
  }

//================================================================================================
  //TODO : Action Add News
  Widget buildFloatingButton() => FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFF00883C),
        onPressed: () {
          Navigator.pushNamed(context, Admin_NewsAdd.routeName);
        },
      );
}
