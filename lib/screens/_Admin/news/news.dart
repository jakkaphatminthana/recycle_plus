import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_Admin/news/listWidget.dart';
import 'package:recycle_plus/screens/_Admin/news/news_add.dart';

class Admin_NewsScreen extends StatefulWidget {
  //Location page
  static String routeName = "/Admin_News";

  @override
  State<Admin_NewsScreen> createState() => _Admin_NewsScreenState();
}

class _Admin_NewsScreenState extends State<Admin_NewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: InkWell(
                        onTap: () {},
                        child: ListWidget(
                          imageURL: 'https://picsum.photos/seed/159/600',
                          title: "Titleasdfahjdkagkljdhqijgiqekjqweiqwyuiqwyei",
                          subtitle:
                              "subtitleasdgahahdahdashdajhdaskjhdajkshdaskjdhadhajhdasdsaddadaasdadadadadaadsad",
                          press: () {},
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: InkWell(
                        onTap: () {},
                        child: ListWidget(
                          imageURL: 'https://picsum.photos/seed/159/600',
                          title: "Titleasdfahjdkagkljdhqijgiqekjqweiqwyuiqwyei",
                          subtitle:
                              "subtitleasdgahahdahdashdajhdaskjhdajkshdaskjdhadhajhdasdsaddadaasdadadadadaadsad",
                          press: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),

      //TODO : ปุ่มกดมุมขวาล่าง
      floatingActionButton: buildFloatingButton(),
    );
  }

//================================================================================================
  //TODO : Action Add News
  Widget buildFloatingButton() => FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFF00883C),
        onPressed: () {
          Navigator.pushNamed(context, Admin_NewsAdd.routeName);
        },
      );
}
