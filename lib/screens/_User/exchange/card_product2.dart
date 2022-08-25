import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';

class CardProductBig extends StatelessWidget {
  const CardProductBig({
    Key? key,
    required this.name,
    required this.image,
    required this.token,
    required this.press,
    required this.amount,
  }) : super(key: key);

  final String name;
  final String image;
  final String token;
  final String amount;
  final GestureTapCallback press;

  //TODO : สินค้า 1 ชิ้น
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      //TODO 1. กล่องพื้นที่หลัก
      child: Container(
        width: 150,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: const Color.fromARGB(64, 0, 0, 0),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //TODO : Area 1
            Container(
              width: MediaQuery.of(context).size.width,
              height: 170,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //TODO 2. Image Product
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 120,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Image.network(
                      image,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),

                  //TODO 3. Name Product
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                    child: Text(
                      (name.length > 45) ? name.substring(0, 45) + "..." : name,
                      style: Roboto14_B_black,
                    ),
                  ),
                ],
              ),
            ),

            //TODO 4. Token
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Price ด้านขวา
                  Row(
                    children: [
                      Image.asset(
                        "assets/image/token.png",
                        width: 22,
                        height: 22,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 5.0),

                      //TODO 5. ราคาสินค้า
                      Text(token, style: Roboto15_B_green),
                    ],
                  ),

                  //Amount ด้านซ้าย
                  Text("$amount ชิ้น", style: Roboto14_blue),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
