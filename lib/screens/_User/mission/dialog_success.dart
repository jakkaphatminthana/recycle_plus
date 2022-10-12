import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_User/exchange/detail/dialog_buy.dart';
import 'package:recycle_plus/screens/_User/tabbar_control.dart';

showDialogMissionSuccess({
  required BuildContext context,
  required user_ID,
  required mission_ID,
  required mission_type,
  required user_loginDaily,
}) async {
  bool onCLick = false;

  //TODO : important for login everyday
  String mission_login = 'bAlVt6qw8b52VuQonLTM';

  DateTime now = DateTime.now();
  String dateNow = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String timeScale =
      "${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)))},${DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: DateTime.daysPerWeek - DateTime.now().weekday)))}";

  //============================================================================================================
  return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Container(
              height: 320,
              width: MediaQuery.of(context).size.width * 0.85,
              decoration: BoxDecoration(
                color: const Color(0xFFfcfefc),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/image/timeing2.gif",
                      width: 150,
                      height: 150,
                    ),
                    Text("Success!", style: Roboto20_B_black),
                    const SizedBox(height: 8.0),
                    const Text("กำลังทำรายการอาจใช้เวลา 1 นาที"),
                    const Text("ระหว่างนี้ท่านสามารถออกไปทำอย่างอื่นได้เลย"),
                    const SizedBox(height: 8.0),
                    RaisedButton(
                      child: const Text("ตกลง"),
                      onPressed: onCLick
                          ? null
                          : () {
                              onCLick = true;

                              //TODO 1: Upload to Firebase <--------------------------------
                              db
                                  .createMissionOrder(
                                typeMission: mission_type,
                                mission_ID: mission_ID,
                                user_ID: user_ID,
                                timescale:
                                    (mission_type == 'day') ? dateNow : timeScale,
                              )
                                  .then((value) async {
                                print('add success');

                                //TODO 2: Update Login Day to Firebsae <--------------------
                                (mission_ID == mission_login)
                                    ? await db
                                        .updateLoginUser(
                                          user_ID: user_ID,
                                          CurLogin: user_loginDaily,
                                        )
                                        .then((value) => print('add login success'))
                                    : null;
                              }).catchError((err) => print('misison error: $err'));
                            },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      });
}
//========================================================================================

//TODO : Dialog
