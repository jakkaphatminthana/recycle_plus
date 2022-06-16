import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/components/wallet_card.dart';
import 'package:google_fonts/google_fonts.dart';

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
              Align(
                alignment: const AlignmentDirectional(0, 0),
                child: Padding(
                  padding: const EdgeInsets.only(top: 130.0),
                  child: Wallet_card,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 25.0,
          ),
          Column(
            children: [
              //TODO 3. Head สินค้าแนะนำ
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("สินค้าแนะนำ", style: Roboto16_B_black),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        "See more",
                        style: GoogleFonts.getFont(
                          'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5.0),

              //TODO 4. Product Recoment
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 7.0,),
                      Container(
                        width: 150,
                        height: 150,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 7.0,),
                      Container(
                        width: 150,
                        height: 150,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 7.0,),
                      Container(
                        width: 150,
                        height: 150,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 7.0,),
                      Container(
                        width: 150,
                        height: 150,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 7.0,),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
