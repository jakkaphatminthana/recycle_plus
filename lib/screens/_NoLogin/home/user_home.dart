import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/components/wallet_card.dart';
import 'package:recycle_plus/models/news_model.dart';
import 'package:recycle_plus/models/sponsor_model.dart';
import 'package:recycle_plus/screens/_NoLogin/home/news_widget.dart';
import 'package:recycle_plus/screens/_NoLogin/news/news_detail.dart';
import 'package:recycle_plus/screens/_NoLogin/trash/trash_reward.dart';
import 'package:recycle_plus/screens/start/start.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:recycle_plus/service/database.dart';

//เรียก firebase database
DatabaseEZ db = DatabaseEZ.instance;

class User_HomeScreen extends StatefulWidget {
  @override
  State<User_HomeScreen> createState() => _User_HomeScreenState();
}

class _User_HomeScreenState extends State<User_HomeScreen> {
  //Model data ไว้ดึงฐานข้อมูล
  Stream<List<SponsorModel>> logo = db.getLogoSponsor();
  final CollectionReference _collectionNews =
      FirebaseFirestore.instance.collection('news');

  //==========================================================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //TODO : ดึงตัว firebase มาก่อนเพื่อให้อยู่ใน ListView เดียวกัน
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _collectionNews.snapshots().asBroadcastStream(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  //TODO : Fetch data here
                  return ListView(
                    children: [
                      Stack(
                        children: [
                          //TODO 1. Header Banner
                          GestureDetector(
                            child: Image.asset(
                              "assets/image/reward_banner.png",
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.22,
                              fit: BoxFit.cover,
                            ),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, Member_TrashRate.routeName);
                            },
                          ),
                          const SizedBox(height: 120.0),

                          //TODO 2. Wallet Mini
                          Align(
                            alignment: const AlignmentDirectional(0, 0),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 140),
                              child: GestureDetector(
                                child: Wallet_card,
                                onTap: () {},
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),

                      //TODO 3. OURSPONSOR header
                      Center(
                        child: Text(
                          "OUR SPONSOR",
                          style: Roboto16_B_black,
                        ),
                      ),
                      const SizedBox(height: 5.0),

                      //TODO 4. OURSPONSOR show
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEEEEE),
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Center(
                                  child: StreamBuilder<List<SponsorModel>>(
                                    stream: logo,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return Text(
                                            "something is wrong! ${snapshot.error}");
                                      } else if (snapshot.hasData) {
                                        final sponsor = snapshot.data!;

                                        //TODO : Show data Sponsor Logo แบบทั้งหมด
                                        return ListView(
                                          scrollDirection:
                                              Axis.horizontal, //แนวนอน
                                          shrinkWrap: true, //ทำให้ center ติด
                                          children: sponsor
                                              .map(buildLogoSponsor)
                                              .toList(),
                                        );
                                      } else {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 22.0),

                      //TODO 5. News Header
                      Center(
                        child: Text(
                          "ข่าวสาร/ประกาศ",
                          style: Roboto16_B_black,
                        ),
                      ),
                      const SizedBox(height: 10.0),

                      //TODO 6. News Database show (New firebase Codeing V.2)
                      ...snapshot.data!.docs.map(
                        (QueryDocumentSnapshot<Object?> data) {
                          //ได้ตัว Data มาละ ----------<<<
                          final String title = data.get("title");
                          final String content = data.get("content");
                          final String image = data.get("image");
                          final datetime = data.get("timeUpdate");

                          //จะแสดงผลข้อมูลที่ได้ในรูปแบบไหน =---------------------------
                          return ListNewsCard(
                            imageURL: image,
                            title: title,
                            content: content,
                            dateTimeEZ: datetime,
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NewsDetailScreen(data: data),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

//===================================================================================================
//TODO : News Widget
// Widget buildNewsBanner(NewsModel news) => Container(
//       padding: const EdgeInsets.only(bottom: 5.0),
//       width: double.infinity,
//       height: 120.0,
//       child: Image.network(
//         news.image,
//         fit: BoxFit.cover,
//       ),
//     );

//TODO : Logo Sponsor Widget
Widget buildLogoSponsor(SponsorModel sponsor) => Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
      child: Image.network(
        sponsor.image,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      ),
    );
