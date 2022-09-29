import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recycle_plus/models/varidator.dart';
import 'package:recycle_plus/screens/_Admin/exchange/exchange.dart';
import 'package:recycle_plus/screens/_Admin/exchange/order_product/order_update/listtile_update.dart';
import 'package:recycle_plus/screens/_Admin/exchange/order_product/order_update/order_updateUser.dart';
import 'package:recycle_plus/screens/_Admin/exchange/order_product/order_update/textfieldStyle.dart';
import 'package:recycle_plus/screens/_Admin/news/textfieldStyle.dart';
import 'package:recycle_plus/screens/_Admin/tabbar_control.dart';
import 'package:recycle_plus/service/database.dart';

import '../../../../../components/font.dart';

class Admin_OrderUpdate extends StatefulWidget {
  const Admin_OrderUpdate({Key? key, required this.data}) : super(key: key);
  final data;

  @override
  State<Admin_OrderUpdate> createState() => _Admin_OrderUpdateState();
}

class _Admin_OrderUpdateState extends State<Admin_OrderUpdate> {
  //formkey = ตัวแสดงตัวแบบยูนืคของฟอร์มนี้
  //db = ติดต่อ firebase
  final _formKey = GlobalKey<FormState>();
  DatabaseEZ db = DatabaseEZ.instance;

  final CompanyType = [
    "ไปรษณีย์ไทย",
    "KERRY EXPRESS",
    "BEST EXPRESS",
    "NINJA VAN",
    "J&T EXPRESS",
    "FLASH EXPRESS",
    "DHL EXPRESS"
  ];
  String? value_company;
  String? value_tracking;

  @override
  Widget build(BuildContext context) {
    final ID_user = widget.data!.get('ID_user');
    final ID_product = widget.data!.get('ID_product');
    final order_pickup = widget.data!.get('pickup');
    final order_total = widget.data!.get('price');
    final product_amount = widget.data!.get('amount');
    final order_status = widget.data!.get('status');
    final order_date = widget.data!.get('timestamp');
    final order_address = widget.data!.get('address');
    final order_ID = widget.data!.id;
    //===============================================================================================================
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF00883C),
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: Text("อัปเดตสถานะ", style: Roboto16_B_white),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //TODO 1: Product Infomation
                      Text('Order infomation', style: Roboto16_B_black),
                      const SizedBox(height: 10.0),
                      ListTile_OrderUpdate(
                        ID_user: ID_user,
                        ID_product: ID_product,
                        order_total: order_total,
                        product_amount: product_amount,
                        order_status: order_status,
                        order_date: order_date,
                      ),
                      const SizedBox(height: 20.0),
                      const Divider(
                        height: 1,
                        thickness: 2,
                        color: Color(0xFFC3C3C3),
                      ),
                      const SizedBox(height: 10.0),

                      //TODO 2: Order Infomation
                      Order_userPart(
                        ID_user: ID_user,
                        order_pickup: order_pickup,
                        order_address: order_address,
                      ),
                      const SizedBox(height: 20.0),
                      const Divider(
                        height: 1,
                        thickness: 2,
                        color: Color(0xFFC3C3C3),
                      ),
                      const SizedBox(height: 5.0),

                      //TODO 3: tracking Product
                      (order_pickup == 'pickup')
                          //TODO 3.1: Receive Product
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('ได้เขามารับของแล้ว?',
                                    style: Roboto16_B_black),
                                const SizedBox(height: 10.0),
                              ],
                            )
                          //TODO 3.2: tracking Product
                          : Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Header Text
                                  Text('เกี่ยวกับพัสดุ',
                                      style: Roboto16_B_black),
                                  const SizedBox(height: 10.0),

                                  //TODO 3.2.1: Option Company
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    height: 45,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black, width: 1),
                                    ),
                                    //ลบเส้นออกใต้ออก
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        hint: const Text("เลือกบริษัทขนส่ง"),
                                        style: Roboto14_black,
                                        value: value_company,
                                        isExpanded: true, //ทำให้กว้าง
                                        items: CompanyType.map(
                                          (value) => DropdownMenuItem(
                                            value: value,
                                            child: Text(value,
                                                style: Roboto14_black),
                                          ),
                                        ).toList(),
                                        onChanged: (value) {
                                          value_company = value;
                                          setState(() {});
                                          print("valueEZ = $value_company");
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 15.0),

                                  //TODO 3.2.2: tracking Number
                                  TextFormField(
                                    obscureText: false,
                                    style: Roboto14_black,
                                    decoration: styleTextFieldOrder(
                                      'เลขพัสดุ',
                                      'ป้อนหมายเลขพัสดุ',
                                    ),
                                    validator: ValidatorEmpty,
                                    onSaved: (value) => value_tracking = value,
                                  ),
                                  const SizedBox(height: 20.0),
                                ],
                              ),
                            ),

                      //TODO 4: Button Update
                      MaterialButton(
                        minWidth: MediaQuery.of(context).size.width,
                        height: 50.0,
                        child: Text(
                            (order_pickup == "pickup" &&
                                    order_status == "pending")
                                ? "Received"
                                : (order_pickup == "delivery" &&
                                        order_status == "pending")
                                    ? "Continute"
                                    : "Update Status",
                            style: Roboto18_B_white),
                        color: Colors.green,
                        elevation: 2.0,
                        disabledColor: Colors.grey,
                        onPressed: () async {
                          //1.กรณีเป็นแบบ pickup
                          if (order_pickup == 'pickup') {
                            await db
                                .updateOrderStatus(
                              ID_order: order_ID,
                              Type_order: order_pickup,
                            )
                                .then((value) {
                              print('update order success');
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Admin_TabbarHome(2),
                                ),
                              );
                            }).catchError((err) => print('Error update: $err'));
                            //2.กรณีที่เป็นแบบ delivery
                          } else {
                            //เมื่อกรอกข้อมูลถูกต้อง
                            if (_formKey.currentState!.validate()) {
                              //สั่งประมวลผลข้อมูลที่กรอก
                              _formKey.currentState?.save();

                              await db
                                  .updateOrderStatus(
                                ID_order: order_ID,
                                Type_order: order_pickup,
                                company: value_company,
                                tracking: value_tracking,
                              )
                                  .then((value) {
                                print('update order success');
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Admin_TabbarHome(2),
                                  ),
                                );
                              }).catchError(
                                      (err) => print('Error update: $err'));
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //=================================================================================================================
  Widget TextRowIcon(IconEZ, title, value) {
    return Row(
      children: [
        FaIcon(
          IconEZ,
          color: const Color(0xFF30AE68),
          size: 25,
        ),
        const SizedBox(width: 5.0),
        Text(title, style: Roboto14_B_green),
        Text(value, style: Roboto14_black),
      ],
    );
  }
}
