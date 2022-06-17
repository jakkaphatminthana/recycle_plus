import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ListTrash extends StatelessWidget {
  const ListTrash({
    Key? key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.token,
    required this.exp,
    required this.description,
    required this.press,
  }) : super(key: key);

  final String image;
  final String title;
  final String subtitle;
  final double token;
  final double exp;
  final String description;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        children: [
          //TODO 1. Container 1
          Container(
            width: MediaQuery.of(context).size.width * 0.95,
            height: 85,
            decoration: BoxDecoration(
              color: const Color(0xFFEEEEEE),
              border: Border.all(
                color: const Color.fromARGB(99, 84, 84, 84),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.80,
                  height: 84,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //TODO 1.1 Image Type
                        Image.network(
                          image,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 5.0),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10.0),

                            //TODO 1.2 Header Text Type
                            Row(
                              children: [
                                Text("$title : ", style: Roboto18_B_black),
                                Text(subtitle, style: Roboto16_black),
                              ],
                            ),
                            const SizedBox(height: 5.0),

                            Row(
                              children: [
                                //TODO 1.3 Token Earn
                                Image.asset(
                                  'assets/image/token.png',
                                  width: 25,
                                  height: 25,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(width: 5.0),
                                Text("$token", style: Roboto16_B_blue),
                                const SizedBox(width: 10.0),

                                //TODO 1.4 EXP Level
                                Image.asset(
                                  'assets/image/exp2.png',
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(width: 5.0),
                                Text("$exp XP.", style: Roboto16_B_green),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                //TODO 1.5 Icon Edit
                Container(
                  width: MediaQuery.of(context).size.width * 0.14,
                  height: 84,
                  alignment: const AlignmentDirectional(0, 0),
                  child: const FaIcon(
                    FontAwesomeIcons.solidEdit,
                    color: Color(0xFFE0AB3A),
                    size: 25,
                  ),
                ),
              ],
            ),
          ),

          //TODO 2. Container 2
          Material(
            elevation: 2,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                ),
              ),
              //TODO 2.1 ตัวอย่างขยะในประเภทนี้
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      description,
                      style: Roboto14_black,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
