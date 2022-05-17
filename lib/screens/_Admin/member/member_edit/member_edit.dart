import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recycle_plus/models/varidator.dart';
import 'package:recycle_plus/screens/_Admin/member/member_edit/textfieldStyle.dart';
import 'package:recycle_plus/service/database.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../components/font.dart';

class Admin_MemberEdit extends StatefulWidget {
  //ก่อนจะเรียกหน้านี้จำเป็นต้องมี paramiter data
  const Admin_MemberEdit({required this.data});
  final data; //data Querysnapshot

  @override
  State<Admin_MemberEdit> createState() => _Admin_MemberEditState();
}

class _Admin_MemberEditState extends State<Admin_MemberEdit> {
  //scaffoldKey = ชี้ตัว?
  //db = ติดต่อ firebase
  final scaffoldKey = GlobalKey<ScaffoldState>();
  DatabaseEZ db = DatabaseEZ.instance;

  //_textNameControl = ใช้เก็บค่า textfield ของ Name
  late TextEditingController _textNameControl;
  //Dropdown Select list
  final RoleType = ["Member", "Sponsor"];
  String? value_role; //เอาไว้เก็บค่า dropdown ที่กดเลือกมา
  String? value_name; //เอาไว้เก็บค่า name
  bool isLoading = false;

  //url รูปที่อัพโหลด
  String imageUrl = '';
  File? value_image;
  var image1;
  var image2;

  //เลือกรูปภาพใน gallery
  Future pickImage() async {
    try {
      //นำภาพที่เลือกมาเก็บไว้ใน image
      final value_image =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      //เช็คว่าถ้าไม่ได้เลือกก็ออก
      if (value_image == null) return;
      // นำ path image ที่เราเลือกไปเก็บไว้ใน image1 เพื่อเอาไปใช้ในส่วนของการบันทึก
      this.image1 = value_image.path;
      // เอาภาพที่เลือกไว้มาเก็บไว้ใน image2 เพื่อเอาไปใช้ในส่วนของการบันทึก
      this.image2 = value_image;
      //แปลงเป็น File
      final imageTemporary = File(value_image.path);
      // เอาไปเก็บไว้ใน image เเล้วอัพเดดน่าเเล้วภาพจะขึ้น
      setState(() => this.value_image = imageTemporary);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Name = widget.data!.get("name");
    final ImageProfile = widget.data!.get('image');
    final UserRole = widget.data!.get('role');

    //กำหนดค่าเริ่มต้นของ Name textfield ให้แสดงเป็นไปตามข้อมูล firebase
    _textNameControl = TextEditingController(text: Name);
//========================================================================================
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00883C),
        automaticallyImplyLeading: true,
        title: Text("Edit Profile", style: Roboto18_B_white),
        centerTitle: true,
      ),
      body: Form(
        key: scaffoldKey,
        child: SingleChildScrollView(
          child: Align(
            alignment: const AlignmentDirectional(0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20.0),
                //TODO 1. Image Profile
                GestureDetector(
                  onTap: () => pickImage(),
                  child: Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 1),
                        ),
                        //TODO : หากมีการอัปโหลดรูปมาใหม่ จะแสดงรูปใหม่
                        child: (value_image != null)
                            ? Image.file(value_image!)
                            : Image.network(ImageProfile),
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(96, 0, 0, 0),
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
                ),

                const SizedBox(height: 20.0),

                //TODO 2. From Name
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextFormField(
                    controller: _textNameControl,
                    autofocus: true,
                    obscureText: false,
                    style: Roboto14_black,
                    decoration: styleTextFieldEdit('Name', 'Enter your name'),
                    validator: ValidatorEmpty,
                    onSaved: (value) => value_name = value,
                  ),
                ),
                const SizedBox(height: 20.0),

                //TODO 3. Dropdown Role
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    height: 45,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    //ลบเส้นออกใต้ออก
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        //TODO : ทำให้แสดงยศที่ตั้งไว้
                        hint: (UserRole == null)
                            ? const Text("เลือกระดับผู้ใช้งาน")
                            : Text(UserRole, style: Roboto14_black),
                        style: Roboto14_black,
                        value: value_role,
                        isExpanded: true, //ทำให้กว้าง
                        //TODO : รายการที่กดเลือกได้
                        items: RoleType.map(
                          (value) => DropdownMenuItem(
                            value: value,
                            child: Text(value, style: Roboto14_black),
                          ),
                        ).toList(),
                        onChanged: (value) {
                          setState(() {
                            value_role = value;
                          });
                          print("valueEZ = ${value_role}");
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),

                //TODO 4. Button Update
                ElevatedButton(
                  child: Text("Update", style: Roboto20_B_white),
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF00883C),
                    fixedSize: const Size(160, 45),
                    elevation: 2.0, //เงา
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  //เมื่อกดปุ่มนี้แล้วทำอะไรต่อ
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

