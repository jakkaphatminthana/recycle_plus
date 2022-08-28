import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/service/auth.dart';
import 'package:recycle_plus/service/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//db = ติดต่อ firebase
//_auth = ติดต่อกับ auth
DatabaseEZ db = DatabaseEZ.instance;
AuthService _auth = AuthService();
User? user = FirebaseAuth.instance.currentUser;

//===================================================================================================================
showAlertDialog_Buy({
  required BuildContext context,
  required String price,
}) {
  //TODO : Cancle Button
  Widget cancelButton(BuildContext context) {
    return FlatButton(
      child: Text("ยกเลิก", style: Roboto16_B_gray),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

//TODO : Continute Button
  Widget continueButton(BuildContext context) {
    return FlatButton(
      child: Text("ยืนยัน", style: Roboto16_B_green),
      onPressed: () {},
    );
  }

  //TODO : ShowDialog
  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text("ยืนยันการแลกของรางวัล", style: Roboto18_B_black),
      actions: [continueButton(context), cancelButton(context)],
      //TODO : Cotent Dialog
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("คุณต้องการจะแลกของรางวัลนี้ กับแต้มสะสมของคุณหรือไม่?"),
          Row(
            children: [
              Text("แต้มที่ใช้แลกเปลี่ยน: ", style: Roboto14_B_black),
              const SizedBox(width: 5.0),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(price, style: Roboto14_B_red),
              ),
            ],
          ),
        ],
      ),
    ),
  );
//===================================================================================================================
  Future Order_buy(data_product, user) async {
    
  }
}
