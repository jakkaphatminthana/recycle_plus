import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/models/varidator.dart';
import 'package:recycle_plus/screens/_User/exchange/detail/dialog_buy.dart';
import 'package:recycle_plus/screens/_User/profile/address/profile_address.dart';
import 'package:recycle_plus/screens/_User/profile/address/styleTextAddress.dart';
import 'package:recycle_plus/service/auth.dart';

final AuthService _auth = AuthService();
final routeNameTO = Member_ProfileAddress.routeName;

showDialogAddAddress({required BuildContext context, required String user_ID}) {
  final _formKey = GlobalKey<FormState>();
  TextEditingController TC_phone = TextEditingController();
  TextEditingController TC_address = TextEditingController();
  TextEditingController TC_tag = TextEditingController();
//==================================================================================================================

  //TODO 1: Cancle Button
  Widget cancelButton(BuildContext context) {
    return FlatButton(
      child: Text("ยกเลิก", style: Roboto16_B_gray),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  //TODO 2: Continute Button
  Widget continueButton(BuildContext context) {
    return FlatButton(
      child: Text("ยืนยัน", style: Roboto16_B_green),
      onPressed: ConfrimAddress(
        context: context,
        formKey: _formKey,
        TC_address: TC_address,
        TC_phone: TC_phone,
        TC_tag: TC_tag,
      ),
    );
  }

  //TODO 3: ShowDialog
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: Text("เพิ่มที่อยู่จัดส่ง", style: Roboto18_B_black),
          actions: [continueButton(context), cancelButton(context)],
          //TODO : Cotent Dialog
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                            "บ้าน",
                            style: (TC_tag.text == "บ้าน")
                                ? Roboto14_B_white
                                : Roboto14_B_black,
                          ),
                          avatar: Icon(
                            Icons.home,
                            color: (TC_tag.text == "บ้าน")
                                ? Colors.white
                                : Colors.black,
                          ),
                          backgroundColor: Colors.white,
                          disabledColor: Colors.white,
                          selectedColor: const Color(0xFF00883C),
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          elevation: 2,
                          selected: (TC_tag.text == "บ้าน" ? true : false),
                          onSelected: (value) {
                            if (value == true && TC_tag.text != "บ้าน") {
                              setState(() {
                                TC_tag.text = "บ้าน";
                              });
                            } else {
                              setState(() {
                                TC_tag.text = "";
                              });
                            }
                            print("contro = ${TC_tag.text}");
                          },
                        ),
                        const SizedBox(width: 10.0),

                        //TODO 4.2: Worker Choice
                        ChoiceChip(
                          label: Text(
                            "ที่ทำงาน",
                            style: (TC_tag.text == "ที่ทำงาน")
                                ? Roboto14_B_white
                                : Roboto14_B_black,
                          ),
                          avatar: Icon(
                            Icons.business,
                            color: (TC_tag.text == "ที่ทำงาน")
                                ? Colors.white
                                : Colors.black,
                          ),
                          backgroundColor: Colors.white,
                          disabledColor: Colors.white,
                          selectedColor: const Color(0xFF00883C),
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          elevation: 2,
                          selected: (TC_tag.text == "ที่ทำงาน" ? true : false),
                          onSelected: (value) {
                            if (value == true && TC_tag.text != "ที่ทำงาน") {
                              setState(() {
                                TC_tag.text = "ที่ทำงาน";
                              });
                            } else {
                              setState(() {
                                TC_tag.text = "";
                              });
                            }
                            print("contro = ${TC_tag.text}");
                          },
                        ),
                      ],
                    ),
                  ],
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

//TODO : OnClick, Create Database on Firebase <<--------------------------------
GestureTapCallback ConfrimAddress({
  required BuildContext context,
  required formKey,
  required TC_address,
  required TC_phone,
  required TC_tag,
}) {
  return () async {
    if (formKey.currentState!.validate()) {
      //สั่งประมวลผลข้อมูลที่กรอก
      formKey.currentState?.save();
      print('EZ');
      print('TC_address: ${TC_address.text}');
      print('TC_phone: ${TC_phone.text}');
      print('TC_tag: ${TC_tag.text}');

      //TODO : Add Firebase -------------------------------------------------------<<<<
      _auth
          .createProfile_address(
        address: TC_address.text,
        phone: TC_phone.text,
        tag: TC_tag.text,
      )
          .then((value) {
        //เมื่อเพิ่มที่อยู่สำเร็จแล้ว
        print('address success');
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, routeNameTO);
      }).catchError(
              //เมื่อเพิ่มที่อยู่แล้วไม่ผ่าน
              (err) => print('error address: $err'));
    } else {
      print('Form wrong');
    }
  };
}
