import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:recycle_plus/models/news_model.dart';

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

  Stream<List<NewsModel>> getDataNews() =>
    FirebaseFirestore.instance.collection('news').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => NewsModel.formJson(doc.data())).toList());

  // Stream<List<NewsModel>> getDataNews({NewsModel? news}) {
  //   final reference = FirebaseFirestore.instance.collection('news');
  //   final snapshot = reference.snapshots();

  //   return snapshot.map((snapshot) {
  //     return snapshot.docs.map((doc) {
  //       return NewsModel.fromJson(doc.data());
  //     }).toList();
  //   });
  // }
}
