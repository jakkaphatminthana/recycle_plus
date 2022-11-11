import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/models/varidator.dart';
import 'package:recycle_plus/screens/_Admin/achievement/admin_achievement.dart';
import 'package:recycle_plus/screens/_Admin/mission/mission.dart';
import 'package:recycle_plus/screens/_User/exchange/detail/dialog_buy.dart';
import 'package:recycle_plus/screens/_User/profile/address/profile_address.dart';
import 'package:recycle_plus/screens/_User/profile/address/styleTextAddress.dart';
import 'package:recycle_plus/service/auth.dart';

import '../admin_sponsor.dart';

final AuthService _auth = AuthService();

showDialogOTPEdit({
  required BuildContext context,
  required String otp_ID,
  required String company,
  required int money,
  image_file,
  image_path,
}) {
//==================================================================================================================

  //TODO 1: Cancle Button
  Widget cancelButton(BuildContext context) {
    return TextButton(
      child: Text("Cancel", style: Roboto16_B_gray),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  //TODO 2: Continute Button
  Widget continueButton(BuildContext context) {
    return TextButton(
      child: Text("Continue", style: Roboto16_B_green),
      onPressed: ConfrimEdit(
        context: context,
        otp_ID: otp_ID,
        company: company,
        money: money,
        image_file: image_file,
        image_path: image_path,
      ),
    );
  }

  //TODO 3.: Dialog input
  AlertDialog DialogInput = AlertDialog(
    title: Text("ยืนยันการแก้ไข", style: Roboto20_black),
    actions: [continueButton(context), cancelButton(context)],
    //TODO 3.2: Content Dialog
    content: Text('คุณต้องการแก้ไขข้อมูลนี้หรือไม่', style: Roboto16_black),
  );

  //TODO 4: ShowDialog
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) => DialogInput,
  );
}

//==================================================================================================================
//TODO : OnClick, Create Database on Firebase <<--------------------------------
GestureTapCallback ConfrimEdit({
  required BuildContext context,
  required String otp_ID,
  required String company,
  required int money,
  image_file,
  image_path,
}) {
  return () async {
    // print('image_file = $image_file');
    // print('image_path = $image_path');
    // print('value_company = $value_company');
    // print('value_money = $value_money');
    // print('--------------');

    //1.กรณีที่จะอัปโหลดรูปภาพด้วย
    if (image_file != null && image_path != null) {
      //TODO : uplode image at firestroge
      var image_url = await uploadImage(
        gallery: image_path,
        image: image_file,
        uid: otp_ID,
      );

      //TODO : UPDATE Database on Firebase
      await db
          .updateSponsor_admin(
        otp_ID: otp_ID,
        image: image_url,
        company: company,
        money: money,
      )
          .then((value) {
        print("update success");
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, Admin_SponsorManager.routeName);
      }).catchError((e) => print('error: $e'));
      //2.กรณีที่ไม่ต้องการอัปโหลดรูป
    } else {
      //TODO : UPDATE Database on Firebase
      await db
          .updateSponsor_admin(
        otp_ID: otp_ID,
        company: company,
        money: money,
      )
          .then((value) {
        print("update success");
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, Admin_SponsorManager.routeName);
      }).catchError((e) => print('error: $e'));
    }
  };
}

//TODO 1: อัพโหลด ภาพลงใน Storage ใน firebase
uploadImage({gallery, image, uid}) async {
  // กำหนด _storage ให้เก็บ FirebaseStorage (สโตเลท)
  final _storage = FirebaseStorage.instance;
  // เอา path ที่เราเลือกจากเครื่องมาเเปลงเป็น File เพื่อเอาไปอัพโหลดลงใน Storage ใน Firebase
  var file = File(gallery);
  // เช็คว่ามีภาพที่เลือกไหม
  if (image != null) {
    //Upload to Firebase
    var snapshot = await _storage
        .ref()
        .child("images/sponsor_logo/$uid") //แหล่งเก็บภาพนี้
        .putFile(file);
    //เอาลิ้ง url จากภาพที่เราได้อัปโหลดไป เอาออกมากเก็บไว้ใน downloadUrl
    var downloadURL = await snapshot.ref.getDownloadURL();
    //ส่ง URL ของรูปภาพที่อัพโหลดขึ้น stroge แล้วไปใช้ต่อ
    // print("downloadURL = ${downloadURL}");
    return downloadURL;
  } else {
    return Text("ไม่พบรูปภาพ");
  }
}
