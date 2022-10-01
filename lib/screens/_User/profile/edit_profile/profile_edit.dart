import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_Admin/member/member_edit/textfieldStyle.dart';
import 'package:recycle_plus/screens/_User/profile/edit_profile/textfieldStyle.dart';
import 'package:recycle_plus/screens/_User/profile/profile.dart';
import 'package:recycle_plus/service/database.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../models/user_model.dart';
import '../../../../models/varidator.dart';

class Member_ProfileEdit extends StatefulWidget {
  const Member_ProfileEdit({Key? key, required this.data}) : super(key: key);
  //Location Page
  final data;

  @override
  State<Member_ProfileEdit> createState() => _Member_ProfileEditState();
}

class _Member_ProfileEditState extends State<Member_ProfileEdit> {
  //formkey = ตัวแสดงตัวแบบยูนืคของฟอร์มนี้
  //db = ติดต่อ firebase
  final _formKey = GlobalKey<FormState>();
  DatabaseEZ db = DatabaseEZ.instance;
  User? user = FirebaseAuth.instance.currentUser;
  bool? isloading = false;

  late TextEditingController TC_Name;
  late TextEditingController TC_Phone;
  late TextEditingController TC_Gender;

  final GenderType = ["ไม่ระบุเพศ", "Male", "Female", "LGBT+"];
  String? value_name;
  String? value_phone;
  String? value_gender;

  //url รูปที่อัพโหลด
  File? value_image;
  var image_path;
  var image_file;

  //เลือกรูปภาพจาก gallery
  Future pickImage() async {
    try {
      //นำภาพที่เลือกมาเก็บไว้ใน image
      final value_image =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      //เช็คว่าถ้าไม่ได้เลือกก็ออก
      if (value_image == null) return;
      // นำ path image ที่เราเลือกไปเก็บไว้ใน image_file เพื่อเอาไปใช้ในส่วนของการบันทึก
      image_path = value_image.path;
      // เอาภาพที่เลือกไว้มาเก็บไว้ใน image_path เพื่อเอาไปใช้ในส่วนของการบันทึก
      image_file = value_image;
      //แปลงเป็น File
      final imageTemporary = File(value_image.path);
      //ชื่อไฟล์ของภาพที่เลือก
      String basename = value_image.path.split('/').last;

      setState(() {
        // เอาไปเก็บไว้ใน image เเล้วอัพเดดน่าเเล้วภาพจะขึ้น
        this.value_image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var imageFB = widget.data!.get('image');
    var nameFB = widget.data!.get('name');
    var phoneFB = widget.data!.get('phone');
    var genderFB = widget.data!.get('gender');

    //กำหนดค่าเริ่มต้นของ textfield ให้แสดงเป็นไปตามข้อมูล firebase
    TC_Name = (value_name == null)
        ? TextEditingController(text: nameFB) //ค่าเริ่มต้นตาม firebase
        : TextEditingController(text: value_name); //ค่าที่กำลังป้อน
    TC_Phone = (value_phone == null)
        ? TextEditingController(text: phoneFB) //ค่าเริ่มต้นตาม firebase
        : TextEditingController(text: value_phone); //ค่าที่กำลังป้อน
    TC_Gender = (value_gender == null)
        ? TextEditingController(text: genderFB) //ค่าเริ่มต้นตาม firebase
        : TextEditingController(text: value_gender); //ค่าที่กำลังป้อน

    //==============================================================================================================
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF00883C),
          centerTitle: true,
          elevation: 0.0,
          title: Text("Edit Profile", style: Roboto18_B_white),
          //Icon Menu bar
          actions: [
            TextButton(
              child: Text("บันทึก", style: Roboto16_white),
              onPressed: () async {
                //TODO : Update Database <--------------------------------------
                //เมื่อกรอกข้อมูลถูกต้อง
                if (_formKey.currentState!.validate()) {
                  //สั่งประมวลผลข้อมูลที่กรอก
                  _formKey.currentState?.save();

                  //ปรับค่าให้เป็นข้อมูลเดิม เนื่องจากไม่ได้ไปแก้ไขอะไร
                  setState(() {
                    (value_name == null) ? value_name = nameFB : value_name;
                    (value_phone == null) ? value_phone = phoneFB : value_phone;
                    (value_gender == null)
                        ? value_gender = genderFB
                        : value_gender;
                  });
                  print("value_image = $value_image");
                  print("value_name = $value_name");
                  print("value_phone = $value_phone");
                  print("value_gender = $value_gender");
                  _showAlertDialogUpdate(context);
                }
              },
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      //TODO 1. พื้นเขียว
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 230,
                        decoration: const BoxDecoration(
                          color: Color(0xFF00883C),
                        ),
                        //TODO 1.1 Image Profile
                        child: _build_ImagePicker(imageFB),
                      ),

                      //TODO 2. Form Profile
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 10.0),
                            //TODO 2.1 Form Name
                            TextFormField(
                              controller: TC_Name,
                              obscureText: false,
                              style: Roboto14_black,
                              maxLength: 30,
                              decoration: styleTextEditProfile(
                                'Name',
                                'ชื่อของผู้ใช้',
                              ),
                              validator: ValidatorEmpty,
                              onChanged: (value) => value_name = value,
                              onSaved: (value) => value_name = value,
                            ),
                            const SizedBox(height: 15.0),

                            //TODO 2.2 Form Phone
                            TextFormField(
                              controller: TC_Phone,
                              keyboardType: TextInputType.number,
                              obscureText: false,
                              maxLength: 10,
                              style: Roboto14_black,
                              decoration: styleTextEditProfile(
                                'Phone',
                                'เบอร์โทรศัพท์ที่ติดต่อได้',
                              ),
                              validator: ValidatorPhone,
                              onChanged: (value) => value_phone = value,
                              onSaved: (value) => value_phone = value,
                            ),
                            const SizedBox(height: 15.0),

                            //TODO 2.3 Form Gender
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              height: 45,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 1),
                              ),
                              //ลบเส้นออกใต้ออก
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  //TODO : ทำให้แสดงยศที่ตั้งไว้
                                  hint: (genderFB == null)
                                      ? const Text("เลือกเพศ")
                                      : Text(genderFB, style: Roboto14_black),
                                  style: Roboto14_black,
                                  value: value_gender,
                                  isExpanded: true, //ทำให้กว้าง
                                  //TODO : รายการที่กดเลือกได้
                                  items: GenderType.map(
                                    (value) => DropdownMenuItem(
                                      value: value,
                                      child: Text(value, style: Roboto14_black),
                                    ),
                                  ).toList(),
                                  onChanged: (value) {
                                    value_gender = value;
                                    setState(() {});
                                    print("valueEZ = $value_gender");
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 15.0),

                            
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //=================================================================================================================
  //TODO 1:อัพโหลด ภาพลงใน Storage ใน firebase
  uploadImage({gallery, image, userId}) async {
    // กำหนด _storage ให้เก็บ FirebaseStorage (สโตเลท)
    final _storage = FirebaseStorage.instance;
    // เอา path ที่เราเลือกจากเครื่องมาเเปลงเป็น File เพื่อเอาไปอัพโหลดลงใน Storage ใน Firebase
    var file = File(gallery);
    // เช็คว่ามีภาพที่เลือกไหม
    if (image != null) {
      //Upload to Firebase
      var snapshot = await _storage
          .ref()
          .child("profile/${userId}/ImageProfile") //แหล่งเก็บภาพนี้
          .putFile(file);
      //เอาลิ้ง url จากภาพที่เราได้อัปโหลดไป เอาออกมากเก็บไว้ใน downloadUrl
      var downloadURL = await snapshot.ref.getDownloadURL();
      print("downloadURL = ${downloadURL}");

      //เเล้วเอา url ของภาพไปอัพเดต image ของ firestore ของ user
      db.updateImageProfile(
          userID: UserModel(id: widget.data!.get('id')),
          imageURL: UserModel(image: downloadURL));
    } else {
      return Text("ไม่พบรูปภาพ");
    }
  }

  //TODO 2: Widget Image Picker
  Widget _build_ImagePicker(imageFB) {
    return GestureDetector(
      onTap: () => pickImage(),
      child: Stack(
        children: [
          //TODO 2.1 Image Profile
          Align(
            alignment: const AlignmentDirectional(0, -0.45),
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
              ),
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: (value_image != null)
                    ? Image.file(
                        value_image!,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        imageFB,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),

          //TODO 2.2 Icon PickImage
          Align(
            alignment: const AlignmentDirectional(0.30, 0.28),
            child: Container(
              width: 35,
              height: 35,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.photo_camera,
                color: Colors.black,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //TODO 3: Alert Dialog Update
  _showAlertDialogUpdate(BuildContext context) {
    //TODO 3.1: Cancle Button
    Widget cancelButton(BuildContext context) {
      return FlatButton(
        child: Text("ยกเลิก", style: Roboto16_B_gray),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
    }

//TODO 3.2: Continute Button
    Widget continueButton(BuildContext context) {
      return FlatButton(
        child: Text("ยืนยัน", style: Roboto16_B_green),
        onPressed: ConfrimContinue(),
      );
    }

    //TODO 3.4: Dialog BeforeConfrim
    AlertDialog BeforeConfrim = AlertDialog(
      actions: [continueButton(context), cancelButton(context)],
      title: Row(
        children: [
          const Icon(
            Icons.warning,
            color: Color(0xFFEEC960),
            size: 30,
          ),
          const SizedBox(width: 5.0),
          Text("ต้องการแก้ไขข้อมูล?", style: Roboto18_B_black),
        ],
      ),
      content: const Text("คุณต้องการไขข้อมูลของคุณหรือไม่?"),
    );

    //TODO 3.5: ShowDialog
    showDialog(
      context: context,
      builder: (BuildContext context) => BeforeConfrim,
    );
  }

  //TODO 4: Confrim to Upload Firebase <----------------------------------------<<<<<<<<<
  GestureTapCallback ConfrimContinue() {
    return () async {
      Navigator.of(context).pop();

      //4.1 กรณีที่เปลี่ยนรูปด้วย
      if (value_image != null) {
        //TODO : uplode image at firestroge
        var image_url = await uploadImage(
          gallery: image_path,
          image: image_file,
          userId: widget.data!.get('id'),
        );

        // TODO : uploade data to firebase
        await db
            .updateUserProfile(
          ID_user: user!.uid,
          name: "$value_name",
          phone: "$value_phone",
          gender: "$value_gender",
        )
            .then((value) async {
          await Fluttertoast.showToast(
            msg: "อัปเดตข้อมูลแล้ว",
            gravity: ToastGravity.BOTTOM,
          );
          Navigator.pushReplacementNamed(
              context, Member_ProfileScreen.routeName);
        }).catchError((err) => print("Error update: $err"));
        //4.2 กรณีที่เปลี่ยนแค่ข้อมูล
      } else {
        // TODO : uploade data to firebase
        await db
            .updateUserProfile(
          ID_user: user!.uid,
          name: "$value_name",
          phone: "$value_phone",
          gender: "$value_gender",
        )
            .then((value) async {
          await Fluttertoast.showToast(
            msg: "อัปเดตข้อมูลแล้ว",
            gravity: ToastGravity.BOTTOM,
          );
          Navigator.pushReplacementNamed(
              context, Member_ProfileScreen.routeName);
        }).catchError((err) => print("Error update: $err"));
      }
    };
  }
}
