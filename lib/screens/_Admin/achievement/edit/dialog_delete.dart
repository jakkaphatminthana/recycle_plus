import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/models/varidator.dart';
import 'package:recycle_plus/screens/_Admin/achievement/admin_achievement.dart';
import 'package:recycle_plus/screens/_Admin/mission/mission.dart';
import 'package:recycle_plus/screens/_User/exchange/detail/dialog_buy.dart';
import 'package:recycle_plus/screens/_User/profile/address/profile_address.dart';
import 'package:recycle_plus/screens/_User/profile/address/styleTextAddress.dart';
import 'package:recycle_plus/service/auth.dart';

showDialogAchiment_Delete({
  required BuildContext context,
  required String Achiment_ID,
}) {
//==================================================================================================================

  //TODO 1: Cancle Button
  Widget cancelButton(BuildContext context) {
    return FlatButton(
      child: Text("Cancel", style: Roboto16_B_gray),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  //TODO 2: Continute Button
  Widget continueButton(BuildContext context) {
    return FlatButton(
      child: Text("Delete", style: Roboto16_B_red),
      onPressed: ConfrimDelete(
        context: context,
        Achiment_ID: Achiment_ID,
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
//TODO : OnClick, Create Database on Firebase <<--------------------------------
GestureTapCallback ConfrimDelete({
  required BuildContext context,
  required Achiment_ID,
}) {
  return () async {
    //update firebase
    await db.deleteAchievement(achievement_ID: Achiment_ID).then((value) {
      print('delete mission');
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushReplacementNamed(
          context, Admin_AchievementScreen.routeName);
    }).catchError((err) => print('delete mission error: $err'));
  };
}
