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

  @override
  Widget build(BuildContext context) {
    final token = widget.data!.get("token");

    List<String> token_split = token.split(".");
    final token_map = token_split.asMap();
    final token1 = token_map[0];
    final token2 = token_map[1];

    final token_double = double.parse(token);
    var token1_int = int.parse(token1!);
    var token2_int = int.parse(token2!);

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

                          ElevatedButton(
                            child: Text("print token value",
                                style: Roboto16_B_white),
                            onPressed: () {
                              print("token = ${token}");
                              print("token Type= ${token.runtimeType}");
                              print("token_map = ${token_map}");
                              print("token1_int = ${token1_int}");
                              print("token2_int = ${token2_int}");
                            },
                          ),
                          const SizedBox(height: 20.0),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              NumberPicker(
                                value: token1_int,
                                minValue: 0,
                                maxValue: 99,
                                step: 1,
                                itemHeight: 50,
                                axis: Axis.vertical,
                                onChanged: (value) =>
                                    setState(() => token1_int = value),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                        color: Colors.black, width: 2.0),
                                    bottom: BorderSide(
                                        color: Colors.black, width: 2.0),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20.0),
                              NumberPicker(
                                value: token2_int,
                                minValue: 0,
                                maxValue: 99,
                                step: 1,
                                itemHeight: 50,
                                axis: Axis.vertical,
                                onChanged: (value) =>
                                    setState(() => token2_int = value),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                        color: Colors.black, width: 2.0),
                                    bottom: BorderSide(
                                        color: Colors.black, width: 2.0),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Container(
                          //   width: 100,
                          //   height: 100,
                          //   decoration: BoxDecoration(color: Colors.grey),
                          //   child: NumberPicker(
                          //     value: num,
                          //     minValue: 00,
                          //     maxValue: 90,
                          //     step: 10,
                          //     haptics: true,
                          //     axis: Axis.horizontal,
                          //     onChanged: (value) => setState(() {
                          //       num = value;
                          //     }),
                          //   ),
                          // ),
                          // const SizedBox(height: 10.0),
                          // Text("Current value : $num", style: Roboto16_B_black),
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
