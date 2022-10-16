import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_User/achievement/achievement.dart';
import 'package:recycle_plus/screens/_User/tabbar_control.dart';
import 'package:recycle_plus/service/database.dart';

User? user = FirebaseAuth.instance.currentUser;
DatabaseEZ db = DatabaseEZ.instance;

void showDialogLoading({
  required BuildContext context,
  required achiment_ID,
  required user_ID,
}) async {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          height: 150,
          width: MediaQuery.of(context).size.width * 0.60,
          decoration: BoxDecoration(
            color: const Color(0xFFfcfefc),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: const [
                SpinKitRing(
                  color: Colors.green,
                  size: 40.0,
                ),
                SizedBox(height: 10.0),
                Text('Loading...'),
              ],
            ),
          ),
        ),
      );
    },
  );

  //TODO 1: Create Claim Achievement Firebase -------------------<<<<
  await db
      .createAchievementOrder(
    achiment_ID: achiment_ID,
    user_ID: user!.uid,
  )
      .then((value) async {
    print('claim success');
    //TODO 2: Update Honor amounts  ----------------------------<<<<
    await db
        .updateHonorAmount(
      user_ID: user!.uid,
      amounts: 1,
    )
        .then((value) {
      print('honor success');
      Navigator.of(context).pop();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Member_TabbarHome(3)),
      );
    }).catchError((e) => print('honor error: $e'));
  }).catchError((e) => print('cliam error: $e'));
}
