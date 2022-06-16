import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:numberpicker/numberpicker.dart';

class PickNumber extends StatefulWidget {
  PickNumber({
    Key? key,
    required this.number1,
    required this.number2,
    required this.title,
  }) : super(key: key);

  var number1;
  var number2;
  final String title;

  @override
  State<PickNumber> createState() => _PickNumberState();
}

class _PickNumberState extends State<PickNumber> {
  //นำมารับค่าแทนซึ่งใช้ใน numberpiker เพราะ แก้บัคตัวเลขไม่ขยับ
  var num1;
  var num2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    num1 = widget.number1;
    num2 = widget.number2;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //TODO 1. Head Total
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("${widget.title} : ", style: Roboto16_B_black),
            const SizedBox(width: 5.0),
            Text("$num1.$num2", style: Roboto16_B_green),
          ],
        ),
        const SizedBox(height: 10.0),

        //TODO 2. Number view score
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //TODO : NumberPick 1
            NumberPicker(
              value: (num1 != null) ? num1 : widget.number1,
              minValue: 0,
              maxValue: 99,
              step: 1,
              itemHeight: 50,
              axis: Axis.vertical,
              selectedTextStyle: Roboto20_B_green,
              onChanged: (value) {
                setState(() {
                  num1 = value;
                });
              },
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFF389B61), width: 2.0),
                  bottom: BorderSide(color: Color(0xFF389B61), width: 2.0),
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            Text(".", style: Roboto30_B_black),
            const SizedBox(width: 10.0),

            //TODO : NumberPick 2
            NumberPicker(
              value: (num2 != null) ? num2 : widget.number2,
              minValue: 0,
              maxValue: 95,
              step: 5,
              itemHeight: 50,
              axis: Axis.vertical,
              selectedTextStyle: Roboto20_B_green,
              onChanged: (value) {
                setState(() {
                  num2 = value;
                });
              },
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFF389B61), width: 2.0),
                  bottom: BorderSide(color: Color(0xFF389B61), width: 2.0),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 30.0),

        //TODO 3. Button Save
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: const Color(0xFF389B61),
            fixedSize: const Size(300, 50),
            side: const BorderSide(width: 2.0, color: Colors.white), //ขอบ
            elevation: 2.0, //เงา
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          child: Text("SAVE", style: Roboto18_B_white),
          onPressed: () {},
        ),
      ],
    );
  }
}
