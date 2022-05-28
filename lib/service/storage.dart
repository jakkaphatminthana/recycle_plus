import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:recycle_plus/models/user_model.dart';

class Storage {
  final storge = FirebaseStorage.instance;

  //TODO : Upload File ลงใน Storge
  Future<void> uploadFile(String filePath, String fileName, UserModel userId) async {
    File file = File(filePath);

    try {
      //Upload to Firebase
      var snapshot = await storge.ref('files/$fileName').putFile(file);
      //เอาลิ้ง url จากภาพที่เราได้อัปโหลดไป เอาออกมากเก็บไว้ใน downloadUrl
      var downloadURL = await snapshot.ref.getDownloadURL();
      print("downloadURL = ${downloadURL}");

    } on FirebaseException catch (e) {
      print(e);
    }
  }
}
