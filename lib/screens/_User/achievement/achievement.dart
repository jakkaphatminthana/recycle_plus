import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_User/achievement/card_honor.dart';

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
        //Container 100% * 22%
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.22,
          child: Stack(
            children: [
              //TODO 1: Background Banner
              Image.asset(
                'assets/image/banner_honor.jpg',
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 1,
                fit: BoxFit.cover,
              ),

              Row(
                children: [
                  ////Container 65%
                  Container(
                    width: MediaQuery.of(context).size.width * 0.65,
                    height: MediaQuery.of(context).size.height * 1,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //TODO 2: Text title
                          Text('MY HONOR', style: Roboto20_B_white),
                          const SizedBox(height: 5.0),
                          Text(
                            'Success is consistency',
                            style: Roboto12_B_white,
                          ),
                          const SizedBox(height: 5.0),
                          const Divider(
                            height: 1,
                            thickness: 2,
                            endIndent: 50,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 10.0),

                          //TODO 3: Conclusion Icon
                          Row(
                            children: [
                              bannerIcon(
                                image: 'assets/image/medal.png',
                                value: 10,
                              ),
                              bannerIcon(
                                image: 'assets/image/calendar.png',
                                value: 7,
                              ),
                              bannerIcon(
                                image: 'assets/image/garbage.png',
                                value: 135,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  //TODO 4: Medal Green
                  Image.asset(
                    'assets/image/medal_green.png',
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ],
              )
            ],
          ),
        ),

        //TODO 5: GridView
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              children: const [
                CardHonor(
                  title: "Day and Night",
                  image:
                      'https://cdn-icons-png.flaticon.com/512/3751/3751403.png',
                  num_now: 7,
                  num_finish: 14,
                  status: false,
                ),
                CardHonor(
                  title: "Nature lovers",
                  image:
                      'https://cdn-icons-png.flaticon.com/512/2707/2707277.png',
                  num_now: 135,
                  num_finish: 200,
                  status: false,
                ),
                CardHonor(
                  title: "Shopper",
                  image:
                      'https://cdn-icons-png.flaticon.com/512/2707/2707251.png',
                  num_now: 1200,
                  num_finish: 20000,
                  status: false,
                ),
                CardHonor(
                  title: "Fully recycle",
                  image:
                      'https://cdn-icons-png.flaticon.com/512/2707/2707275.png',
                  num_now: 135,
                  num_finish: 500,
                  status: false,
                ),
                CardHonor(
                  title: "One Month",
                  image:
                      'https://cdn-icons-png.flaticon.com/512/1048/1048953.png',
                  num_now: 7,
                  num_finish: 30,
                  status: false,
                ),
                CardHonor(
                  title: "Level 50",
                  image:
                      'https://cdn-icons-png.flaticon.com/512/3153/3153346.png',
                  num_now: 5,
                  num_finish: 50,
                  status: false,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  //===================================================================================================================
  //TODO : Widget Icon banner
  Widget bannerIcon({image, value}) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Column(
        children: [
          //ICON
          Image.asset(
            image,
            width: 30,
            height: 30,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 5.0),

          Text('$value', style: Roboto14_B_white),
        ],
      ),
    );
  }
}
