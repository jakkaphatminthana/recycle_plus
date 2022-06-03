import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_Admin/home/admin_home.dart';
import 'package:recycle_plus/screens/_Admin/news/news.dart';
import 'package:recycle_plus/screens/_Admin/page3.dart';

import '../../components/appbar/appbar_title.dart';

class Admin_TabbarHome extends StatefulWidget {
  //เลือกลำดับหน้าของ Tabbar
  int selectPage;
  Admin_TabbarHome(this.selectPage, {Key? key}) : super(key: key);

  //Location page
  static String routeName = "/Admin_Home";

  @override
  State<Admin_TabbarHome> createState() => _Admin_TabbarHomeState();
}

class _Admin_TabbarHomeState extends State<Admin_TabbarHome> {
  //TODO 1. Set Tabbar list here
  TabBar get _tabbar {
    return const TabBar(
      labelColor: Colors.white,
      unselectedLabelColor: Color(0xFFDFDFDF),
      indicatorWeight: 3,
      indicatorColor: Colors.white,
      //labelPadding: EdgeInsets.only(top: 10.0),
      tabs: [
        Tab(
          text: 'แผงควบคุม',
          icon: Icon(Icons.donut_small_rounded, size: 35),
          iconMargin: EdgeInsets.only(top: 10.0),
        ),
        Tab(
          text: 'บทความ',
          icon: Icon(Icons.article, size: 35),
          iconMargin: EdgeInsets.only(top: 10.0),
        ),
        Tab(
          text: 'แลกของรางวัล',
          icon: Icon(Icons.swap_horizontal_circle_outlined, size: 37),
          iconMargin: EdgeInsets.only(top: 10.0),
        ),
      ],
    );
  }

//==================================================================================================================

  @override
  Widget build(BuildContext context) {
    //TODO 2. ทำให้ไม่สามารถกด back page ได้
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("The System Back Button is Deactivated")),
        );
        return false;
      },
      child: DefaultTabController(
        initialIndex: widget.selectPage,
        length: 3,
        child: Scaffold(
          //TODO 3. Appbar Header
          appBar: AppBar(
            backgroundColor: const Color(0xFF00883C),
            automaticallyImplyLeading: false,
            title: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: AppbarTitle(
                press: () {
                  Navigator.popAndPushNamed(
                    context,
                    Admin_TabbarHome.routeName,
                  );
                },
              ),
            ),
            //Icon Menu bar
            actions: [
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

            //TODO 4. Tabbar in Appbar
            bottom: PreferredSize(
              preferredSize: _tabbar.preferredSize,
              child: ColoredBox(
                color: const Color(0xFF15924C),
                child: Container(
                  height: 75.0,
                  child: _tabbar,
                ),
              ),
            ),
          ),

          //========================================================================================================
          //TODO 5. หน้าจอเลื่อน
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(), //ไม่ต้องเลื่อนได้,
            children: [
              Admin_HomeScreen(),
              Admin_NewsScreen(),
              PageTestA3(),
            ],
          ),
        ),
      ),
    );
  }
}
