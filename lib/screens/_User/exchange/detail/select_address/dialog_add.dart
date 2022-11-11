import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/models/varidator.dart';
import 'package:recycle_plus/screens/_User/exchange/detail/dialog_buy.dart';
import 'package:recycle_plus/screens/_User/exchange/detail/select_address/product_address.dart';
import 'package:recycle_plus/screens/_User/profile/address/profile_address.dart';
import 'package:recycle_plus/screens/_User/profile/address/styleTextAddress.dart';
import 'package:recycle_plus/service/auth.dart';

final AuthService _auth = AuthService();
var data_length;

showDialogAddAddress_exchange({
  required BuildContext context,
  required String user_ID,
  required data_pro,
  required amounts,
  required total,
  required session,
  required ethClient,
}) {
  final _formKey = GlobalKey<FormState>();
  TextEditingController TC_phone = TextEditingController();
  TextEditingController TC_address = TextEditingController();
  TextEditingController TC_tag = TextEditingController();
  TextEditingController TC_NewTag = TextEditingController();

  double height_dialog = 330;

//==================================================================================================================

  //TODO 1: Cancle Button
  Widget cancelButton(BuildContext context) {
    return TextButton(
      child: Text("ยกเลิก", style: Roboto16_B_gray),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  //TODO 2: Continute Button
  Widget continueButton(BuildContext context) {
    return TextButton(
      child: Text("ยืนยัน", style: Roboto16_B_green),
      onPressed: ConfrimAddress(
        context: context,
        formKey: _formKey,
        TC_address: TC_address,
        TC_phone: TC_phone,
        TC_tag: TC_tag,
        TC_NewTag: TC_NewTag,
        data_pro: data_pro,
        amounts: amounts,
        total: total,
        session: session,
        ethClient: ethClient,
      ),
    );
  }

  //TODO 3: ShowDialog
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            height: height_dialog,
            width: MediaQuery.of(context).size.width * 0.85,
            decoration: BoxDecoration(
              color: const Color(0xFFfcfefc),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('เพิ่มที่อยู่จัดส่ง', style: Roboto18_B_black),
                        const SizedBox(height: 20.0),

                        buildPhoneTF(TC_phone),
                        const SizedBox(height: 20.0),
                        buildAddressTF(TC_address),
                        const SizedBox(height: 10.0),

                        //Tag select
                        Row(
                          children: [
                            //TODO 4.1: Home Choice
                            ChoiceChip(
                              label: Text(
                                "Home",
                                style: (TC_tag.text == "Home")
                                    ? Roboto14_B_white
                                    : Roboto14_B_black,
                              ),
                              avatar: Icon(
                                Icons.home,
                                color: (TC_tag.text == "Home")
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              backgroundColor: Colors.white,
                              disabledColor: Colors.white,
                              selectedColor: const Color(0xFF00883C),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              elevation: 2,
                              selected: (TC_tag.text == "Home" ? true : false),
                              onSelected: (value) {
                                if (value == true && TC_tag.text != "Home") {
                                  setState(() {
                                    TC_tag.text = "Home";
                                  });
                                } else {
                                  setState(() {
                                    TC_tag.text = "";
                                  });
                                }
                                print("contro = ${TC_tag.text}");
                              },
                            ),
                            const SizedBox(width: 8.0),

                            //TODO 4.2: Worker Choice
                            ChoiceChip(
                              label: Text(
                                "Work",
                                style: (TC_tag.text == "Work")
                                    ? Roboto14_B_white
                                    : Roboto14_B_black,
                              ),
                              avatar: Icon(
                                Icons.business,
                                color: (TC_tag.text == "Work")
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              backgroundColor: Colors.white,
                              disabledColor: Colors.white,
                              selectedColor: const Color(0xFF00883C),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              elevation: 2,
                              selected: (TC_tag.text == "Work" ? true : false),
                              onSelected: (value) {
                                if (value == true && TC_tag.text != "Work") {
                                  setState(() {
                                    TC_tag.text = "Work";
                                  });
                                } else {
                                  setState(() {
                                    TC_tag.text = "";
                                  });
                                }
                                print("contro = ${TC_tag.text}");
                              },
                            ),
                            const SizedBox(width: 8.0),

                            //TODO 4.3: Add other Choice
                            ChoiceChip(
                              label: Icon(
                                Icons.add,
                                color: (TC_tag.text == "add")
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              backgroundColor: Colors.white,
                              disabledColor: Colors.white,
                              selectedColor: const Color(0xFF00883C),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              elevation: 2,
                              selected: (TC_tag.text == "add" ? true : false),
                              onSelected: (value) {
                                if (value == true && TC_tag.text != "add") {
                                  setState(() {
                                    TC_tag.text = "add";
                                    height_dialog = 380;
                                  });
                                } else {
                                  setState(() {
                                    TC_tag.text = "";
                                    height_dialog = 320;
                                  });
                                }
                                print("contro = ${TC_tag.text}");
                              },
                            ),
                          ],
                        ),

                        //TODO : Add new Tag
                        (TC_tag.text == "add")
                            ? Column(
                                children: [
                                  const SizedBox(height: 10.0),
                                  buildTagTF(TC_NewTag),
                                ],
                              )
                            : Container(),

                        const SizedBox(height: 20.0),
                        //TODO : Button
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            continueButton(context),
                            cancelButton(context),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      });
    },
  );
}

//==================================================================================================================
//TODO : TextField Phone
TextFormField buildPhoneTF(contro_phone) {
  return TextFormField(
    //พิมพ์เฉพาะตัวเลข
    keyboardType: TextInputType.number,
    controller: contro_phone,
    maxLength: 10,
    minLines: 1,
    style: Roboto14_black,
    decoration: styleTextFieldAddress(
      'เบอร์โทร',
      'เพิ่มเบอร์โทรศัพท์ที่ติดต่อได้',
    ),
    validator: ValidatorPhone,
    onSaved: (value) => contro_phone.text = value,
  );
}

//TODO : TextField Address
TextFormField buildAddressTF(contro_address) {
  return TextFormField(
    //พิมพ์หลายบรรทัดได้
    keyboardType: TextInputType.multiline,
    controller: contro_address,
    maxLines: 4,
    minLines: 1,
    style: Roboto14_black,
    decoration: styleTextFieldAddress(
      'ที่อยู่จัดส่ง',
      'เพิ่มที่อยู่จัดส่งสินค้า',
    ),
    validator: ValidatorEmpty,
    onSaved: (value) => contro_address = value,
  );
}

//TODO : TextField Tag
TextFormField buildTagTF(contro_address) {
  return TextFormField(
    //พิมพ์หลายบรรทัดได้
    keyboardType: TextInputType.multiline,
    controller: contro_address,
    maxLines: 4,
    minLines: 1,
    style: Roboto14_black,
    decoration: styleTextFieldAddress(
      '#เพิ่มแท็ก',
      'เพิ่มชื่อกำกับที่อยู่ใหม่',
    ),
    validator: ValidatorEmpty,
    onSaved: (value) => contro_address = value,
  );
}

//TODO : get length data
Future<int> getLengthData(user_ID, tag_address) async {
  final _collection = FirebaseFirestore.instance
      .collection('users')
      .doc(user_ID)
      .collection('address')
      .where('tag', isEqualTo: tag_address)
      .get();
  var result = await _collection.then((value) {
    print('len = ${value.size}');
    return value.size;
  });
  return result;
}

//TODO : OnClick, Create Database on Firebase <<--------------------------------
GestureTapCallback ConfrimAddress({
  required BuildContext context,
  required formKey,
  required TC_address,
  required TC_phone,
  required TC_tag,
  required TC_NewTag,
  required data_pro,
  required amounts,
  required total,
  required session,
  required ethClient,
}) {
  return () async {
    if (formKey.currentState!.validate()) {
      //สั่งประมวลผลข้อมูลที่กรอก
      formKey.currentState?.save();
      print('TC_address: ${TC_address.text}');
      print('TC_phone: ${TC_phone.text}');
      print('TC_tag: ${TC_tag.text}');
      print('TC_Newtag: ${TC_NewTag.text}');

      data_length = await getLengthData(user!.uid, TC_NewTag.text);

      //Check ตัวซ้ำ
      if (data_length >= 1 && TC_tag.text == "add") {
        Fluttertoast.showToast(
          msg: "แท็กที่อยู่นี้มีอยู่แล้ว",
          gravity: ToastGravity.CENTER,
        );
      } else {
        //TODO : Add Firebase
        _auth
            .createProfile_address(
          address: TC_address.text,
          phone: TC_phone.text,
          tag: (TC_tag.text == "add") ? TC_NewTag.text : TC_tag.text,
        )
            .then((value) {
          //เมื่อเพิ่มที่อยู่สำเร็จแล้ว
          print('address success');
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Member_SelectAddress(
                      data: data_pro,
                      amounts: amounts,
                      total: total,
                      session: session,
                      ethClient: ethClient,
                    )),
          );
        }).catchError(
          //เมื่อเพิ่มที่อยู่แล้วไม่ผ่าน
          (err) => print('error address: $err'),
        );
      }
    } else {
      print('Form wrong');
    }
  };
}
