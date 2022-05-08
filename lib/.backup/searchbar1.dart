import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_Admin/tabbar_control.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Admin_MemberScreen extends StatefulWidget {
  //Location page
  static String routeName = "/Admin_MemberControl";

  @override
  State<Admin_MemberScreen> createState() => _Admin_MemberScreenState();
}

class _Admin_MemberScreenState extends State<Admin_MemberScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //TODO 1. Appbar Headder
      appBar: AppBar(
        backgroundColor: const Color(0xFF00883C),
        centerTitle: true,
        //TODO : Title ตรงกลางกดแล้วไปหน้าแรก
        title: GestureDetector(
          onTap: () {
            Navigator.popAndPushNamed(context, Admin_TabbarHome.routeName);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/image/logo.png",
                width: 30,
                height: 30,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text("RECYCLE+", style: Roboto18_B_white),
              ),
            ],
          ),
        ),
        //TODO : Icon Menu ทางขวาสุด
        actions: [
          IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.search,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () {
              showSearch(context: context, delegate: InputSearch());
            },
          ),
        ],
      ),
      //===============================================================================================
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 20.0),
              //TODO 2. Header Text
              Align(
                alignment: const AlignmentDirectional(-1, 0),
                child: Text("รายการข้อมูลสมาชิก", style: Roboto18_B_black),
              ),
              const SizedBox(height: 10.0),

              //TODO 3. Show Data
              Container(
                width: MediaQuery.of(context).size.width,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  //เงาขอบๆ
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 3,
                      blurRadius: 4,
                      offset: const Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                //เนื้อหาในกล่องนี้ จะแสดงอะไร
                child: GestureDetector(
                  onTap: () {},
                  child: ListTile(
                    //TODO : Profile Image
                    leading: Container(
                      width: 45,
                      height: 45,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 1),
                      ),
                      child:
                          Image.network('https://picsum.photos/seed/480/600'),
                    ),
                    //TODO : Email User
                    title: Text("myemail@gmail.com", style: Roboto16_B_black),
                    //TODO : Role User
                    subtitle: Text("Member", style: Roboto12_black),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF303030),
                      size: 20,
                    ),
                    dense: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InputSearch extends SearchDelegate {
  //TODO : Back Icon
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null), //close searchbar,
    );
  }

  //TODO : Close Icon
  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (query.isEmpty) {
              close(context, null); //close searchbar
            } else {
              query = '';
            }
          },
        ),
      ];

  @override
  Widget buildResults(BuildContext context) => Container();

  @override
  Widget buildSuggestions(BuildContext context) => Container();
}
