import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:recycle_plus/models/news_model.dart';
import 'package:recycle_plus/models/sponsor_model.dart';
import 'package:recycle_plus/models/user_model.dart';
import 'package:recycle_plus/screens/_User/exchange/detail/dialog_buy.dart';
import 'package:uuid/uuid.dart';
import 'package:fluttertoast/fluttertoast.dart';

//=======================================================================================================
//TODO : ติดต่อกับ firebase
class DatabaseEZ {
  static DatabaseEZ instance = DatabaseEZ._();
  DatabaseEZ._();

  String dateNow = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String weekNow =
      "${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)))},${DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: DateTime.daysPerWeek - DateTime.now().weekday)))}";

  //TODO 1. GET News Database
  Stream<List<NewsModel>> getDataNews() => FirebaseFirestore.instance
      .collection('news')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => NewsModel.formJson(doc.data())).toList());

  //TODO 2. GET Sponsor Database
  Stream<List<SponsorModel>> getLogoSponsor() => FirebaseFirestore.instance
      .collection('sponsor')
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

//TODO : UPDATE
//---------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
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

  //TODO : Update Logo Sponsor
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

  //TODO : Update Reward Trash
  Future<void> updateTrashReward({
    String? uid,
    String? token,
    String? exp,
  }) {
    final reference = FirebaseFirestore.instance.collection('trash');

    if (token != null) {
      return reference.doc(uid).update({"token": token}).then((value) {
        Fluttertoast.showToast(
          msg: "Update Sucess",
          gravity: ToastGravity.BOTTOM,
        );
      }).catchError((error) => print("Failed to update token: $error"));
    } else {
      return reference.doc(uid).update({"exp": exp}).then((value) {
        Fluttertoast.showToast(
          msg: "Update Sucess",
          gravity: ToastGravity.BOTTOM,
        );
      }).catchError((error) => print("Failed to update exp: $error"));
    }
  }

  //TODO : Update Product
  Future<void> updateProduct({
    String? Id_product,
    String? imageURL,
    String? name,
    String? description,
    String? category,
    double? token,
    int? amount,
    bool? pickup,
    bool? delivery,
    bool? recommend,
  }) {
    final reference = FirebaseFirestore.instance.collection('products');

    // print("ID = $Id_product");
    // print("name = $name");

    return reference
        .doc(Id_product)
        .update({
          'image': imageURL,
          'name': name,
          'description': description,
          'category': category,
          'token': token,
          'amount': amount,
          'pickup': pickup,
          'delivery': delivery,
          'recommend': recommend,
          'timeUpdate': DateTime.now(),
        })
        .then((value) => print("update product success"))
        .catchError((error) => print("Failed to update product: $error"));
  }

  //TODO : UPDATE Product amounts
  Future updateProduct_reduceAmount({
    required String ID_product,
    required int amount,
    required int product_amount,
  }) async {
    final reference = FirebaseFirestore.instance.collection('products');
    //กรณีซื้อแล้วทำให้ของหมดคลัง
    if (product_amount - amount == 0) {
      await reference.doc(ID_product).update({
        "amount": FieldValue.increment(-amount),
        "status": false,
      });
    } else {
      await reference
          .doc(ID_product)
          .update({"amount": FieldValue.increment(-amount)});
    }
  }

  //TODO : UPDATE Level
  Future updateLevel({
    required String ID_user,
    required int newLevel,
    required newExp,
  }) async {
    final reference = FirebaseFirestore.instance.collection('users');
    await reference.doc(ID_user).update({
      "level": newLevel,
      "exp": newExp,
      "bonus": 1 + (newLevel / 100),
    });
  }

  //TODO : UPDATE Profile
  Future updateUserProfile({
    required String ID_user,
    required String name,
    required String phone,
    required String gender,
  }) async {
    final reference = FirebaseFirestore.instance.collection('users');
    await reference.doc(ID_user).update({
      "name": name,
      "phone": phone,
      "gender": gender,
    });
  }

  //TODO : UPDATE Order Trading
  Future updateOrderStatus({ID_order, Type_order, company, tracking}) async {
    final reference = FirebaseFirestore.instance
        .collection('orders')
        .doc('trading')
        .collection('order');

    if (Type_order == 'pickup') {
      await reference.doc(ID_order).update({
        'status': 'success',
        'transport': '',
        'tracking': '',
        'timestamp': DateTime.now(),
      });
    } else {
      await reference.doc(ID_order).update({
        'status': 'success',
        'transport': company,
        'tracking': tracking,
        'timestamp': DateTime.now(),
      });
    }
  }

  //TODO : UPDATE exp
  Future updateAddExp({
    required String user_ID,
    required double exp,
  }) async {
    final reference = FirebaseFirestore.instance.collection('users');
    double exp2Dc = double.parse(exp.toStringAsFixed(2));

    await reference.doc(user_ID).update({
      "exp": FieldValue.increment(exp2Dc),
    });
    print('EXP = $exp2Dc');
  }

  //TODO : UPDATE product status
  Future updateProductStatus({
    required String product_ID,
    required bool value,
  }) async {
    final reference = FirebaseFirestore.instance.collection('products');
    await reference.doc(product_ID).update({"status": value});
  }

  //TODO : UPDATE news status
  Future updateNewsStatus({
    required String news_ID,
    required bool value,
  }) async {
    final reference = FirebaseFirestore.instance.collection('news');
    await reference.doc(news_ID).update({"status": value});
  }

  //TODO : UPDATE address
  Future updateAddress({
    required String user_ID,
    required String address_ID,
    required String New_address,
    required String New_phone,
  }) async {
    final reference = FirebaseFirestore.instance.collection('users');
    await reference.doc(user_ID).collection('address').doc(address_ID).update({
      'address': New_address,
      'phone': New_phone,
      'timestamp': DateTime.now(),
    });
  }

  //TODO : UPDATE Mission
  Future updateMission({
    required String mission_ID,
    required String missionType,
    required String category,
    required String title,
    required int num_finish,
    required String reward,
    required double num_reward,
    required String trash,
  }) async {
    final reference = FirebaseFirestore.instance
        .collection((missionType == 'day') ? 'mission_day' : 'mission_week');

    await reference.doc(mission_ID).update({
      'category': category,
      'title': title,
      'num_finish': num_finish,
      'reward': reward,
      'num_reward': num_reward,
      'trash': (category == "Trash") ? trash : '',
    });
  }

  //TODO : UPDATE login day
  Future updateLoginUser({
    required String user_ID,
    required int CurLogin,
  }) async {
    final reference = FirebaseFirestore.instance.collection('users');

    //1.Login รายสัปดาห์
    //หากจำนวนวัน login > weekday แปลว่าเราอยู่สัปดาห์ใหม่แล้ว
    //login = 6, weekday = 2
    if (CurLogin >= DateTime.now().weekday) {
      await reference.doc(user_ID).update({
        "login": 1,
      });
    } else {
      await reference.doc(user_ID).update({
        "login": FieldValue.increment(1),
      });
    }

    //2.Login สะสม
    await reference.doc(user_ID).update({
      "login_stack": FieldValue.increment(1),
    });
  }

  //TODO : UPDATE Mission
  Future updateAchievement({
    required String Achiment_ID,
    required String category,
    required String title,
    required int num_finish,
    required String description,
    required String trash,
    image_new,
  }) async {
    final reference = FirebaseFirestore.instance.collection('achievement');

    //1.กรณีมีรูป
    if (image_new != null) {
      await reference.doc(Achiment_ID).update({
        "image": image_new,
        "category": category,
        "title": title,
        "num_finish": num_finish,
        "description": description,
        "trash": trash,
      });
      //2.กรณีไม่มีรูป
    } else {
      await reference.doc(Achiment_ID).update({
        "category": category,
        "title": title,
        "num_finish": num_finish,
        "description": description,
        "trash": trash,
      });
    }
  }

  //TODO : UPDATE Garbage amounts
  Future updateGarbageAmount({
    required String user_ID,
    required int amounts,
  }) async {
    final reference = FirebaseFirestore.instance.collection('users');

    await reference.doc(user_ID).update({
      "garbage": FieldValue.increment(amounts),
    });
    print('Garbage+ = $amounts');
  }

  //TODO : UPDATE Honor amounts
  Future updateHonorAmount({
    required String user_ID,
    required int amounts,
  }) async {
    final reference = FirebaseFirestore.instance.collection('users');

    await reference.doc(user_ID).update({
      "honor": FieldValue.increment(amounts),
    });
    print('Honor+ = $amounts');
  }

  //TODO : UPDATE KYC Status
  Future updateKyc(
      {required String user_ID, required String ID_Card_Number}) async {
    final reference = FirebaseFirestore.instance.collection('users');

    try {
      await reference
          .doc(user_ID)
          .update({'verify': true, 'ID_Card': ID_Card_Number});
    } on FirebaseException catch (e) {
      print('error = ${e.code}');
    }
  }

  //TODO : UPDATE Sponsor by Admin
  Future updateSponsor_admin({
    required String otp_ID,
    required String company,
    required int money,
    image,
  }) async {
    final reference = FirebaseFirestore.instance.collection('sponsor');

    if (image == null) {
      await reference.doc(otp_ID).update({
        "company": company,
        "money": money,
        "timestamp": DateTime.now(),
      });
    } else {
      await reference.doc(otp_ID).update({
        "image": image,
        "company": company,
        "money": money,
        "timestamp": DateTime.now(),
      });
    }
  }

  //TODO : UPDATE OTP Status
  Future updateOTP_Status({
    required String otp,
    required String user_ID,
    required String email,
  }) async {
    final reference = FirebaseFirestore.instance.collection('sponsor');

    await reference.doc(otp).update({
      "email": email,
      "user_ID": user_ID,
      "status": true,
      "timestamp": DateTime.now(),
    });
  }

//---------------------------------------------------------------------------------------------------------------------
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
          "status": true,
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

  //TODO : ADD Product Data
  Future createProduct({
    String? uid,
    String? image,
    String? category,
    String? name,
    String? description,
    double? token,
    int? amount,
    bool? pickup,
    bool? delivery,
    bool? recommend,
  }) async {
    final reference = FirebaseFirestore.instance.collection('products').doc();
    //generate ID

    await FirebaseFirestore.instance
        .collection('products')
        .doc(uid)
        .set({
          "id": uid,
          "image": image,
          "category": category,
          "name": name,
          "description": description,
          "token": token,
          "amount": amount,
          "pickup": pickup,
          "delivery": delivery,
          "recommend": recommend,
          "timeUpdate": DateTime.now(),
          "status": true,
        })
        .then((value) => print("Add data success"))
        .catchError((error) => print("Faild : $error"));
  }

  //TODO : ADD transaction Blockchain
  Future createTransaction({
    required String? ID_user,
    required String? wallet,
    required String? txHash,
    required double? token,
    required String? order,
  }) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(ID_user)
        .collection('wallet')
        .doc(wallet)
        .collection('transaction')
        .doc(txHash)
        .set({
      "TxnHash": txHash,
      "amount": token,
      "order": order,
      "timestamp": DateTime.now(),
    });
  }

  //TODO : ADD Orders(Trading)
  Future createOrder_trading({
    required String? ID_user,
    required String? ID_product,
    required String? category,
    required String? address,
    required String? phone,
    required String? pickup,
    required int? amount,
    required double? price,
    required String? wallet,
    required String? txHash,
  }) async {
    final reference = FirebaseFirestore.instance.collection('orders');

    await FirebaseFirestore.instance
        .collection('orders')
        .doc('trading')
        .collection('order')
        .add({
      "order": "trading",
      "ID_user": ID_user,
      "ID_product": ID_product,
      "category": category,
      "pickup": pickup,
      "address": address,
      "phone": phone,
      "amount": amount,
      "price": price,
      "wallet": wallet,
      "txHash": txHash,
      "timestamp": DateTime.now(),
      "status": "pending",
      "tracking": "",
      "transport": "",
    });
  }

  //TODO : ADD Orders(TrashReward)
  Future createOrder_trashReward({
    required String? uid,
    required String? ID_user,
    required String? trash_type,
    required String? imageURL,
    required int? amount,
    required double? token,
    required double? exp,
    required String? wallet,
    required String? txHash,
  }) async {
    final reference = FirebaseFirestore.instance.collection('orders');

    await reference.doc('trash').collection('order').doc(uid).set({
      "order": "trash",
      "id": uid,
      "ID_user": ID_user,
      "trash_type": trash_type,
      "image": imageURL,
      "amount": amount,
      "token": token,
      "exp": exp,
      "wallet": wallet,
      "txHash": txHash,
      "timestamp": DateTime.now(),
      "timeDate": dateNow,
      "timeWeek": weekNow,
    });
  }

  //TODO : ADD Orders(Mission)
  Future createOrder_Mission({
    required String? ID_user,
    required String? ID_mission,
    required String? mission_type,
    required String? reward_type,
    required double? reward_num,
    required String? wallet,
    required String? txHash,
  }) async {
    final reference = FirebaseFirestore.instance.collection('orders');

    await reference.doc('mission').collection('order').add({
      'order': 'mission',
      'ID_user': ID_user,
      'ID_mission': ID_mission,
      'mission_type': mission_type,
      'reward_type': reward_type,
      'reward_num': reward_num,
      'wallet': wallet,
      'txHash': txHash,
      'timestamp': DateTime.now(),
      "timeDate": dateNow,
      "timeWeek": weekNow,
    });
  }

  //TODO : ADD Mission
  Future createMission({
    required String? typeMission,
    required String? category,
    required String? title,
    required int? num_finish,
    required String? reward,
    required double? num_reward,
    required String? trash,
  }) async {
    final reference = FirebaseFirestore.instance
        .collection((typeMission == "Daily") ? 'mission_day' : 'mission_week');

    await reference.add({
      'mission': (typeMission == "Daily") ? 'day' : 'week',
      'title': title,
      'category': category,
      'num_finish': num_finish,
      'reward': reward,
      'num_reward': num_reward,
      'trash': trash,
      'timestamp': DateTime.now(),
    });
  }

  //TODO : ADD Claim Mission
  Future createMissionOrder({
    required typeMission,
    required mission_ID,
    required user_ID,
    required timescale,
  }) async {
    final reference = FirebaseFirestore.instance
        .collection((typeMission == "day") ? 'mission_day' : 'mission_week');

    await reference
        .doc(mission_ID)
        .collection('list-date')
        .doc(timescale)
        .collection('complete')
        .doc(user_ID)
        .set({
      'status': true,
      'email': user!.email,
      'timestamp': DateTime.now(),
    });
  }

  //TODO : ADD Achievement
  Future createAchievement({
    required uid,
    required image_url,
    required category,
    required trash,
    required title,
    required description,
    required num_finish,
  }) async {
    final reference = FirebaseFirestore.instance.collection('achievement');

    await reference.doc(uid).set({
      'id': uid,
      'image': image_url,
      'category': category,
      'trash': trash,
      'title': title,
      'description': description,
      'num_finish': num_finish,
      'timestamp': DateTime.now(),
    });
  }

  //TODO : ADD Claim Achievement
  Future createAchievementOrder({
    required achiment_ID,
    required user_ID,
  }) async {
    final reference = FirebaseFirestore.instance.collection('achievement');

    await reference.doc(achiment_ID).collection('owner').doc(user_ID).set({
      'status': true,
      'email': user!.email,
      'timestamp': DateTime.now(),
    });
  }

  //TODO : ADD Sponsor OTP
  Future createSponsorOTP({required OTP, required company}) async {
    final reference = FirebaseFirestore.instance.collection('sponsor');

    await reference.doc(OTP).set({
      'id': OTP,
      'company': company,
      'image': '',
      'email': '',
      'user_ID': '',
      'money': 0,
      'status': false,
      'timestamp': DateTime.now(),
    });
  }

  //TODO : ADD Sponsor OTP
  Future createBill({
    required uid,
    required file,
    required title,
    required int money,
  }) async {
    final reference = FirebaseFirestore.instance.collection('bill_sponsor');

    await reference.doc(uid).set({
      'id': uid,
      'file': file,
      'title': title,
      'money': money,
      'timestamp': DateTime.now(),
    });
  }
//---------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------
//TODO : DELETE

  //TODO : DELETE Logo
  Future deleteLogoSponsor({String? uid, BuildContext? context}) async {
    final reference = FirebaseFirestore.instance.collection('sponsor').doc();

    await FirebaseFirestore.instance
        .collection('sponsor')
        .doc(uid)
        .delete()
        .then((value) => print("Delete Logo success"))
        .catchError((error) => print("Delete Faild: $error"));
  }

  //TODO : DELETE Product
  Future deleteProduct({String? uid}) async {
    final reference = FirebaseFirestore.instance.collection('products').doc();

    await FirebaseFirestore.instance
        .collection('products')
        .doc(uid)
        .delete()
        .then((value) => print("Delete success"))
        .catchError((error) => print("Delete Faild: $error"));
  }

  //TODO : DELETE Address
  Future deleteAddress({String? address_ID, String? user_ID}) async {
    final reference = FirebaseFirestore.instance
        .collection('users')
        .doc(user_ID)
        .collection('address')
        .doc(address_ID)
        .delete()
        .then((value) => print('Delete address'))
        .catchError((err) => print('Delete faild: $err'));
  }

  //TODO : DELETE Mission
  Future deleteMission({String? mission_ID, String? mission_Type}) async {
    final reference = FirebaseFirestore.instance
        .collection((mission_Type == "day") ? 'mission_day' : 'mission_week');

    await reference.doc(mission_ID).delete();
  }

  //TODO : DELETE Achievement
  Future deleteAchievement({String? achievement_ID}) async {
    final reference = FirebaseFirestore.instance.collection('achievement');

    await reference.doc(achievement_ID).delete();
  }

  //TODO : DELETE Sponsor otp
  Future deleteOTP_Sponsor({String? otp_ID}) async {
    final reference = FirebaseFirestore.instance.collection('sponsor');

    await reference.doc(otp_ID).delete();
  }
}
