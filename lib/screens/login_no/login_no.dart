import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PleaseLogin extends StatelessWidget {
  const PleaseLogin({Key? key}) : super(key: key);
  //Location Page
  static String routeName = "/please_login";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            //TODO 1. Background
            Image.asset(
              "assets/image/bg-green2.jpg",
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 1,
              fit: BoxFit.cover,
            ),

            //TODO 2. BackPage
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 90, 0, 0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const FaIcon(
                  FontAwesomeIcons.arrowCircleLeft,
                  color: Color(0xFF00883C),
                  size: 30.0,
                ),
              ),
            ),

            Align(
              alignment: const AlignmentDirectional(0, 0),
              child: Padding(
                padding: const EdgeInsets.only(top: 110),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //TODO 3. Header
                    Image.asset(
                      "assets/image/logo.png",
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 10.0),

                    Text(
                      "โปรดทำการเข้าสู่ระบบ",
                      style: Roboto20_B_black,
                    ),
                    const SizedBox(height: 25.0),

                    //TODO 4. Image Verify
                    Image.asset(
                      "assets/image/verified-concept.png",
                      width: 270,
                      height: 270,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 40.0),

                    //TODO 5. Subtitle Text
                    Text(
                      "เพื่อที่คุณจะสามารถ",
                      style: Roboto16_black,
                    ),
                    Text(
                      "เข้าถึงบริการของเราได้อย่างเต็มที่",
                      style: Roboto16_black,
                    ),
                    const SizedBox(height: 30.0),

                    //TODO 6. Button LOGIN
                    ElevatedButton(
                      child: Text("LOGIN", style: Roboto20_B_white),
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
            ),
          ],
        ),
      ),
    );
  }
}
