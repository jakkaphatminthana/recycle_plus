import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_Admin/sponsor/admin_sponsor.dart';
import 'package:recycle_plus/screens/_Admin/sponsor/bill/admin_bill.dart';
import 'package:recycle_plus/screens/_User/exchange/detail/dialog_buy.dart';

showDialogBill_Delete({
  required BuildContext context,
  required String bill_ID,
  fileURL,
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
        bill_ID: bill_ID,
        fileURL: fileURL,
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
DeleteFile(fileURL) async {
  //1.Delete image in Storage
  Reference fileRef = await FirebaseStorage.instance.refFromURL(fileURL);
  await fileRef.delete().then((value) {
    print("delete storage success");
  }).catchError((error) => print("delete storage faild: $error"));
}

//TODO : OnClick, Create Database on Firebase <<--------------------------------
GestureTapCallback ConfrimDelete({
  required BuildContext context,
  required String bill_ID,
  fileURL,
}) {
  return () async {
    if (fileURL != null) {
      //1.delete image
      await DeleteFile(fileURL);
      print('delete file storage');

      //2.update firebase
      await db.deleteBill_Sponsor(bill_ID: bill_ID).then((value) async {
        print('delete firebase');
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, Admin_BillScreen.routeName);
      });
    } else {
      await db.deleteBill_Sponsor(bill_ID: bill_ID).then((value) async {
        print('delete firebase');
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, Admin_BillScreen.routeName);
      });
    }
  };
}
