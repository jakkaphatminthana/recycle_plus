import 'package:flutter/material.dart';
import 'package:recycle_plus/font.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);
  //Location Route Page
  static String routeName = "/start";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            //TODO 1. Background
            Image.asset(
              'assets/image/bg-green1.jpg',
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 1,
              fit: BoxFit.cover,
            ),

            Align(
              alignment: const AlignmentDirectional(0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  //TODO 2. Header App
                  Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Text(
                      "Recycle+",
                      textAlign: TextAlign.center,
                      style: Russo64_B_black,
                    ),
                  ),
                  Text(
                    "เกมส์ขยะรีไซเคิล",
                    style: Roboto22_R_black,
                  ),

                  //TODO 3. LOGO Recycle+
                  Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: Image.asset(
                      "assets/image/logo.png",
                      width: 180,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 80.0),

                  //TODO 4. คำอธิบาย
                  Text(
                    "ร่วมช่วยกันสร้างเศรษกิจหมุนเวียน",
                    style: Roboto17_black,
                  ),
                  Text(
                    "ในขยะรีไซเคิล",
                    style: Roboto17_black,
                  ),
                  const SizedBox(height: 50.0),

                  //TODO 5. Button Start
                  ElevatedButton(
                    child: Text("START", style: Roboto20_B_white),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      fixedSize: const Size(200, 45),
                      side: const BorderSide(
                          width: 2.0, color: Colors.white), //ขอบ
                      elevation: 2.0, //เงา
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
