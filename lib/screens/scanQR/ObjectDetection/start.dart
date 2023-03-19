import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:recycle_plus/components/font.dart';

import 'object_detection.dart';

class StratAiMode extends StatefulWidget {
  const StratAiMode({Key? key}) : super(key: key);

  @override
  State<StratAiMode> createState() => _StratAiModeState();
}

class _StratAiModeState extends State<StratAiMode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF107027),
        automaticallyImplyLeading: true,
        title: const Text("Object Detection Demo"),
        centerTitle: true,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 30.0),
            Column(
              children: [
                Image.asset(
                  "assets/image/obj.png",
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 20.0),
                Text("ระบบตรวจจับวัตถุ (รุ่นทดสอบ)", style: Roboto18_B_black),
                const SizedBox(height: 8.0),
                Text("ระบบตรวจจับวัตถุผ่านกล้องมือถือนี้เป็นรุ่นทดลอง",
                    style: Roboto14_black),
                Text("โดยมีวัตุประสงค์คือใช้ทดสอบความสามารถของระบบ",
                    style: Roboto14_black),
                Text("ซึ่งไม่มีผลกระทบใดๆ ภายในแอปพลิเคชัน",
                    style: Roboto14_black),
                Text("", style: Roboto14_black),
                const SizedBox(height: 60.0),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ObjectDetectionScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF107027),
                    fixedSize: const Size(320, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
