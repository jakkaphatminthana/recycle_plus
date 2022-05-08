import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';

//TODO : TextField Normal
InputDecoration styleSearchbar(hintEZ) {
  return InputDecoration(
    isDense: true,
    hintText: hintEZ,
    hintStyle: Roboto16_white,
    //enabledBorder: StyleBoder(Colors.black, 15.0),  //ก่อนกดพิมพ์
    //focusedBorder: StyleBoder(Colors.black, 15.0),  //กดพิมพ์
    //errorBorder: StyleBoder(Colors.red, 15.0),  //แจ้ง Error
    //focusedErrorBorder: StyleBoder(Colors.red, 15.0), //พิมพ์หลังแจ้ง Error
  );
}

//=======================================================================================================
//TODO : ขอบเส้น ธรรมดา
// UnderlineInputBorder StyleInput() => UnderlineInputBorder();

// InputDecoration StyleInput2() => InputDecoration(

// );

// OutlineInputBorder StyleBoder(colorsEZ, radius) => OutlineInputBorder(
//       borderRadius: BorderRadius.circular(radius),
//       borderSide: BorderSide(
//         color: colorsEZ,
//         width: 2,
//       ),
//     );
