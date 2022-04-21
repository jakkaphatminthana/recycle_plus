import 'package:flutter/material.dart';

//TODO : TextField Normal
InputDecoration styleTextField(hintEZ, iconEZ) {
  return InputDecoration(
    isDense: true,
    hintText: hintEZ,
    enabledBorder: StyleBoder(Colors.black, 15.0),  //ก่อนกดพิมพ์
    focusedBorder: StyleBoder(Colors.black, 15.0),  //กดพิมพ์
    errorBorder: StyleBoder(Colors.red, 15.0),  //แจ้ง Error
    focusedErrorBorder: StyleBoder(Colors.red, 15.0), //พิมพ์หลังแจ้ง Error
    prefixIcon: Icon(
      iconEZ,
      size: 25,
    ),
  );
}

//TODO : TextField แบบมน30
InputDecoration styleTextField_Radius30(hintEZ) {
  return InputDecoration(
    isDense: true,
    hintText: hintEZ,
    contentPadding: const EdgeInsets.all(15.0),
    enabledBorder: StyleBoder(Colors.black, 30.0),  //ก่อนกดพิมพ์
    focusedBorder: StyleBoder(Colors.black, 30.0),  //กดพิมพ์
    errorBorder: StyleBoder(Colors.red, 30.0),  //แจ้ง Error
    focusedErrorBorder: StyleBoder(Colors.red, 30.0), //พิมพ์หลังแจ้ง Error
  );
}

//================================================================================================
//TODO : ขอบเส้น ธรรมดา
OutlineInputBorder StyleBoder(colorsEZ, radius) => OutlineInputBorder(
  borderRadius: BorderRadius.circular(radius),
  borderSide: BorderSide(
    color: colorsEZ,
    width: 2,
  ),
);
