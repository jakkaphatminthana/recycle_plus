import 'package:flutter/material.dart';

class Member_AchievementScreen extends StatefulWidget {
  const Member_AchievementScreen({Key? key}) : super(key: key);

  @override
  State<Member_AchievementScreen> createState() =>
      _Member_AchievementScreenState();
}

class _Member_AchievementScreenState extends State<Member_AchievementScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            children: [
              //Container 100% * 20%
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.2,
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/image/banner_honor.jpg',
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 1,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
