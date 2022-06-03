import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_Admin/member/member_detail/member_detail.dart';
import 'package:recycle_plus/screens/_Admin/member/textfieldSearch.dart';
import 'package:search_page/search_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../components/appbar/appbar_title.dart';

class Member_Search extends SearchDelegate {
  //hint text ของตัวค้นหา
  Member_Search() : super(searchFieldLabel: "Search Email...");
  //firebase collection users
  final CollectionReference _MyFirebaseStore =
      FirebaseFirestore.instance.collection('users');

//============================================================================================
  //TODO 1. ตัวปุ่มกด Icon Close
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          //clear data ที่ป้อนใส่ไป
          query = "";
        },
      ),
    ];
  }

  //TODO 2. Icon Back Page
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  //TODO 3. ตัวแสดงผลลัพธ์ออกมา
  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _MyFirebaseStore.snapshots().asBroadcastStream(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        } else {
          //TODO : Fetch data here

          //เมื่อหาข้อมูลไม่เจอ
          if (snapshot.data!.docs
              .where((QueryDocumentSnapshot<Object?> element) =>
                  element['email']
                      .toString()
                      .toLowerCase()
                      .contains(query.toLowerCase()))
              .isEmpty) {
            return Center(child: buildNotFound());

            //เมื่อหาข้อมูลเจอ
          } else {
            return ListView(
              children: [
                ...snapshot.data!.docs
                    .where((QueryDocumentSnapshot<Object?> element) =>
                        element['email']
                            .toString()
                            .toLowerCase()
                            .contains(query.toLowerCase()))
                    .map((QueryDocumentSnapshot<Object?> data) {
                  //ได้ตัว Data มาละ ----------<<<
                  final String email = data.get("email");
                  final String image = data['image'];
                  final String role = data['role'];

                  //จะแสดงผลข้อมูลที่ได้ในรูปแบบไหน =
                  return ListTile(
                    title: Text(email, style: Roboto16_B_black),
                    leading: Container(
                      width: 45,
                      height: 45,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 1),
                      ),
                      child: Image.network(image),
                    ),
                    subtitle: Text(role, style: Roboto12_black),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF303030),
                      size: 20,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Admin_MemberDetail(data: data),
                        ),
                      );
                    },
                  );
                })
              ],
            );
          }
        }
      },
    );
  }

  //TODO 4. Body เริ่มต้นยังบ่กดค้นหา
  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text("ค้นหาข้อมูลผู้ใช้", style: Roboto18_black),
    );
  }
}

//=====================================================================================================
//Widget ไม่พบผู้ใช้
Widget buildNotFound() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Icon(
        Icons.person_search,
        color: Colors.grey,
        size: 100,
      ),
      Text("ไม่พบผู้ใช้งานนี้", style: Roboto20_grey),
    ],
  );
}
