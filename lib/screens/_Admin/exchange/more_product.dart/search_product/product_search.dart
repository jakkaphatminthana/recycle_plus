import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_Admin/exchange/edit_product/edit_product.dart';
import 'package:search_page/search_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'product_listsearch.dart';

class Admin_ProductSearch extends SearchDelegate {
  //hint text ของตัวค้นหา
  Admin_ProductSearch() : super(searchFieldLabel: "Search Name...");
  //firebase collection users
  final CollectionReference _MyFirebaseStore =
      FirebaseFirestore.instance.collection('products');

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

// GestureDetector(
//       onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
  //TODO 3. ตัวแสดงผลลัพธ์ออกมา
  @override
  Widget buildResults(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: StreamBuilder<QuerySnapshot>(
        stream: _MyFirebaseStore.snapshots().asBroadcastStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            //TODO : Fetch data here

            //เมื่อหาข้อมูลไม่เจอ
            if (snapshot.data!.docs
                .where((QueryDocumentSnapshot<Object?> element) =>
                    element['name']
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
                          element['name']
                              .toString()
                              .toLowerCase()
                              .contains(query.toLowerCase()))
                      .map((QueryDocumentSnapshot<Object?> data) {
                    //ได้ตัว Data มาละ ----------<<<
                    final String name = data.get("name");
                    final String image = data['image'];
                    final double token = data['token'];
                    final int amount = data['amount'];

                    //จะแสดงผลข้อมูลที่ได้ในรูปแบบไหน =
                    return ListProductSearch(
                      imageURL: image,
                      title: name,
                      token: "$token",
                      amount: "$amount",
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Admin_editProduct(data: data),
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
      ),
    );
  }

  //TODO 4. Body เริ่มต้นยังบ่กดค้นหา
  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text("ค้นหารายการสินค้า", style: Roboto18_black),
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
        Icons.no_sim_outlined,
        color: Colors.grey,
        size: 100,
      ),
      Text("ไม่พบสินค้า", style: Roboto20_grey),
    ],
  );
}
