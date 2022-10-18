import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_User/achievement/card_honor.dart';

class Member_AchievementScreen extends StatefulWidget {
  const Member_AchievementScreen({Key? key}) : super(key: key);
  //Location page
  static String routeName = "/Achievement_user";

  @override
  State<Member_AchievementScreen> createState() =>
      _Member_AchievementScreenState();
}

class _Member_AchievementScreenState extends State<Member_AchievementScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  int? user_honor = 0;
  int? user_login = 0;
  int? user_trash = 0;
  int? user_level;

  //TODO 1: GetData User Information
  Future<void> getLoginStack(user_ID) async {
    final _col_login = FirebaseFirestore.instance
        .collection('users')
        .doc(user_ID)
        .snapshots()
        .listen((event) {
      setState(() {
        user_honor = event.get('honor');
        user_login = event.get('login_stack');
        user_level = event.get('level');
      });
    });
  }

  //TODO 2: GetData User Grabage
  Future<void> getGarbageUser(user_ID) async {
    final _col_login = FirebaseFirestore.instance
        .collection('users')
        .doc(user_ID)
        .snapshots()
        .listen((event) {
      setState(() {
        user_trash = event.get('garbage');
      });
    });
  }

  //TODO 0: First call whenever run
  @override
  void initState() {
    super.initState();
    if (user != null) {
      getLoginStack(user!.uid);
      getGarbageUser(user!.uid);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _Achievement =
        FirebaseFirestore.instance.collection('achievement').snapshots();
    //===============================================================================================================
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
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
                        mainAxisAlignment: MainAxisAlignment.start,
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
                                value: user_honor,
                              ),
                              bannerIcon(
                                image: 'assets/image/calendar.png',
                                value: user_login,
                              ),
                              bannerIcon(
                                image: 'assets/image/garbage.png',
                                value: user_trash,
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

        //TODO : Get Database from Firebase --------------------------------------<<<<
        (user == null)
            ? Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: NoLogin(),
              )
            : Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _Achievement,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return const SpinKitCircle(
                          color: Colors.green,
                          size: 50,
                        );
                      } else {
                        return GridView(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.94, //hight size
                          ),
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.vertical,
                          children: [
                            //TODO : Fetch data here
                            ...snapshot.data!.docs
                                .map((QueryDocumentSnapshot<Object?> data) {
                              //ได้ตัว Data มาละ ----------<<<
                              final image = data.get("image");
                              final category = data.get("category");
                              final title = data.get("title");
                              final description = data.get("description");
                              final num_finish = data.get("num_finish");
                              final trash = data.get("trash");

                              return CardHonor(
                                achiment_ID: data.id,
                                image: image,
                                category: category,
                                title: title,
                                num_finish: num_finish,
                                trash: trash,
                                description: description,
                                user_level: user_level,
                                user_login: user_login,
                              );
                            }),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),
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

  //TODO : No Login
  Widget NoLogin() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error,
            color: Colors.black,
            size: 90,
          ),
          Text('Only Member', style: Roboto20_B_black),
          const SizedBox(height: 5.0),
          Text(
            'โปรดเข้าสู่ระบบเพื่อเปิดใช้งานฟังก์ชันนี้',
            style: Roboto16_black,
          ),
        ],
      ),
    );
  }
}
