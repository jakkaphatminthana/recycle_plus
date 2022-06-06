import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:recycle_plus/models/news_model.dart';
import 'package:recycle_plus/models/sponsor_model.dart';
import 'package:recycle_plus/models/user_model.dart';
import 'package:uuid/uuid.dart';

//=======================================================================================================
//TODO : ติดต่อกับ firebase
class DatabaseEZ {
  static DatabaseEZ instance = DatabaseEZ._();
  DatabaseEZ._();

  //TODO 1. GET News Database
  Stream<List<NewsModel>> getDataNews() => FirebaseFirestore.instance
      .collection('news')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => NewsModel.formJson(doc.data())).toList());

  //TODO 2. GET Sponsor Database
  Stream<List<SponsorModel>> getLogoSponsor() => FirebaseFirestore.instance
      .collection('sposor')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => SponsorModel.formJson(doc.data()))
          .toList());

  //TODO 3.1 GET User Data
  Stream<List<UserModelV2>> getUserData() => FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => UserModelV2.fromJson(doc.data()))
          .toList());

  //TODO 3.2 GET User State
  //Note : ลักษณะการเขียนเหมือนอันบน แต่เขียนแบบตัวแปร
  Stream<List<UserModel>> getStateUser() {
    final reference = FirebaseFirestore.instance.collection('users');
    //เรียงเอกสารจากมากไปน้อย โดยใช้ ฟิลด์ id
    final snapshot = reference.snapshots();

    //QuerySnapshot<Map<String, dynamic>> snapshot
    //QuerySnapshot<Object?> snapshot
    return snapshot.map((snapshot) {
      return snapshot.docs.map((doc) {
        return UserModel.fromMap(doc.data());
      }).toList();
    });
  }

  //TODO : Update UserName
  Future<void> updateUserName({UserModel? userID, UserModel? username}) {
    final reference = FirebaseFirestore.instance.collection('users');

    // print("reference = ${reference}");
    // print("userID = ${userID?.id}");
    // print("username = ${username?.name}");
    return reference
        .doc(userID?.id)
        .update({
          'name': username?.name,
        })
        .then((value) => print("อัพเดตชื่อ"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  //TODO : Update User Role
  Future<void> updateUserRole({UserModel? userID, UserModel? role}) {
    final reference = FirebaseFirestore.instance.collection('users');

    // print("reference = ${reference}");
    // print("userID = ${userID?.id}");
    // print("role = ${role?.role}");
    return reference
        .doc(userID?.id)
        .update({
          'role': role?.role,
        })
        .then((value) => print("อัพเดตยศ"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  //TODO : Update Image Profile
  Future<void> updateImageProfile({UserModel? userID, UserModel? imageURL}) {
    final reference = FirebaseFirestore.instance.collection('users');

    return reference
        .doc(userID?.id)
        .update({
          'image': imageURL?.image,
        })
        .then((value) => print("อัพเดตรูปภาพ"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  //TODO : Update News
  Future<void> updateNews({
    NewsModel? newsID,
    NewsModel? titleEZ,
    NewsModel? contentEZ,
    NewsModel? imageEZ,
  }) {
    final reference = FirebaseFirestore.instance.collection('news');

    return reference
        .doc(newsID?.id)
        .update({
          'title': titleEZ?.title,
          'content': contentEZ?.content,
          'image': imageEZ?.image,
          'timeUpdate': DateTime.now(),
        })
        .then((value) => print("update news title"))
        .catchError((error) => print("Failed to update news: $error"));
  }

  //TODO : Update News
  Future<void> updateLogoSponsor({
    String? LogoID,
    String? imageURL,
  }) {
    final reference = FirebaseFirestore.instance.collection('news');

    print("LogoID = $LogoID");
    print("imageURL = $imageURL");

    return reference
        .doc(LogoID)
        .update({
          'image': imageURL,
          'timeUpdate': DateTime.now(),
        })
        .then((value) => print("update news title"))
        .catchError((error) => print("Failed to update news: $error"));
  }

//---------------------------------------------------------------------------------------------------------------------
//TODO : ADD

  //TODO : ADD News data
  Future createNews({
    String? titile,
    String? content,
    String? image,
    String? uid,
  }) async {
    final reference = FirebaseFirestore.instance.collection('news').doc();
    //generate ID

    await FirebaseFirestore.instance
        .collection('news')
        .doc(uid)
        .set({
          "id": uid,
          "title": titile,
          "content": content,
          "image": image,
          "timeUpdate": DateTime.now(),
        })
        .then((value) => print("Add data success"))
        .catchError((error) => print("Faild : $error"));
  }

  //TODO : ADD Logo Sponsor
  Future createLogoSponsor({
    String? uid,
    String? image,
  }) async {
    final reference = FirebaseFirestore.instance.collection('sponsor').doc();
    //generate ID

    await FirebaseFirestore.instance
        .collection('sponsor')
        .doc(uid)
        .set({
          "id": uid,
          "image": image,
          "timeUpload": DateTime.now(),
        })
        .then((value) => print("Add data success"))
        .catchError((error) => print("Faild : $error"));
  }

//-------------------------------------------------------------------------------------------------------------------
//TODO : DELETE

  Future deleteLogoSponsor({String? uid, BuildContext? context}) async {
    final reference = FirebaseFirestore.instance.collection('sponsor').doc();

    await FirebaseFirestore.instance
        .collection('sponsor')
        .doc(uid)
        .delete()
        .then((value) => print("Delete Logo success"))
        .catchError((error) => print("Delete Faild: $error"));
  }
}
