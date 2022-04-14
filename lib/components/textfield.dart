import 'package:flutter/material.dart';

InputDecoration styleTextField(hintEZ, iconEZ) {
  return InputDecoration(
    isDense: true,
    hintText: hintEZ,
    enabledBorder: StyleBoder(Colors.black),  //ก่อนกดพิมพ์
    focusedBorder: StyleBoder(Colors.black),  //กดพิมพ์
    errorBorder: StyleBoder(Colors.red),  //แจ้ง Error
    focusedErrorBorder: StyleBoder(Colors.red), //พิมพ์หลังแจ้ง Error
    prefixIcon: Icon(
      iconEZ,
      size: 25,
    ),
  );
}

//================================================================================================
//TODO : ขอบเส้นของมัน
OutlineInputBorder StyleBoder(colorsEZ) => OutlineInputBorder(
  borderRadius: BorderRadius.circular(15),
  borderSide: BorderSide(
    color: colorsEZ,
    width: 2,
  ),
);