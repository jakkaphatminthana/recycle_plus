import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/components/wallet_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recycle_plus/screens/_NoLogin/exchange/card_product1.dart';
import 'package:recycle_plus/screens/_NoLogin/exchange/card_product2.dart';

class Member_ExchangeScreen extends StatefulWidget {
  const Member_ExchangeScreen({Key? key}) : super(key: key);

  //Location page
  static String routeName = "/Exchange";

  @override
  State<Member_ExchangeScreen> createState() => _Member_ExchangeScreenState();
}

class _Member_ExchangeScreenState extends State<Member_ExchangeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E9E9),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      //TODO 1. Banner Image
                      Image.asset(
                        "assets/image/banner_trash_cash.jpg",
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.21,
                        fit: BoxFit.cover,
                      ),

                      //TODO 2. Wallet
                      const Align(
                        alignment: AlignmentDirectional(0, 0),
                        child: Padding(
                          padding: EdgeInsets.only(top: 130.0),
                          child: Wallet_card(colorEZ: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25.0),
                  Column(
                    children: [
                      //TODO 3. Head สินค้าแนะนำ
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("สินค้าแนะนำ", style: Roboto16_B_black),
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
                      const SizedBox(height: 2.0),

                      //TODO 4. Product Recoment
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              CardProductHot(
                                name: "name",
                                image: "image",
                                token: "token",
                                press: () {},
                              ),
                              CardProductHot(
                                name: "name",
                                image: "image",
                                token: "token",
                                press: () {},
                              ),
                              CardProductHot(
                                name: "name",
                                image: "image",
                                token: "token",
                                press: () {},
                              ),
                              CardProductHot(
                                name: "name",
                                image: "image",
                                token: "token",
                                press: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),

                      //TODO 5. Head รายการสินค้า
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("รายการสินค้า", style: Roboto16_B_black),
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
                      const SizedBox(height: 7.0),

                      //TODO 6. Product List Normal
                      GridView(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 5,
                          mainAxisExtent: 210,
                        ),
                        children: [
                          CardProductBig(
                            name: "name",
                            image: "image",
                            token: "token",
                            press: () {},
                          ),
                          CardProductBig(
                            name: "name",
                            image: "image",
                            token: "token",
                            press: () {},
                          ),
                          CardProductBig(
                            name: "name",
                            image: "image",
                            token: "token",
                            press: () {},
                          ),
                          CardProductBig(
                            name: "name",
                            image: "image",
                            token: "token",
                            press: () {},
                          ),
                        ],
                      ),
                    ],
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
