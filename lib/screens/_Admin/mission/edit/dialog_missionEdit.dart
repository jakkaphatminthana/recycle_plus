import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/models/varidator.dart';
import 'package:recycle_plus/screens/_Admin/mission/mission.dart';
import 'package:recycle_plus/screens/_User/exchange/detail/dialog_buy.dart';
import 'package:recycle_plus/screens/_User/profile/address/profile_address.dart';
import 'package:recycle_plus/screens/_User/profile/address/styleTextAddress.dart';
import 'package:recycle_plus/service/auth.dart';

final AuthService _auth = AuthService();

showDialogMissionEdit({
  required BuildContext context,
  required String mission_ID,
  required String missionType,
  required category,
  required title,
  required num_finish,
  required reward,
  required num_reward,
  required trash,
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
      child: Text("Continue", style: Roboto16_B_green),
      onPressed: ConfrimEdit(
        context: context,
        mission_ID: mission_ID,
        missionType: missionType,
        category: category,
        title: title,
        num_finish: num_finish,
        reward: reward,
        num_reward: num_reward,
        trash: trash,
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
  required mission_ID,
  required missionType,
  required category,
  required title,
  required num_finish,
  required reward,
  required num_reward,
  required trash,
}) {
  return () async {
    int int_finish = int.parse(num_finish);
    double double_reward = double.parse(num_reward);
    String isEmpty_trash = (trash == null) ? '' : trash;

    // print('value_category = $category');
    // print('value_title = $title');
    // print('value_num_finish = $num_finish');
    // print('value_reward = $reward');
    // print('value_num_reward = $num_reward');
    // print('value_trash = $isEmpty_trash');
    // print('--------------');

    //update firebase
    await db
        .updateMission(
      mission_ID: mission_ID,
      missionType: missionType,
      category: category,
      title: title,
      num_finish: int_finish,
      reward: reward,
      num_reward: double_reward,
      trash: isEmpty_trash,
    )
        .then((value) {
      print('update mission');
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, Admin_MissionScreen.routeName);
    }).catchError((err) => print('update mission error: $err'));
  };
}
