import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recycle_plus/components/font.dart';

class Admin_Exchange extends StatefulWidget {
  const Admin_Exchange({Key? key}) : super(key: key);

  @override
  State<Admin_Exchange> createState() => _Admin_ExchangeState();
}

class _Admin_ExchangeState extends State<Admin_Exchange> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //TODO 1. Order Button
                        ElevatedButton.icon(
                          icon: const FaIcon(Icons.timelapse_sharp, size: 25),
                          label: Text("รอดำเนินการ", style: Roboto16_B_white),
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(170, 40),
                            primary: const Color(0xFF25BA67),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: () {},
                        ),

                        //TODO 2. Order Button
                        ElevatedButton.icon(
                          icon: const FaIcon(
                            Icons.history,
                            size: 25,
                          ),
                          label: Text("ประวัติ", style: Roboto16_B_white),
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(170, 40),
                            primary: const Color(0xFFFEAF6C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),

                    //TODO 3. Text Head
                    Text("รายการของรางวัล", style: Roboto18_B_black),
                    const SizedBox(height: 20.0),

                    //TODO 4. Head สินค้าล่าสุด
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEEEEEE),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("สินค้าล่าสุด", style: Roboto16_B_black),
                            GestureDetector(
                              onTap: () {},
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("See more", style: Roboto16_B_green),
                                  const Icon(
                                    Icons.keyboard_arrow_right_rounded,
                                    color: Colors.green,
                                    size: 30,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //TODO 5. List Product
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 8, 5, 0),
                      child: Material(
                        //เงา
                        color: Colors.transparent,
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Container(
                          //กล่องใส่เนื้อหา
                          width: MediaQuery.of(context).size.width,
                          height: 90,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEEEEE),
                            boxShadow: const [
                              BoxShadow(
                                //กำหนดเงา
                                color: Color(0x7F000000),
                                offset: Offset(1, 1.5),
                              )
                            ],
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: const Color(0xB29F9F9F),
                              width: 1,
                            ),
                          ),
                          //TODO 5.1 เนื้อหาในกล่อง Container
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                //TODO 5.2 Image Product
                                Container(
                                  width: 90,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEEEEEE),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.network(
                                      'https://picsum.photos/seed/159/600',
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                
                                //TODO 5.3 Title name product
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                                  child: Column(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      //TODO : ปุ่มกดมุมขวาล่าง
      floatingActionButton: buildFloatingButton(),
    );
  }

  //================================================================================================
  //TODO : Action Add News
  Widget buildFloatingButton() => FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFF00883C),
        onPressed: () {},
      );
}
