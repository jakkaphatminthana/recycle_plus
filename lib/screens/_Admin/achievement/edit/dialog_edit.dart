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

final AuthService _auth = AuthService();

showDialogAchimentEdit({
  required BuildContext context,
  required String Achiment_ID,
  required String category,
  required title,
  required num_finish,
  required description,
  required trash,
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
        Achiment_ID: Achiment_ID,
        category: category,
        title: title,
        num_finish: num_finish,
        description: description,
        trash: trash,
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
  required String Achiment_ID,
  required String category,
  required title,
  required num_finish,
  required description,
  required trash,
  image_file,
  image_path,
}) {
  return () async {
    int int_finish = int.parse(num_finish);
    String isEmpty_trash = (trash == null) ? '' : trash;

    // print('image_file = $image_file');
    // print('image_path = $image_path');
    // print('value_category = $category');
    // print('value_title = $title');
    // print('value_num_finish = $num_finish');
    // print('value_Achiment_ID = $Achiment_ID');
    // print('value_description = $description');
    // print('value_trash = $isEmpty_trash');
    // print('--------------');

    //1.กรณีที่จะอัปโหลดรูปภาพด้วย
    if (image_file != null && image_path != null) {
      //TODO : uplode image at firestroge
      var image_url = await uploadImage(
        gallery: image_path,
        image: image_file,
        uid: Achiment_ID,
      );

      //TODO : UPDATE Database on Firebase
      await db
          .updateAchievement(
        Achiment_ID: Achiment_ID,
        category: category,
        title: title,
        num_finish: int_finish,
        description: description,
        trash: isEmpty_trash,
        image_new: image_url,
      )
          .then((value) {
        print('update success');
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushReplacementNamed(
            context, Admin_AchievementScreen.routeName);
      }).catchError((err) => print('update error: $err'));
      //2.กรณีที่ไม่ต้องการอัปโหลดรูป
    } else {
      //TODO : UPDATE Database on Firebase
      await db
          .updateAchievement(
        Achiment_ID: Achiment_ID,
        category: category,
        title: title,
        num_finish: int_finish,
        description: description,
        trash: isEmpty_trash,
      )
          .then((value) {
        print('update success');
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushReplacementNamed(
            context, Admin_AchievementScreen.routeName);
      }).catchError((err) => print('update error: $err'));
    }
  };
}

//TODO : อัพโหลด ภาพลงใน Storage ใน firebase
uploadImage({gallery, image, img_name, uid}) async {
  // กำหนด _storage ให้เก็บ FirebaseStorage (สโตเลท)
  final _storage = FirebaseStorage.instance;
  // เอา path ที่เราเลือกจากเครื่องมาเเปลงเป็น File เพื่อเอาไปอัพโหลดลงใน Storage ใน Firebase
  var file = File(gallery);
  // เช็คว่ามีภาพที่เลือกไหม
  if (image != null) {
    //Upload to Firebase
    var snapshot = await _storage
        .ref()
        .child("images/achievements/$uid") //แหล่งเก็บภาพนี้
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
