import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';

class List_TrashRate extends StatefulWidget {
  const List_TrashRate({
    Key? key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.nature,
    required this.token,
    required this.exp,
  }) : super(key: key);

  final String image;
  final String title;
  final String subtitle;
  final String nature;
  final String token;
  final String exp;

  @override
  State<List_TrashRate> createState() => _List_TrashRateState();
}

class _List_TrashRateState extends State<List_TrashRate> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //TODO 4. รายละเอียดขยะ
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //TODO : Image Logo
              Image.network(
                widget.image,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 10.0),

              //TODO : Text Desciption
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(widget.title, style: Roboto18_B_black),
                      Text(widget.subtitle, style: Roboto14_B_black),
                    ],
                  ),
                  Row(
                    children: [
                      //พื้นที่ขยายได้
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: 80,
                          maxWidth: MediaQuery.of(context).size.width * 0.67,
                        ),
                        child: Text(
                          widget.nature,
                          style: Roboto14_black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        //TODO : Rate Earn and Exp
        Padding(
          padding: const EdgeInsets.fromLTRB(100, 5, 0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Reward/item", style: Roboto14_B_black),
              const SizedBox(height: 3.0),
              Container(
                width: 250,
                height: 35,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEEEEE),
                  border: Border.all(
                    width: 1,
                  ),
                ),
                //TODO : Show Rate from firebase
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Token Earn
                      Image.asset(
                        "assets/image/token.png",
                        width: 25,
                        height: 25,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 5.0),
                      Text(widget.token, style: Roboto16_B_green),
                      const SizedBox(width: 10.0),

                      //EXP Earn
                      Image.asset(
                        "assets/image/exp2.png",
                        width: 20,
                        height: 20,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 5.0),
                      Text("${widget.exp} XP.", style: Roboto16_B_green),
                      const SizedBox(width: 10.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
