import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_Admin/exchange/ListProduct.dart';
import 'package:recycle_plus/screens/_Admin/exchange/add_product/add_product.dart';
import 'package:recycle_plus/screens/_Admin/exchange/edit_product/edit_product.dart';
import 'package:recycle_plus/screens/_Admin/exchange/exchange_more.dart';
import 'package:recycle_plus/service/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Admin_Exchange extends StatefulWidget {
  const Admin_Exchange({Key? key}) : super(key: key);

  @override
  State<Admin_Exchange> createState() => _Admin_ExchangeState();
}

class _Admin_ExchangeState extends State<Admin_Exchange> {
  //เรียก firebase database
  DatabaseEZ db = DatabaseEZ.instance;
  //firebase collection news
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('products');

  @override
  Widget build(BuildContext context) {
    //=====================================================================================
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _collection.snapshots().asBroadcastStream(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                //TODO 1. Order Button
                                ElevatedButton.icon(
                                  icon: const FaIcon(Icons.timelapse_sharp,
                                      size: 25),
                                  label: Text("รอดำเนินการ",
                                      style: Roboto16_B_white),
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: const Size(170, 40),
                                    primary: const Color(0xFF25BA67),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  onPressed: () {},
                                ),

                                //TODO 2. Order Button
                                ElevatedButton.icon(
                                  icon: const FaIcon(
                                    Icons.history,
                                    size: 25,
                                  ),
                                  label:
                                      Text("ประวัติ", style: Roboto16_B_white),
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: const Size(170, 40),
                                    primary: const Color(0xFFFEAF6C),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                            const SizedBox(height: 20.0),

                            //TODO 3. Text Head
                            Text("รายการของรางวัล", style: Roboto18_B_black),
                            const SizedBox(height: 20.0),

                            //TODO 4. Head สินค้าล่าสุด
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: Color(0xFFEEEEEE),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("สินค้าล่าสุด",
                                        style: Roboto16_B_black),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(context,
                                            Admin_MoreProduct.routeName);
                                      },
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text("See more",
                                              style: Roboto16_B_green),
                                          const Icon(
                                            Icons.keyboard_arrow_right_rounded,
                                            color: Colors.green,
                                            size: 30,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            //TODO : Fetch data here
                            ...snapshot.data!.docs
                                .map((QueryDocumentSnapshot<Object?> data) {
                              //ได้ตัว Data มาละ ----------<<<
                              final String image = data.get("image");
                              final String title = data.get("name");
                              final String description =
                                  data.get("description");
                              final double token = data.get("token");
                              final int amount = data.get("amount");

                              //จะแสดงผลข้อมูลที่ได้ในรูปแบบไหน =---------------------------
                              //TODO 5. List Product
                              return ListProduct(
                                imageURL: image,
                                title: title,
                                subtitle: description,
                                token: "$token",
                                amount: "$amount",
                                press: () {
                                  //ไปหน้าแก้ไขโดยที่ ส่งค่าข้อมูลไปด้วย
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Admin_editProduct(data: data),
                                    ),
                                  );
                                },
                              );
                            }),
                          ],
                        ),
                      ),
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

  //================================================================================================
  //TODO : Action Add News
  Widget buildFloatingButton() => FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFF00883C),
        onPressed: () {
          Navigator.of(context).pushNamed(Admin_AddProduct.routeName);
        },
      );
}
