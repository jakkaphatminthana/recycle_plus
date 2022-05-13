import 'package:flutter/material.dart';
import 'package:recycle_plus/screens/_Admin/member/member_edit/textfieldStyle.dart';

import '../../../../components/font.dart';

class Admin_MemberEdit extends StatefulWidget {
  const Admin_MemberEdit({Key? key}) : super(key: key);

  @override
  State<Admin_MemberEdit> createState() => _Admin_MemberEditState();
}

class _Admin_MemberEditState extends State<Admin_MemberEdit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00883C),
        automaticallyImplyLeading: true,
        title: Text("Edit Profile", style: Roboto18_B_white),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: const AlignmentDirectional(0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20.0),
              //TODO 1. Image Profile
              Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 1),
                    ),
                    child: Image.network("https://picsum.photos/seed/480/600"),
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      color: Color(0x98000000),
                      shape: BoxShape.circle,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 30,
                        ),
                        Text("แก้ไขรูปภาพ", style: Roboto12_B_white),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),

              //TODO 2. From Name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  autofocus: true,
                  obscureText: false,
                  style: Roboto14_B_black,
                  decoration: styleTextFieldEdit('Name', 'Enter your name'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
