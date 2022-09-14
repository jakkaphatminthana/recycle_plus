import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ListProduct extends StatelessWidget {
  const ListProduct({
    Key? key,
    required this.imageURL,
    required this.title,
    required this.subtitle,
    required this.token,
    required this.amount,
    required this.press,
    required this.category,
  }) : super(key: key);

  final String imageURL;
  final String title;
  final String subtitle;
  final String token;
  final String amount;
  final String category;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 8, 5, 0),
      child: GestureDetector(
        onTap: press,
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
            height: 95,
            decoration: BoxDecoration(
              //กรณีสินค้าหมด
              color: (amount == '0')
                  ? const Color(0xFFB0B0B0)
                  : const Color(0xFFEEEEEE),
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
            //TODO 1. เนื้อหาในกล่อง Container
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  //TODO 2. Container 85%
                  Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: MediaQuery.of(context).size.height,
                    child: Row(
                      children: [
                        //TODO 2.1 Image Product
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
                              imageURL,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        //TODO 2.3 Title name product
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //TEXT title
                              Text(
                                (title.length > 25)
                                    ? title.substring(0, 25) + "..."
                                    : title,
                                style: (amount == '0')
                                    ? Roboto16_B_black
                                    : Roboto16_B_greenB,
                              ),
                              Text(
                                (subtitle.length > 30)
                                    ? subtitle.substring(0, 30) + "..."
                                    : subtitle,
                                style: Roboto14_black,
                              ),
                              const SizedBox(height: 7.0),

                              //TODO 2.4 Amout and Price
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  //Token Price
                                  Row(
                                    children: [
                                      Image.asset(
                                        "assets/image/token.png",
                                        width: 25,
                                        height: 25,
                                        fit: BoxFit.cover,
                                      ),
                                      const SizedBox(width: 5.0),
                                      Text(token, style: Roboto16_B_black),
                                    ],
                                  ),
                                  const SizedBox(width: 10.0),

                                  //Amount product
                                  Row(
                                    children: [
                                      const FaIcon(
                                        FontAwesomeIcons.box,
                                        color: Color(0xFF2975C0),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 5.0),
                                      (amount == '0')
                                          ? Text(
                                              "สินค้าหมด",
                                              style: Roboto16_B_redM,
                                            )
                                          : Text(
                                              amount,
                                              style: Roboto16_B_blue,
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  //TODO 3. Container 8%
                  Container(
                    width: MediaQuery.of(context).size.width * 0.08,
                    height: MediaQuery.of(context).size.height * 1,
                    child: (category == "Limited")
                        ? const Icon(
                            Icons.star_rounded,
                            size: 30,
                            color: Colors.black,
                          )
                        : const Icon(
                            Icons.panorama,
                            size: 25,
                            color: Colors.black,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
