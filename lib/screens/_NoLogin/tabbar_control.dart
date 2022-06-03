import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recycle_plus/components/appbar/appbar_title.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_NoLogin/home/user_home.dart';
import 'package:recycle_plus/screens/_NoLogin/page2.dart';
import 'package:recycle_plus/screens/_NoLogin/page3.dart';
import 'package:recycle_plus/screens/_NoLogin/page4.dart';

class Member_TabbarHome extends StatefulWidget {
  const Member_TabbarHome({Key? key}) : super(key: key);
  //Location Page
  static String routeName = "/home";

  @override
  State<Member_TabbarHome> createState() => _Member_TabbarHomeState();
}

class _Member_TabbarHomeState extends State<Member_TabbarHome> {
  //TODO 1. Set Tabbar list here
  TabBar get _tabbar {
    return const TabBar(
      labelColor: Colors.white,
      unselectedLabelColor: Color(0xFFDFDFDF),
      indicatorWeight: 4,
      indicatorColor: Colors.white,
      //labelPadding: EdgeInsets.only(top: 10.0),
      tabs: [
        Tab(
          text: 'หน้าแรก',
          icon: FaIcon(FontAwesomeIcons.home, size: 30),
          iconMargin: EdgeInsets.only(top: 10.0),
        ),
        Tab(
          text: 'ภารกิจ',
          icon: FaIcon(FontAwesomeIcons.compass, size: 32),
          iconMargin: EdgeInsets.only(top: 10.0),
        ),
        Tab(
          text: 'ของรางวัล',
          icon: Icon(Icons.swap_horizontal_circle_outlined, size: 35),
          iconMargin: EdgeInsets.only(top: 10.0),
        ),
        Tab(
          text: 'ฮีโร่ของฉัน',
          icon: FaIcon(FontAwesomeIcons.disease, size: 30),
          iconMargin: EdgeInsets.only(top: 10.0),
        ),
      ],
    );
  }

//==================================================================================================================
  @override
  Widget build(BuildContext context) {
    //TODO : ทำให้ไม่สามารถกด back page ได้
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("The System Back Button is Deactivated")),
        );
        return false;
      },
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          //TODO 2. Appbar Header
          appBar: AppBar(
            backgroundColor: const Color(0xFF00883C),
            automaticallyImplyLeading: false,
            title: AppbarTitle(
              press: () => Navigator.popAndPushNamed(
                context,
                Member_TabbarHome.routeName,
              ),
            ),
            //Icon Menu bar
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

            //TODO 3. Tabbar in Appbar
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
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(), //ไม่ต้องเลื่อนได้,
            children: [
              User_HomeScreen(),
              PageTest2(),
              PageTest3(),
              PageTest4(),
            ],
          ),
        ),
      ),
    );
  }
}
