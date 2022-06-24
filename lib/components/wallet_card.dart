import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';

class Wallet_card extends StatelessWidget {
  const Wallet_card({Key? key, required this.colorEZ}) : super(key: key);

  final Color colorEZ;
  
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Container(
        width: 300,
        height: 70,
        decoration: BoxDecoration(
            color: colorEZ,
            borderRadius: BorderRadius.circular(15.0),
            shape: BoxShape.rectangle,
            border: Border.all(color: Colors.black, width: 1.0)),
        child: Row(
          children: [
            //TODO 1. Token image
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Image.asset(
                "assets/image/token.png",
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),

            //TODO 2. Text Wallet
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "MyWallet",
                  textAlign: TextAlign.start,
                  style: Roboto16_B_black,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    'แต้มสะสมของฉัน',
                    textAlign: TextAlign.start,
                    style: Roboto12_B_black,
                  ),
                ),
              ],
            ),

            //TODO 3. Token Amount
            Expanded(
              child: Align(
                alignment: const AlignmentDirectional(0.2, 0),
                child: Text(
                  "1000",
                  style: Roboto16_B_black,
                ),
              ),
            ),

            //TODO 4. arrow icon
            const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
