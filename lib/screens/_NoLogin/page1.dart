import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/models/news_model.dart';
import 'package:recycle_plus/models/sponsor_model.dart';
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
    Stream<List<SponsorModel>> logo = db.getLogoSponsor();

    //==========================================================================================================
    return Scaffold(
      body: Column(
        children: <Widget>[
          Stack(
            children: [
              //TODO 1. Header Banner
              GestureDetector(
                child: Image.asset(
                  "assets/image/reward_banner.png",
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.2,
                  fit: BoxFit.cover,
                ),
                onTap: () {},
              ),
              const SizedBox(height: 120.0),

              //TODO 2. Wallet Mini
              Align(
                alignment: const AlignmentDirectional(0, 0),
                child: GestureDetector(
                  child: Text("Wallet"),
                  onTap: () {},
                ),
              ),
            ],
          ),

          //TODO : OURSPONSOR header
          const SizedBox(height: 20.0),
          Text("OUR SPONSOR", style: Roboto16_B_black),

          //TODO : OURSPONSOR show
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

                            //TODO : Show data แบบทั้งหมด
                            return ListView(
                              scrollDirection: Axis.horizontal, //แนวนอน
                              shrinkWrap: true, //ทำให้ center ติด
                              children: sponsor.map(buildLogoSponsor).toList(),
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
          const SizedBox(height: 20.0),

          //TODO : News Database show
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
//TODO : News Widget
Widget buildNewsBanner(NewsModel news) => Container(
      padding: const EdgeInsets.only(bottom: 5.0),
      width: double.infinity,
      height: 100.0,
      child: Image.network(
        news.image,
        fit: BoxFit.cover,
      ),
    );

//TODO : Logo Sponsor Widget
Widget buildLogoSponsor(SponsorModel sponsor) => Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
      child: Image.network(
        sponsor.logo,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      ),
    );
