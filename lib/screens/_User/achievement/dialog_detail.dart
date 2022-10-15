import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';

showDialogAchiDetail(
    {required BuildContext context,
    required image,
    required title,
    required detail,
    required description,
    required}) async {
  return await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
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
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //TODO 1: Name
                Text(title, style: Roboto20_B_green),
                const SizedBox(height: 15.0),

                //TODO 2: Image
                Image.network(image, width: 130, height: 130),
                const SizedBox(height: 15.0),

                //TODD 3: Detail
                Text(detail, style: Roboto16_B_black),
                const SizedBox(height: 5.0),
                Text(
                  description,
                  style: Roboto14_black,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
