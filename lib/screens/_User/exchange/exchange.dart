import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/components/wallet/wallet_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recycle_plus/screens/_User/exchange/detail/product_detail.dart';
import 'package:recycle_plus/service/database.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'card_product1.dart';
import 'card_product2.dart';

class Member_ExchangeScreen extends StatefulWidget {
  const Member_ExchangeScreen({Key? key}) : super(key: key);

  //Location page
  static String routeName = "/Exchange";

  @override
  State<Member_ExchangeScreen> createState() => _Member_ExchangeScreenState();
}

class _Member_ExchangeScreenState extends State<Member_ExchangeScreen> {
  //db = เรียก firebase database
  //_formKey = Key สำหรับการ form
  DatabaseEZ db = DatabaseEZ.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //TODO : get data Stream Snapshot
    final Stream<QuerySnapshot> _Stream_recommend = FirebaseFirestore.instance
        .collection('products')
        .where('recommend', isEqualTo: true)
        .limit(5)
        .snapshots();

    final Stream<QuerySnapshot> _Stream_normal = FirebaseFirestore.instance
        .collection('products')
        .where('amount', isGreaterThanOrEqualTo: 1)
        .limit(6)
        .snapshots();
    //===========================================================================================================
    return Scaffold(
      backgroundColor: const Color(0xFFE9E9E9),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //TODO : Firebase Products Normal -----------------------------
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _Stream_normal,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                } else {
                  return ListView(
                    children: [
                      Stack(
                        children: [
                          //TODO 1. Banner Image
                          Image.asset(
                            "assets/image/banner_trash_cash.jpg",
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.21,
                            fit: BoxFit.cover,
                          ),

                          //TODO 2. Wallet
                          Align(
                            alignment: const AlignmentDirectional(0, 0),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 130.0),
                              child: Wallet_card(colorEZ: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25.0),

                      //TODO 3. Head สินค้าแนะนำ
                      build_headText("ของรางวัลแนะนำ", () {}),
                      const SizedBox(height: 2.0),

                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 210,
                        child: Row(
                          children: [
                            //TODO 4. Firebase Product Recoment ----------------------------
                            Expanded(
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: _Stream_recommend,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (!snapshot.hasData) {
                                      return const CircularProgressIndicator();
                                    } else {
                                      return ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          //TODO : Fetch data here --------------------------
                                          ...snapshot.data!.docs.map(
                                              (QueryDocumentSnapshot<Object?>
                                                  data) {
                                            //ได้ตัว Data มาละ ----------<<<
                                            final String image =
                                                data.get("image");
                                            final String name =
                                                data.get("name");
                                            final double token =
                                                data.get("token");
                                            final int amount =
                                                data.get("amount");

                                            if (amount >= 1) {
                                              return CardProductHot(
                                                name: name,
                                                image: image,
                                                token: "$token",
                                                amount: "$amount",
                                                press: () {
                                                  //ไปหน้ารายละเอียดโดยที่ ส่งค่าข้อมูลไปด้วย
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          Member_ProductDetail(
                                                        data: data,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            }
                                            return Container();
                                          })
                                        ],
                                      );
                                    }
                                  }),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5.0),

                      //TODO 5. Head รายการสินค้า
                      build_headText("รายการของรางวัล", () {}),
                      const SizedBox(height: 7.0),

                      //TODO 6. Product List Normal
                      GridView(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 5,
                          mainAxisExtent: 220,
                        ),
                        children: [
                          //TODO : Fetch data here (Product normal) ------------------------------
                          ...snapshot.data!.docs
                              .map((QueryDocumentSnapshot<Object?> data) {
                            //ได้ตัว Data มาละ ----------<<<
                            final String image = data.get("image");
                            final String name = data.get("name");
                            final double token = data.get("token");
                            final int amount = data.get("amount");

                            return CardProductBig(
                              name: name,
                              image: image,
                              token: "$token",
                              amount: "$amount",
                              press: () {
                                //ไปหน้ารายละเอียดโดยที่ ส่งค่าข้อมูลไปด้วย
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Member_ProductDetail(
                                      data: data,
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  //==================================================================================================================
  //TODO : Widget HeaderText
  Widget build_headText(String title, GestureTapCallback press) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 251, 241, 189),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 3, 10, 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: Roboto16_B_black),
            GestureDetector(
              onTap: press,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("See more", style: Roboto16_B_greenB),
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
    );
  }
}
