import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:recycle_plus/models/news_model.dart';
import 'package:recycle_plus/models/sponsor_model.dart';
import 'package:recycle_plus/models/user_model.dart';

//=======================================================================================================
//TODO : ติดต่อกับ firebase
class DatabaseEZ {
  static DatabaseEZ instance = DatabaseEZ._();
  DatabaseEZ._();

  //Get FirebaseStore
  Future _getFirebaseStore() async {
    firebase_storage.Reference ref = await firebase_storage
        .FirebaseStorage.instance
        .ref("gs://recycleplus-feecd.appspot.com/");

    return ref;
  }

  //TODO 1. News Database
  Stream<List<NewsModel>> getDataNews() => FirebaseFirestore.instance
      .collection('news')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => NewsModel.formJson(doc.data())).toList());

  //TODO 2. Sponsor Database
  Stream<List<SponsorModel>> getLogoSponsor() => FirebaseFirestore.instance
      .collection('sposor')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => SponsorModel.formJson(doc.data()))
          .toList());

  //TODO 3.1 User Data
  Stream<List<UserModelV2>> getUserData() => FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => UserModelV2.fromJson(doc.data()))
          .toList());

  //TODO 3.2 User State
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
}
