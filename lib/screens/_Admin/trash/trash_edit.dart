import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:numberpicker/numberpicker.dart';

class Admin_TrashEdit extends StatefulWidget {
  //ก่อนจะเรียกหน้านี้จำเป็นต้องมี paramiter data
  const Admin_TrashEdit({required this.data});
  final data; //data Querysnapshot

  @override
  State<Admin_TrashEdit> createState() => _Admin_TrashEditState();
}

class _Admin_TrashEditState extends State<Admin_TrashEdit> {
  var num = 10;

  @override
  Widget build(BuildContext context) {
    //================================================================================================
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF389B61),
        automaticallyImplyLeading: true,
        elevation: 0.0,
        centerTitle: true,
      ),
      //----------------------------------------------------------------------------
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  //TODO 1. พื้นเขียว
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 250,
                    decoration: const BoxDecoration(
                      color: Color(0xFF389B61),
                    ),
                    child: Column(
                      children: [
                        //TODO 2. Image Type
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Image.asset(
                            "assets/image/pete_black.png",
                            width: 100,
                            height: 100,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            "โพลิเอทิลีนเทเรฟทาเลต",
                            style: Roboto16_black,
                          ),
                        ),
                      ],
                    ),
                  ),

                  //TODO 3. Container White
                  Padding(
                    padding: const EdgeInsets.only(top: 190.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEEEEEE),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 20.0),
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(color: Colors.grey),
                            child: NumberPicker(
                              value: num,
                              minValue: 00,
                              maxValue: 90,
                              step: 10,
                              haptics: true,
                              axis: Axis.horizontal,
                              onChanged: (value) => setState(() {
                                num = value;
                              }),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text("Current value : $num", style: Roboto16_B_black),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
