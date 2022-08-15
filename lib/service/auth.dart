import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  //TODO : Import Firebase Auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //TODO : เรียกข้อมูล User ณ ตอนนี้
  Stream<User?> get authStateChenges => _auth.idTokenChanges();

//===========================================================================================================
  //TODO 1. Function Register with Email
  Future registerEmail(String email, String password, String name) async {
    //TODO try ตรวจสอบโค้ด
    try {
      //TODO : Register
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        //TODO : อ้างอิง User ปัจจุบันตอนนี้
        User? userEZ = FirebaseAuth.instance.currentUser;

        // //TODO : สร้าง Model Database Profile
        // await FirebaseFirestore.instance
        //     .collection("users")
        //     .doc(userEZ?.uid)
        //     .set({
        //   "id": userEZ?.uid,
        //   "email": email,
        //   "name": name,
        //   "role": "Member",
        //   "verify": false,
        //   "address": "",
        //   "image":
        //       "https://firebasestorage.googleapis.com/v0/b/recycleplus-feecd.appspot.com/o/images%2Fuser.png?alt=media&token=70f2d6d9-e17a-40fa-b04f-71e7f6ab14f6",
        // });
      });

      //TODO : Check Error
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(
          msg: "รหัสผ่านไม่ปลอดภัย",
          gravity: ToastGravity.CENTER,
        );
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
          msg: "อีเมลนี้มีอยู่แล้วในระบบ",
          gravity: ToastGravity.CENTER,
        );
      }
      return "not_work";
    }
  }

  //TODO 2. Function Login
  Future LoginEmail(String email, String password) async {
    try {
      //TODO : Login
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      //TODO : Check Error
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(
          msg: "ไม่พบบัญชีนี้",
          gravity: ToastGravity.BOTTOM,
        );
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(
          msg: "รหัสผ่านผิดหรืออีเมลไม่ถูกต้อง",
          gravity: ToastGravity.BOTTOM,
        );
      }
      return "not_work";
    }
  }

  //TODO 3. Reset Password
  Future ResetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(
          msg: "ไม่พบบัญชีนี้",
          gravity: ToastGravity.CENTER,
        );
      }
      return "not_work";
    }
  }

  //TODO 4. SingOut
  Future SignOut() async {
    await FirebaseAuth.instance.signOut();
  }

  //TODO 5. Verify Email
  Future sendVerifyEmail() async {
    try {
      final user = _auth.currentUser!;
      await user.sendEmailVerification();
    } catch (e) {
      print("Error Verify Email : $e");
    }
  }

  //TODO 6. Create Database Profile
  Future createProfile(String name) async {
    try {
      User? userEZ = FirebaseAuth.instance.currentUser;

      //สร้าง Model Database Profile
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userEZ?.uid)
          .set({
        "id": userEZ?.uid,
        "email": userEZ?.email,
        "name": name,
        "role": "Member",
        "verify": false,
        "address": "",
        "token": 0.0,
        "exp": 1.0,
        "level": 1,
        "bonus": 1.0,
        "image":
            "https://firebasestorage.googleapis.com/v0/b/recycleplus-feecd.appspot.com/o/images%2Fuser.png?alt=media&token=70f2d6d9-e17a-40fa-b04f-71e7f6ab14f6",
      });
    } catch (e) {
      print("Error create profile faild : $e");
    }
  }

  // //TODO 6.2 Add User to Achievement collection
  // Future Add_UserToAchievement({String? id_user}) async {
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(id_user)
  //       .collection('/achievement')
  //       .add(
  //         {

  //         },
  //       )
  //       .then((value) => print("create profile Achievement success"))
  //       .catchError((e) => print("error profile Achievement faild"));
  // }
}
