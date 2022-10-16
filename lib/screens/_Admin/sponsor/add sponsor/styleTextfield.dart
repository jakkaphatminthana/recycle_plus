import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';

//TODO : TextField Normal
InputDecoration styleTextFieldSponsor(labelEZ, hintEZ) {
  return InputDecoration(
    isDense: true,
    hintText: hintEZ,
    labelText: labelEZ,
    labelStyle: Roboto20_B_green,
    contentPadding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
    enabledBorder: StyleBoder(Colors.black), //ก่อนกดพิมพ์
    focusedBorder: StyleBoder(Colors.black), //กดพิมพ์
    errorBorder: StyleBoder(Colors.red), //แจ้ง Error
    focusedErrorBorder: StyleBoder(Colors.red), //พิมพ์หลังแจ้ง Error
    floatingLabelBehavior: FloatingLabelBehavior.always,
    counterText: '',
  );
}

//================================================================================================
//TODO : ขอบเส้น ธรรมดา
OutlineInputBorder StyleBoder(colorsEZ) => OutlineInputBorder(
      borderSide: BorderSide(
        color: colorsEZ,
        width: 1,
      ),
    );
