import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_Admin/achievement/add/achievement_add.dart';
import 'package:recycle_plus/screens/_Admin/achievement/card_honor.dart';

class Admin_AchievementScreen extends StatefulWidget {
  const Admin_AchievementScreen({Key? key}) : super(key: key);

  //Location page
  static String routeName = "/Admin_Achievement";

  @override
  State<Admin_AchievementScreen> createState() =>
      _Admin_AchievementScreenState();
}

class _Admin_AchievementScreenState extends State<Admin_AchievementScreen> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _Achievement =
        FirebaseFirestore.instance.collection('achievement').snapshots();
    //================================================================================================================
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00883C),
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text("Achievement", style: Roboto16_B_white),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, Admin_AchievementAdd.routeName);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            //TODO : Get Database from Firebase
            Expanded(
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
                      padding: EdgeInsets.zero,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.9, //ความห่าง บน-ล่าง
                      ),
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

                          return CardHonor_Admin(
                            data: data,
                            title: title,
                            image: image,
                            num_finish: num_finish,
                            achi_category: category,
                            trash: trash,
                          );
                        }),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
