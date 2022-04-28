import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class DatabaseService {
  late final String uid;

  // collection reference
  final CollectionReference _collection_Users =
      FirebaseFirestore.instance.collection('users');

  // collection reference
  final CollectionReference _collection_News =
      FirebaseFirestore.instance.collection('news');
}

//=======================================================================================================
//TODO : ติดต่อกับ firebase
class Database {
  static Database instance = Database._();
  Database._();

  //Get FirebaseStore
  Future _getFirebaseStore() async {
    firebase_storage.Reference ref = await firebase_storage
        .FirebaseStorage.instance
        .ref("gs://recycleplus-feecd.appspot.com/");

    return ref;
  }

  
}
