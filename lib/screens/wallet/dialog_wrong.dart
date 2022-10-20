import 'package:flutter/material.dart';

showDialogWalletWrong({required BuildContext context}) async {
  return await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            height: 280,
            width: MediaQuery.of(context).size.width * 0.85,
            decoration: BoxDecoration(
              color: const Color(0xFFfcfefc),
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        );
      });
}
