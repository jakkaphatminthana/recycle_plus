import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_Admin/exchange/ListProduct.dart';
import 'package:recycle_plus/service/database.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../edit_product/edit_product.dart';
import 'search_product/product_search.dart';

class Admin_MoreProduct extends StatefulWidget {
  const Admin_MoreProduct({Key? key}) : super(key: key);
  //Location page
  static String routeName = "/Admin_ExchangeMoreProduct";

  @override
  State<Admin_MoreProduct> createState() => _Admin_MoreProductState();
}

class _Admin_MoreProductState extends State<Admin_MoreProduct> {
  //db = เรียก firebase database
  //_formKey = Key สำหรับการ form
  DatabaseEZ db = DatabaseEZ.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isNFT = true;
  bool isLimited = true;
  bool outOfStock = false;
  var data_length;

  @override
  Widget build(BuildContext context) {
    //TODO : get data Stream Snapshot
    final Stream<QuerySnapshot> _Stream_Limited = FirebaseFirestore.instance
        .collection('products')
        .where("category", isEqualTo: "Limited")
        .snapshots();
    final Stream<QuerySnapshot> _Stream_NFT = FirebaseFirestore.instance
        .collection('products')
        .where("category", isEqualTo: "NFT")
        .snapshots();
    final Stream<QuerySnapshot> _Stream_OutofStock = FirebaseFirestore.instance
        .collection('products')
        .where("amount", isEqualTo: 0)
        .snapshots();
    final Stream<QuerySnapshot> _Stream_All =
        FirebaseFirestore.instance.collection('products').snapshots();
    //====================================================================================================================
    return Scaffold(
      //TODO 1. Appbar Headder
      appBar: AppBar(
        backgroundColor: const Color(0xFF00883C),
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text("รายการสินค้า", style: Roboto16_B_white),
        //Icon Menu ทางขวาสุด
        actions: [
          //TODO 2: Search Item
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: Admin_ProductSearch());
            },
          ),
          //TODO 3: Filter Item
          IconButton(
            icon: const Icon(Icons.filter_list_outlined),
            onPressed: () {
              showInformationDialog(context);
            },
          ),
        ],
      ),
      //------------------------------------------------------------------------
      body: Column(
        children: [
          //TODO 4: Stream Database Snapshot
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: (isLimited == true && isNFT == false)
                  ? _Stream_Limited
                  : (isLimited == false && isNFT == true)
                      ? _Stream_NFT
                      : (outOfStock == true)
                          ? _Stream_OutofStock
                          : _Stream_All,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Text("No data");
                } else {
                  return ListView(
                    children: [
                      const SizedBox(height: 5.0),

                      //TODO : Fetch data here
                      ...snapshot.data!.docs
                          .map((QueryDocumentSnapshot<Object?> data) {
                        //ได้ตัว Data มาละ ----------<<<
                        final String image = data.get("image");
                        final String title = data.get("name");
                        final String category = data.get("category");
                        final String description = data.get("description");
                        final double token = data.get("token");
                        final int amount = data.get("amount");
                        final bool status = data.get('status');

                        if (status == true) {
                          return ListProduct(
                            imageURL: image,
                            title: title,
                            subtitle: description,
                            token: "$token",
                            amount: "$amount",
                            category: category,
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
                        } else {
                          return Container();
                        }
                      }),
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

  //===================================================================================================================
  //TODO : Dialog Filter
  Future<void> showInformationDialog(BuildContext context) async {
    var check1 = isLimited;
    var check2 = isNFT;
    var check3 = outOfStock;
    var checkError = 0;

    //1.Cancle buttons
    Widget cancelButton = TextButton(
      child: Text("Reset", style: Roboto16_B_gray),
      onPressed: () {
        setState(() {
          isLimited = true;
          isNFT = true;
          outOfStock = false;
          checkError = 0;
        });
        Navigator.of(context).pop();
      },
    );
    //2.Continue buttons
    Widget continueButton = TextButton(
      child: Text("Filter", style: Roboto16_B_green),
      onPressed: () async {
        // print("isLimited = $isLimited");
        // print("isNFT = $isNFT");
        // print("checkError = $checkError");

        //2.1 เมื่อมีการ false ทุกตัวเลือก
        if (check1 == false && check2 == false && check3 == false) {
          setState(() {
            checkError = 1;
          });
          //กรณีเกิด ERROR all false check
          (checkError == 1)
              ? Fluttertoast.showToast(
                  msg: "โปรดเลือกเนื้อหาอย่างน้อย 1 อย่าง",
                  gravity: ToastGravity.BOTTOM,
                )
              : Container();
        } else {
          setState(() {
            isLimited = check1;
            isNFT = check2;
            outOfStock = check3;
            checkError = 0;
          });
          Navigator.of(context).pop();
        }
      },
    );
    //3.แสดงออกมา dialog stateful
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              actions: [continueButton, cancelButton],
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //3.1 Header Text
                    Text("ขัดแยกประเภท", style: Roboto18_B_black),
                    const SizedBox(height: 5.0),
                    const Divider(
                      height: 1.0,
                      thickness: 2.0,
                      color: Color(0xFFC3C3C3),
                    ),

                    //3.2 Checkbox Limited
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCheckBox(
                          iconEZ: Icons.star_rounded,
                          title: "Limited",
                        ),
                        Transform.scale(
                          scale: 1.1,
                          child: Checkbox(
                            value: check1,
                            activeColor: const Color(0xFF00883C),
                            onChanged: (checked) {
                              setState(() {
                                check1 = checked!;
                                if (check3 == true) {
                                  check3 = false;
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    //3.3 Checkbox NFT
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCheckBox(
                          iconEZ: Icons.panorama,
                          title: "NFT",
                        ),
                        Transform.scale(
                          scale: 1.1,
                          child: Checkbox(
                            value: check2,
                            activeColor: const Color(0xFF00883C),
                            onChanged: (checked) {
                              setState(() {
                                check2 = checked!;
                                if (check3 == true) {
                                  check3 = false;
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    //3.3 Checkbox NFT
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCheckBox(
                          iconEZ: Icons.cancel_sharp,
                          title: "สินค้าหมด",
                        ),
                        Transform.scale(
                          scale: 1.1,
                          child: Checkbox(
                            value: check3,
                            activeColor: Colors.redAccent,
                            onChanged: (checked) {
                              setState(() {
                                check3 = checked!;
                                if (checked == true) {
                                  check1 = false;
                                  check2 = false;
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  //TODO : CheckBox Selection
  _buildCheckBox({iconEZ, title}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        //1.แบ่งพื้นที่ 50% / 50%
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          child: Row(
            children: [
              //2. พื้นที่สำหรับ Icon
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.10,
                child: FaIcon(
                  iconEZ,
                  size: (title == "NFT") ? 25 : 30,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 5.0),
              //3. Title Type
              Text(title, style: Roboto16_B_black),
            ],
          ),
        ),
        //4. Check box
      ],
    );
  }
}
