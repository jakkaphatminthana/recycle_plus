import 'package:flutter/material.dart';
import 'package:recycle_plus/components/appbar_title.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_Admin/member/member_detail/card_MemberStatus.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Admin_MemberDetail extends StatefulWidget {
  //Location page
  static String routeName = "/Admin_MemberDetail";

  @override
  State<Admin_MemberDetail> createState() => _Admin_MemberDetailState();
}

class _Admin_MemberDetailState extends State<Admin_MemberDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //TODO 1. Appbar Header
      appBar: AppBar(
        backgroundColor: const Color(0xFF00883C),
        automaticallyImplyLeading: true,
        title: Text("Profile", style: Roboto18_B_white),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, size: 30, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      //================================================================================================
      body: Align(
        alignment: const AlignmentDirectional(0, 0),
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            //TODO 2. Avatar Profile
            Container(
              width: 100,
              height: 100,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 1),
              ),
              child: Image.network('https://picsum.photos/seed/480/600'),
            ),
            const SizedBox(height: 10.0),

            //TODO 3. Name and Email
            Text("Username", style: Roboto20_B_green),
            Text("email@gmail.com", style: Roboto16_w500_black),
            const SizedBox(height: 20.0),

            //TODO 4. Status User
            Container(
              width: MediaQuery.of(context).size.width,
              height: 150,
              decoration: const BoxDecoration(color: Color(0xFFEEEEEE)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    //1. Role User (member, sponsor, admin)
                    CardMemberStatus(
                      title: "Member",
                      status: true,
                    ),
                    CardMemberStatus(
                      title: "ยืนยันตัวตน",
                      status: false,
                    ),
                    CardMemberStatus(
                      title: "Wallet Conent",
                      status: false,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Text("เมนูเพิ่มเติม", style: Roboto16_B_black),
            const SizedBox(height: 10.0),

            //TODO 5. เมนูเพิ่มเติม
            _buidMenulist(
              context,
              const FaIcon(Icons.person, size: 30, color: Colors.black),
              "รายละเอียโปรไฟล์",
              () {},
            ),
            const SizedBox(height: 10.0),

            _buidMenulist(
              context,
              const FaIcon(Icons.history, size: 30, color: Colors.black),
              "ประวัติการใช้งาน",
              () {},
            ),
            const SizedBox(height: 10.0),

            _buidMenulist(
              context,
              const FaIcon(Icons.swap_horiz, size: 30, color: Colors.black),
              "ประวัติการแลกของรางวัล",
              () {},
            ),
          ],
        ),
      ),
    );
  }
}
//=====================================================================================================

Widget _buidMenulist(BuildContext context, FaIcon iconEZ, String title,
    GestureTapCallback press) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.9,
    height: 40,
    decoration: BoxDecoration(
      color: const Color(0xFFEEEEEE),
      border: Border.all(color: const Color(0xFF727272), width: 1),
    ),
    child: ListTile(
      leading: iconEZ,
      title: Text(title, style: Roboto14_B_black),
      trailing: const Icon(Icons.arrow_forward_ios, size: 20),
      dense: true,
      visualDensity: const VisualDensity(vertical: -3),
      onTap: press,
    ),
  );
}
