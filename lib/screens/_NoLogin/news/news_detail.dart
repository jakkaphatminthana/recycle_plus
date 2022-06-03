import 'package:flutter/material.dart';
import 'package:recycle_plus/components/appbar/appbar_title.dart';
import 'package:recycle_plus/components/appbar/appbar_user.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_NoLogin/tabbar_control.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NewsDetailScreen extends StatelessWidget {
  const NewsDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00883C),
        centerTitle: true,
        title: AppbarTitle(
          press: () => Navigator.popAndPushNamed(
            context,
            Member_TabbarHome.routeName,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.qr_code,
              color: Colors.white,
              size: 35,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.solidUserCircle,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {},
          ),
        ],
        elevation: 2.0,
      ),
      //---------------------------------------------------------------------------------------
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //TODO 2. Image News
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 240,
                    child: Align(
                      alignment: const AlignmentDirectional(0, 0),
                      child: Image.network(
                        'https://picsum.photos/seed/778/600',
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 1,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const Divider(
                    height: 10.0,
                    thickness: 10,
                    color: Color(0xFFC4C4C4),
                  ),

                  //TODO 3. Header News
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 200.0,
                            maxWidth: MediaQuery.of(context).size.width,
                          ),
                          child: Text('Hello Worlddashhadjshjhashaskjhadka',
                              style: Roboto18_B_green),
                        ),
                        const SizedBox(height: 10.0),

                        //TODO : Timedate and Auther
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 20,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 5.0),
                            Text(
                              '20/05/2022',
                              style: Roboto14_gray,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  //TODO 4. Content News
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 1000.0,
                            maxWidth: MediaQuery.of(context).size.width,
                          ),
                          child: Text('Hello Worlddashhadjshjhashaskjhadka',
                              style: Roboto14_black),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
