import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:recycle_plus/components/font.dart';

import 'member_detail/member_detail.dart';

class ListTile_Member extends StatelessWidget {
  const ListTile_Member({
    Key? key,
    required this.data,
    required this.image,
    required this.email,
    required this.role,
  }) : super(key: key);

  final data;
  final image;
  final email;
  final role;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        width: double.infinity,
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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Admin_MemberDetail(data: data),
              ),
            );
          },
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
              child: Image.network(image),
            ),
            //TODO : Email User
            title: Text(email, style: Roboto16_B_black),
            //TODO : Role User
            subtitle: Text(role, style: Roboto12_black),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF303030),
              size: 20,
            ),
            dense: false,
          ),
        ),
      ),
    );
  }
}
