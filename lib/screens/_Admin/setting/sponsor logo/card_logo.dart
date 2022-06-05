import 'dart:io';
import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
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

  @override
  Widget build(BuildContext context) {
    final uid = widget.data!.get("id");
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
                    onTap: () {},
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
                      showAlertDialog(context, uid, imageURL);

                      // Reference photoRef =
                      //     await FirebaseStorage.instance.refFromURL(imageURL);

                      // print("photo = $photoRef");
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
  void showAlertDialog(BuildContext context, String uid, String imgURL) {
    Widget ButtonOK = TextButton(
      child: Text("Delete", style: Roboto16_B_red),
      onPressed: () {
        DeleteLogo(imgURL: imgURL);
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
  DeleteLogo({uid, imgURL}) async {
    //1.Delete image in Storage
    Reference photoRef = await FirebaseStorage.instance.refFromURL(imgURL);
    // await photoRef.delete().then((value) {
    //   print("delete storage success");

    //   //2.Delete data in firebase
    //   db
    //       .deleteLogoSponsor(uid: uid)
    //       .then((value) => print("delete firebase success"))
    //       .catchError((error) => print("delete firebase faild: $error"));
    // }).catchError((error) => print("delete faild: $error"));

    print("Uid = $uid");
  }
}
