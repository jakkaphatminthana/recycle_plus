import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/start/start.dart';

class PageTest1 extends StatelessWidget {
  const PageTest1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Align(
          alignment: const AlignmentDirectional(0, 0),
          child: Column(
            children: [
              const SizedBox(height: 15.0),
              Text("ข่าวสาร/บทความ", style: Roboto14_B_black),
              const SizedBox(height: 10.0),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100.0,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(width: 1),
                  ),
                  child: Image.network(
                    "https://picsum.photos/seed/50/600",
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
