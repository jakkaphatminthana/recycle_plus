import 'dart:ffi';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/models/varidator.dart';
import 'package:recycle_plus/screens/_Admin/achievement/admin_achievement.dart';
import 'package:recycle_plus/screens/_Admin/mission/mission.dart';
import 'package:recycle_plus/screens/_Admin/sponsor/admin_sponsor.dart';
import 'package:recycle_plus/screens/_User/exchange/detail/dialog_buy.dart';
import 'package:recycle_plus/screens/_User/profile/address/profile_address.dart';
import 'package:recycle_plus/screens/_User/profile/address/styleTextAddress.dart';
import 'package:recycle_plus/service/auth.dart';

showDialogOTP_Delete({
  required BuildContext context,
  required String otp_ID,
  image,
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
      child: Text("Delete", style: Roboto16_B_red),
      onPressed: ConfrimDelete(
        context: context,
        otp_ID: otp_ID,
      ),
    );
  }

  //TODO 3.: Dialog input
  AlertDialog DialogInput = AlertDialog(
    title: Text("ยืนยันการลบข้อมูล", style: Roboto20_black),
    actions: [continueButton(context), cancelButton(context)],
    //TODO 3.2: Content Dialog
    content: Text('คุณต้องการลบข้อมูลนี้หรือไม่', style: Roboto16_black),
  );

  //TODO 4: ShowDialog
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) => DialogInput,
  );
}

//==================================================================================================================
//TODO : Delete Storage and Firebase
DeleteImage(imgURL) async {
  //1.Delete image in Storage
  Reference photoRef = await FirebaseStorage.instance.refFromURL(imgURL);
  await photoRef.delete().then((value) {
    print("delete storage success");
  }).catchError((error) => print("delete storage faild: $error"));
}

//TODO : OnClick, Create Database on Firebase <<--------------------------------
GestureTapCallback ConfrimDelete({
  required BuildContext context,
  required String otp_ID,
  image,
}) {
  return () async {
    if (image != null) {
      //1.delete image
      await DeleteImage(image);
      print('delete image');

      //2.update firebase
      await db.deleteOTP_Sponsor(otp_ID: otp_ID).then((value) async {
        print('delete firebase');
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, Admin_SponsorManager.routeName);
      });
    } else {
      await db.deleteOTP_Sponsor(otp_ID: otp_ID).then((value) async {
        print('delete firebase');
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, Admin_SponsorManager.routeName);
      });
    }
  };
}
