import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class DatabaseService {
  late final String uid;

  // collection reference
  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('users');

  // get database
  Stream<QuerySnapshot> get collectionEZ {
    return _collectionReference.snapshots();
  }
}

//=======================================================================================================
//TODO : ติดต่อกับ firebase
class Database {
  static Database instance = Database._();
  Database._();
}
