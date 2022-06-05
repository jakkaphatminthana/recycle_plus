import 'package:flutter/material.dart';
import 'package:recycle_plus/screens/_Admin/setting/sponsor%20logo/card_logo.dart';

import 'dart:io';
import '../../../../components/font.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:recycle_plus/service/database.dart';

class Admin_LogoSponsor extends StatefulWidget {
  //Location page
  static String routeName = "/Admin_LogoSponsor";

  @override
  State<Admin_LogoSponsor> createState() => _Admin_LogoSponsorState();
}

class _Admin_LogoSponsorState extends State<Admin_LogoSponsor> {
  //db = ติดต่อ firebase
  DatabaseEZ db = DatabaseEZ.instance;
  //firebase collection news
  final CollectionReference _collectionLogo =
      FirebaseFirestore.instance.collection('sponsor');

  //url รูปที่อัพโหลด
  File? value_image;
  var image_path;
  var image_file;

  //เลือกรูปภาพจาก gallery
  Future pickImageAndUpload() async {
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

      //TODO : Upload to Storage and Firebase together -----------------------------
      //generate ID เพื่อใช้สร้าง id unique
      var uid = Uuid();
      final uuid = uid.v1();

      //อัพโหลดรูปภาพลง storage
      var image_url = await uploadImage(
        gallery: image_path,
        image: image_file,
        uid: uuid,
      );

      //อัพโหลดลงในข้อมูล firebase
      if (image_url != null) {
        await db.createLogoSponsor(uid: uuid, image: image_url).then(
              //Refresh Page
              (value) => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Admin_LogoSponsor()),
                (Route<dynamic> route) => false,
              ),
            );
      }
    } on PlatformException catch (e) {
      print('Failed because: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
//=========================================================================================================
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00883C),
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text("Sponosor Logo", style: Roboto18_B_white),
        //Icon Menu bar
        actions: [
          IconButton(
            icon: const FaIcon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              //TODO : Uploade Image Logo
              pickImageAndUpload();
            },
          ),
        ],
        elevation: 2.0,
      ),
      //------------------------------------------------------------------------------------------
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10.0),

                  //TODO : GridView Setting
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _collectionLogo.snapshots().asBroadcastStream(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            //TODO : Fetch data here
                            return GridView(
                              padding: EdgeInsets.zero,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 0.9, //ความห่าง บน-ล่าง
                              ),
                              scrollDirection: Axis.vertical,
                              children: [
                                ...snapshot.data!.docs.map(
                                  (QueryDocumentSnapshot<Object?> data) {
                                    //ได้ตัว Data มาละ ----------<<<
                                    final String logoId = data.get('id');
                                    final String image = data.get("image");

                                    //จะแสดงผลข้อมูลที่ได้ในรูปแบบไหน =---------------------------
                                    return CardLogo(image: image, data: data);
                                  },
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

//===================================================================================================
//TODO : อัพโหลด ภาพลงใน Storage ใน firebase
  uploadImage({gallery, image, uid}) async {
    // กำหนด _storage ให้เก็บ FirebaseStorage (สโตเลท)
    final _storage = FirebaseStorage.instance;
    // เอา path ที่เราเลือกจากเครื่องมาเเปลงเป็น File เพื่อเอาไปอัพโหลดลงใน Storage ใน Firebase
    var file = File(gallery);
    // เช็คว่ามีภาพที่เลือกไหม
    if (image != null) {
      //Upload to Firebase
      var snapshot = await _storage
          .ref()
          .child("images/sponsor_logo/$uid") //แหล่งเก็บภาพนี้
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
