import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/models/news_model.dart';
import 'package:recycle_plus/screens/start/start.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:recycle_plus/service/database.dart';

class PageTest1 extends StatelessWidget {
  DatabaseEZ db = DatabaseEZ.instance;

  @override
  Widget build(BuildContext context) {
    Stream<List<NewsModel>> state = db.getDataNews();

    return Scaffold(
      body: Column(
        children: <Widget>[
          //TODO : OURSPONSOR header
          const SizedBox(height: 20.0),
          Text("OUR SPONSOR", style: Roboto16_B_black),

          //TODO : OURSPONSOR show
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: 80,
            decoration: BoxDecoration(
              color: Color(0xFFEEEEEE),
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Image.network(
                      "https://firebasestorage.googleapis.com/v0/b/recycleplus-feecd.appspot.com/o/images%2Fsponsor_logo%2Fsp1.png?alt=media&token=7f1925a8-2cf9-4ba6-9701-98a62b24c02d",
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Image.network(
                      "https://firebasestorage.googleapis.com/v0/b/recycleplus-feecd.appspot.com/o/images%2Fsponsor_logo%2Fsp1.png?alt=media&token=7f1925a8-2cf9-4ba6-9701-98a62b24c02d",
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20.0),

          //TODO : Database show
          Expanded(
            child: StreamBuilder<List<NewsModel>>(
                stream: state,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("something is wrong! ${snapshot.error}");
                  } else if (snapshot.hasData) {
                    final news = snapshot.data!;

                    //Show data แบบทั้งหมด
                    return ListView(
                      children: news.map(buildNewsBanner).toList(),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
          ),
        ],
      ),
    );
  }
}

//===================================================================================================

Widget buildNewsBanner(NewsModel news) => Container(
      padding: const EdgeInsets.only(bottom: 5.0),
      width: double.infinity,
      height: 100.0,
      child: Image.network(
        news.image,
        fit: BoxFit.cover,
      ),
    );
