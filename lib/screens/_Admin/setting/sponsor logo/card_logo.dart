import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_Admin/setting/sponsor%20logo/sponsor_logo.dart';
import 'package:recycle_plus/service/database.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CardLogo extends StatefulWidget {
  //ก่อนจะเรียกหน้านี้จำเป็นต้องมี paramiter data
  const CardLogo({
    Key? key,
    required this.image,
    required this.data,
  }) : super(key: key);

  final String image;
  final data; //data Querysnapshot

  @override
  State<CardLogo> createState() => _CardLogoState();
}

class _CardLogoState extends State<CardLogo> {
  //db = ติดต่อ firebase
  DatabaseEZ db = DatabaseEZ.instance;

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

      //TODO : Upload to Storage and Upldate Firebase together -----------------------------
      final logoID = widget.data!.get('id');

      //อัพโหลดรูปภาพลง storage
      var image_url = await uploadImage(
        gallery: image_path,
        image: image_file,
        uid: logoID,
      );

      //อัพโหลดลงในข้อมูล firebase
      if (image_url != null) {
        await db.updateLogoSponsor(LogoID: logoID, imageURL: image_url).then(
            //Refresh Page
            (value) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => Admin_LogoSponsor(),
            ),
          );
        });
      }
    } on PlatformException catch (e) {
      print('Failed because: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final LogoID = widget.data!.get("id");
    final imageURL = widget.data!.get("image");

//==============================================================================================================
    return Container(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //TODO 1. Image Logo
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(width: 1.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Image.network(
                widget.image,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 10.0),

          //TODO 2. ICON SVG
          Padding(
            padding: const EdgeInsets.only(left: 45),
            child: Align(
              alignment: const AlignmentDirectional(0, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //TODO : แก้ไขรูป
                  GestureDetector(
                    onTap: () => pickImageAndUpload(),
                    child: Image.asset(
                      "assets/icons/pencil.png",
                      width: 35,
                      height: 35,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 25.0),

                  //TODO : ลบรูปภาพออก
                  GestureDetector(
                    child: Image.asset(
                      "assets/icons/close.png",
                      width: 35,
                      height: 35,
                      fit: BoxFit.cover,
                    ),
                    onTap: () async {
                      showAlertDialog(context, LogoID, imageURL);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //===============================================================================================================
  //TODO : Dialog confirm
  void showAlertDialog(BuildContext context, String uid, String imgURL) async {
    Widget ButtonOK = TextButton(
      child: Text("Delete", style: Roboto16_B_red),
      onPressed: () async {
        await DeleteLogo(context: context, imgURL: imgURL, uid: uid);
      },
    );
    Widget ButtonNo = TextButton(
      child: Text("Cancle", style: Roboto16_B_gray),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    AlertDialog dialog = AlertDialog(
      actions: [ButtonOK, ButtonNo],
      title: const Text("ยืนยันที่จะลบหรือไม่?"),
    );

    //Show dialog
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });
  }

//TODO : Delete Storage and Firebase
  DeleteLogo({context, uid, imgURL}) async {
    //1.Delete image in Storage
    Reference photoRef = await FirebaseStorage.instance.refFromURL(imgURL);
    await photoRef.delete().then((value) {
      print("delete storage success");
    }).catchError((error) => print("delete storage faild: $error"));

    //2.Delete data in firebase
    await db.deleteLogoSponsor(uid: uid, context: context).then((value) {
      print("delete firebase success");
      Navigator.pop(context);
    }).catchError((error) => print("delete firebase faild: $error"));
  }

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
