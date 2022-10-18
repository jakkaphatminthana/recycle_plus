import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:recycle_plus/screens/_User/exchange/detail/dialog_buy.dart';

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
        "exp": 1.0,
        "level": 1,
        "bonus": 1.0,
        "phone": "",
        "gender": "ไม่ระบุเพศ",
        "image":
            "https://firebasestorage.googleapis.com/v0/b/recycleplus-feecd.appspot.com/o/images%2Fuser_default.png?alt=media&token=5eb3431e-6485-4da5-9014-1ffee1134211",
        "login": 0,
        "login_stack": 0,
        "garbage": 0,
        'honor': 0,
      });
    } catch (e) {
      print("Error create profile faild : $e");
    }
  }

  //TODO 7: Create Address
  Future createProfile_address({
    required String address,
    required String phone,
  }) async {
    User? userEZ = FirebaseAuth.instance.currentUser;

    //สร้างข้อมูลของ profile Address
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userEZ!.uid)
        .collection('address')
        .add({
      'address': address,
      'phone': phone,
      'timestamp': DateTime.now(),
    });
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

  //TODO 8: Sponsor register
  Future SponserregisterEmail(String email, String password, String otp) async {
    //TODO try ตรวจสอบโค้ด
    try {
      //TODO 8.1: Register
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        //อ้างอิง User ปัจจุบันตอนนี้
        User? user = FirebaseAuth.instance.currentUser;

        //TODO 8.2: สร้าง Model Database Profile
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user?.uid)
            .set({
          "id": user?.uid,
          "email": email,
          "role": "Sponsor",
          "otp": otp,
        });
      }).then((value) {
        print('create sponsor success');

        //TODO 8.3: update OTP status
        db
            .updateOTP_Status(otp: otp, user_ID: user!.uid, email: email)
            .then((value) => print('otp update'));
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
}
