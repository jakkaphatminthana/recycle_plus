import 'dart:io';
import 'package:flutter/material.dart';
import 'package:recycle_plus/components/appbar_title.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/models/varidator.dart';
import 'package:recycle_plus/screens/_Admin/news/textfieldStyle.dart';
import 'package:recycle_plus/screens/_Admin/tabbar_control.dart';
import 'package:recycle_plus/service/database.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Admin_NewsAdd extends StatefulWidget {
  //Location page
  static String routeName = "/Admin_AddNewsItem";

  @override
  State<Admin_NewsAdd> createState() => _Admin_NewsAddState();
}

class _Admin_NewsAddState extends State<Admin_NewsAdd> {
  //formkey = ตัวแสดงตัวแบบยูนืคของฟอร์มนี้
  //db = ติดต่อ firebase
  final _formKey = GlobalKey<FormState>();
  DatabaseEZ db = DatabaseEZ.instance;

  String? value_title;
  String? value_content;
  String? image_name;

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
        this.image_name = basename;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
//=====================================================================================================
    return Scaffold(
      //TODO 1. Appbar header
      appBar: AppBar(
        backgroundColor: const Color(0xFF00883C),
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const AppbarTitle(),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: ElevatedButton(
                child: Text("เผยแพร่", style: Roboto14_B_white),
                style: ElevatedButton.styleFrom(primary: Colors.amber),
                onPressed: () async {
                  //เมื่อกรอกข้อมูลถูกต้อง
                  if (_formKey.currentState!.validate()) {
                    //สั่งประมวลผลข้อมูลที่กรอก
                    _formKey.currentState?.save();
                    // print("value_image = ${value_image}");
                    // print("image_file = ${image_file}");
                    // print("image_path = ${image_path}");
                    // print("image_name = ${image_name}");

                    // print("value_title = ${value_title}");
                    // print("value_content = ${value_content}");
                    var image_url = await uploadImage(
                      gallery: image_path,
                      image: image_file,
                      img_name: image_name,
                    );

                    print("URL = ${image_url}");

                    //TODO : upload on firebase
                    await db
                        .createNews(
                          titile: value_title,
                          content: value_content,
                          image: image_url,
                        )
                        .then(
                          (value) => Navigator.of(context)
                              .pushReplacementNamed(Admin_TabbarHome.routeName),
                        )
                        .catchError(
                          (error) =>
                              const Text("Something is wrong please try again"),
                        );
                  }
                },
              ),
            ),
          ),
        ],
      ),
      //-------------------------------------------------------------------------------------------
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10.0),
                      Text("เพิ่มข่าวสาร", style: Roboto18_B_black),
                      const SizedBox(height: 20.0),

                      //TODO 2. Upload File
                      GestureDetector(
                        onTap: () => pickImage(), //เลือกรูปภาพ
                        child: Container(
                          width: 200,
                          height: 100,
                          decoration: BoxDecoration(
                            color: const Color(0xFFfafafa),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(1, 2),
                                blurRadius: 4,
                              ),
                            ],
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          //TODO : ตรวจสอบว่าได้เลือกรูปภาพ หรือยัง
                          child: (value_image != null)
                              //1. ถ้าได้เลือกรูปภาพแล้ว
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Image.file(
                                        value_image!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                )
                              //2. ไม่ได้เลือกรูปภาพ
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.add_circle,
                                      color: Color(0xCD00883C),
                                      size: 70,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              5, 10, 5, 10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Upload image',
                                              style: Roboto16_B_black),
                                          Text('ขนาดไม่เกิน 20 MB',
                                              style: Roboto12_black),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 10.0),

                      //TODO : ชื่อไฟล์รุปภาพ
                      Center(
                        //หากเลือกรูปภาพแล้ว ค่อยแสดง
                        child: (value_image != null)
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(image_name!, style: Roboto12_black),
                                  const SizedBox(width: 5.0),
                                  GestureDetector(
                                    child: const Icon(Icons.close),
                                    onTap: () {
                                      setState(() {
                                        value_image = null;
                                      });
                                    },
                                  ),
                                ],
                              )
                            : null,
                      ),

                      const SizedBox(height: 40.0),

                      //TODO 3. Textfield Title
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          obscureText: false,
                          style: Roboto14_black,
                          decoration: styleTextFieldNews(
                            'Title',
                            'เพิ่มหัวเรื่องข่าว',
                          ),
                          validator: ValidatorEmpty,
                          onSaved: (value) => value_title = value,
                        ),
                      ),
                      const SizedBox(height: 20.0),

                      //TODO 4. Textfield content
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //พื้นที่ขยายได้
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: 400,
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.89,
                              ),
                              child: TextFormField(
                                //พิมพ์หลายบรรทัดได้
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                minLines: 1,
                                style: Roboto14_black,
                                decoration: styleTextFieldNews(
                                  'Content',
                                  'เพิ่มเนื้อหาของข่าวสาร',
                                ),
                                validator: ValidatorEmpty,
                                onSaved: (value) => value_content = value,
                              ),
                            ),
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

//===================================================================================================
//TODO : อัพโหลด ภาพลงใน Storage ใน firebase
  uploadImage({gallery, image, img_name}) async {
    // กำหนด _storage ให้เก็บ FirebaseStorage (สโตเลท)
    final _storage = FirebaseStorage.instance;
    // เอา path ที่เราเลือกจากเครื่องมาเเปลงเป็น File เพื่อเอาไปอัพโหลดลงใน Storage ใน Firebase
    var file = File(gallery);
    // เช็คว่ามีภาพที่เลือกไหม
    if (image != null) {
      //Upload to Firebase
      var snapshot = await _storage
          .ref()
          .child("images/news/$img_name") //แหล่งเก็บภาพนี้
          .putFile(file);
      //เอาลิ้ง url จากภาพที่เราได้อัปโหลดไป เอาออกมากเก็บไว้ใน downloadUrl
      var downloadURL = await snapshot.ref.getDownloadURL();
      //ส่ง URL ของรูปภาพที่อัพโหลดขึ้น stroge แล้วไปใช้ต่อ
      // print("downloadURL = ${downloadURL}");
      return downloadURL;
    } else {
      return Text("ไม่พบรูปภาพ");
    }
  }
}
