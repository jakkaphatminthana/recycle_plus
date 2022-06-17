import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:recycle_plus/screens/_Admin/trash/np_trash.dart';

class Admin_TrashEdit extends StatefulWidget {
  //ก่อนจะเรียกหน้านี้จำเป็นต้องมี paramiter data
  const Admin_TrashEdit({
    required this.id_trash,
    required this.image,
    required this.subtitle,
    required this.token1,
    required this.token2,
    required this.exp1,
    required this.exp2,
  });
  //data Querysnapshot
  final String id_trash;
  final String image;
  final String subtitle;
  final token1;
  final token2;
  final exp1;
  final exp2;

  @override
  State<Admin_TrashEdit> createState() => _Admin_TrashEditState();
}

class _Admin_TrashEditState extends State<Admin_TrashEdit> {
  @override
  Widget build(BuildContext context) {
    //================================================================================================
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF389B61),
        automaticallyImplyLeading: true,
        elevation: 0.0,
        centerTitle: true,
        title: Text("ปรับผลตอบแทน", style: Roboto16_B_white),
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
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Image.network(
                            widget.image,
                            width: 100,
                            height: 100,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            widget.subtitle,
                            style: Roboto16_white,
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
                      height: MediaQuery.of(context).size.height * 0.6,
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
                          //TODO 4. Tabbar Menu
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: DefaultTabController(
                                length: 2,
                                initialIndex: 0,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 45,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(
                                          25.0,
                                        ),
                                      ),
                                      child: TabBar(
                                        indicator: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                          color: const Color(0xFF389B61),
                                        ),
                                        labelColor: Colors.white,
                                        unselectedLabelColor: Colors.black,
                                        tabs: [
                                          //TODO 4.1 Tabbar Token
                                          Tab(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "assets/image/token.png",
                                                  width: 30,
                                                  height: 30,
                                                  fit: BoxFit.cover,
                                                ),
                                                const SizedBox(width: 5.0),
                                                Text(
                                                  "Token",
                                                  style: Roboto20_B_white,
                                                ),
                                              ],
                                            ),
                                          ),

                                          //TODO 4.2 Tabbar Token
                                          Tab(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "assets/image/exp2.png",
                                                  width: 28,
                                                  height: 28,
                                                  fit: BoxFit.cover,
                                                ),
                                                const SizedBox(width: 5.0),
                                                Text(
                                                  "Experience",
                                                  style: Roboto20_B_white,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    //TODO 5. Tabbar View
                                    Expanded(
                                      child: TabBarView(
                                        children: [
                                          Column(
                                            children: [
                                              const SizedBox(height: 40.0),
                                              PickNumber(
                                                id_trash: widget.id_trash,
                                                title: "Token Rate",
                                                number1: widget.token1,
                                                number2: widget.token2,
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              const SizedBox(height: 40.0),
                                              PickNumber(
                                                id_trash: widget.id_trash,
                                                title: "EXP Rate",
                                                number1: widget.exp1,
                                                number2: widget.exp2,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
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
