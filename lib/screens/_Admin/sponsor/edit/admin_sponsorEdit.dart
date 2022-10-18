import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/models/varidator.dart';
import 'package:recycle_plus/screens/_Admin/sponsor/add/styleTextfield.dart';
import 'package:recycle_plus/screens/_Admin/sponsor/admin_sponsor.dart';
import 'package:recycle_plus/screens/_Admin/sponsor/edit/dialog_delete.dart';
import 'package:recycle_plus/screens/_Admin/sponsor/edit/dialog_edit.dart';
import 'package:recycle_plus/service/database.dart';

class Admin_SponsorEdit extends StatefulWidget {
  const Admin_SponsorEdit({Key? key, required this.data}) : super(key: key);
  final data;

  @override
  State<Admin_SponsorEdit> createState() => _Admin_SponsorEditState();
}

class _Admin_SponsorEditState extends State<Admin_SponsorEdit> {
  //formkey = ตัวแสดงตัวแบบยูนืคของฟอร์มนี้
  //db = ติดต่อ firebase
  final formKey = GlobalKey<FormState>();
  DatabaseEZ db = DatabaseEZ.instance;

  TextEditingController TC_company = TextEditingController();
  TextEditingController TC_money = TextEditingController();

  //New Value
  var value_company;
  var value_money;

  //url รูปที่อัพโหลด
  File? value_image;
  var image_path;
  var image_file;
  String? image_name;

  //TODO 1: เลือกรูปภาพจาก gallery
  Future pickImage() async {
    try {
      //นำภาพที่เลือกมาเก็บไว้ใน image
      final value_image =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      //เช็คว่าถ้าไม่ได้เลือกก็ออก
      if (value_image == null) return;
      // นำ path image ที่เราเลือกไปเก็บไว้ใน image_file เพื่อเอาไปใช้ในส่วนของการบันทึก
      image_path = value_image.path;
      // เอาภาพที่เลือกไว้มาเก็บไว้ใน image_path เพื่อเอาไปใช้ในส่วนของการบันทึก
      image_file = value_image;
      //แปลงเป็น File
      final imageTemporary = File(value_image.path);
      //ชื่อไฟล์ของภาพที่เลือก
      String basename = value_image.path.split('/').last;

      setState(() {
        // เอาไปเก็บไว้ใน image เเล้วอัพเดดน่าเเล้วภาพจะขึ้น
        this.value_image = imageTemporary;
        this.image_name = basename;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final otp = widget.data!.get('id');
    final companyFB = widget.data!.get("company");
    final imageFB = widget.data!.get("image");
    final moneyFB = widget.data!.get('money');
    final statusFB = widget.data!.get('status');
    final emailFB = widget.data!.get("email");

    String imageFB_Con = (imageFB == '') ? null : imageFB;

    //กำหนดค่าเริ่มต้นของ textfield ให้แสดงเป็นไปตามข้อมูล firebase
    TC_company = (value_company == null)
        ? TextEditingController(text: companyFB) //ค่าเริ่มต้นตาม firebase
        : TextEditingController(text: value_company); //ค่าที่กำลังป้อน
    TC_money = (value_money == null)
        ? TextEditingController(text: "$moneyFB") //ค่าเริ่มต้นตาม firebase
        : TextEditingController(text: value_money); //ค่าที่กำลังป้อน
    //==========================================================================================================
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF00883C),
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: Text("Sponsor Detail", style: Roboto16_B_white),
          actions: [
            //TODO 1.1 Save Iconr
            IconButton(
              icon: const Icon(
                Icons.save,
                color: Colors.white,
                size: 33,
              ),
              onPressed: () async {
                // print('value_image = $value_image');
                // print('imageCon = $imageFB_Con');
                // print('value_company = $value_company');
                // print('value_money = $value_money');

                //TODO : Update on Firebase -------------------------------------------------<<<<
                if (formKey.currentState!.validate()) {
                  //สั่งประมวลผลข้อมูลที่กรอก
                  formKey.currentState?.save();
                  int money_int = int.parse(value_money);

                  //1.กรณีที่เปลี่ยนรูปด้วย
                  if (value_image != null) {
                    await showDialogOTPEdit(
                      context: context,
                      otp_ID: otp,
                      company: value_company,
                      money: money_int,
                      image_file: image_file,
                      image_path: image_path,
                    );
                    //2.กรณีที่ไม่ได้ทำการเปลี่ยนรูปด้วย
                  } else {
                    await showDialogOTPEdit(
                      context: context,
                      otp_ID: otp,
                      company: value_company,
                      money: money_int,
                    );
                  }
                }
              },
            ),

            //TODO 1.2 Delete Icon
            IconButton(
              icon: const Icon(
                Icons.delete_forever_rounded,
                color: Colors.white,
                size: 35,
              ),
              onPressed: () {
                if (statusFB == true) {
                  Fluttertoast.showToast(
                    msg: "OTP กำลังใช้งานอยู่",
                    gravity: ToastGravity.BOTTOM,
                  );
                } else {
                  showDialogOTP_Delete(
                    context: context,
                    otp_ID: otp,
                    image: imageFB_Con,
                  );
                }
              },
            ),
          ],
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //TODO 2: Image LOGO
                _buildImage(imageFB_Con),
                Text("หมายเหตุ: แนะนำต้องเป็นรูปภาพสกุลไฟล์ PNG",
                    style: Roboto12_black),
                const SizedBox(height: 20.0),

                //TODO 2: Head Detail
                Text("รายละเอียด", style: Roboto14_B_black),
                const SizedBox(height: 5.0),

                //TODO 3.1: Status now
                Row(
                  children: [
                    Text('Status: ', style: Roboto14_B_blueDeep),
                    Text(
                      (statusFB == false) ? 'รอการลงทะเบียน' : 'ลงทะเบียนแล้ว',
                      style: (statusFB == false)
                          ? Roboto14_B_orange
                          : Roboto14_B_greenB,
                    ),
                  ],
                ),

                //TODO 3.2: email
                (statusFB == true)
                    ? Row(
                        children: [
                          Text('Email: ', style: Roboto14_B_blueDeep),
                          Text(emailFB, style: Roboto14_B_greenB),
                        ],
                      )
                    : Container(),
                const SizedBox(height: 20.0),

                //TODO 4.1 Input Company
                TextFormField(
                  controller: TC_company,
                  obscureText: false,
                  style: Roboto14_black,
                  maxLength: 20,
                  decoration: styleTextFieldSponsor(
                    'Name Company',
                    'ชื่อของบริษัทหรือองค์กร',
                  ),
                  validator: ValidatorEmpty,
                  onSaved: (value) => value_company = value!,
                  onChanged: (value) => value_company = value,
                ),
                const SizedBox(height: 20.0),

                //TODO 4.2: Input Money
                TextFormField(
                  controller: TC_money,
                  obscureText: false,
                  style: Roboto14_black,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: styleTextFieldSponsor(
                    'Money',
                    'จำนวนเงินสนับสนุนสะสม',
                  ),
                  maxLength: 3,
                  validator: ValidatorEmpty,
                  onSaved: (value) => value_money = value!,
                  onChanged: (value) => value_money = value,
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //===============================================================================================================
  //TODO 1: อัพโหลด ภาพลงใน Storage ใน firebase
  uploadImage({gallery, image, uid}) async {
    // กำหนด _storage ให้เก็บ FirebaseStorage (สโตเลท)
    final _storage = FirebaseStorage.instance;
    // เอา path ที่เราเลือกจากเครื่องมาเเปลงเป็น File เพื่อเอาไปอัพโหลดลงใน Storage ใน Firebase
    var file = File(gallery);
    // เช็คว่ามีภาพที่เลือกไหม
    if (image != null) {
      //Upload to Firebase
      var snapshot = await _storage
          .ref()
          .child("images/sponsor_logo/$uid") //แหล่งเก็บภาพนี้
          .putFile(file);
      //เอาลิ้ง url จากภาพที่เราได้อัปโหลดไป เอาออกมากเก็บไว้ใน downloadUrl
      var downloadURL = await snapshot.ref.getDownloadURL();
      //ส่ง URL ของรูปภาพที่อัพโหลดขึ้น stroge แล้วไปใช้ต่อ
      // print("downloadURL = ${downloadURL}");
      return downloadURL;
    } else {
      return Text("ไม่พบรูปภาพ");
    }
  }

  //TODO 2: Widget Input Image
  Widget _buildImage(imageFB) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Header Image
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("รูปภาพโลโก้บริษัท", style: Roboto14_B_black),
            //ปุ่มลบรูปภาพ
            (value_image != null)
                ? GestureDetector(
                    child: const FaIcon(
                      FontAwesomeIcons.windowClose,
                      color: Color(0xFFF65252),
                      size: 28,
                    ),
                    onTap: () {
                      setState(() {
                        value_image = null;
                      });
                    },
                  )
                : Container(),
          ],
        ),
        const SizedBox(height: 5.0),

        //Upload Image
        GestureDetector(
          onTap: () => pickImage(),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 140,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F2F3),
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                width: 1,
              ),
            ),
            child: (value_image != null)
                //1. ถ้าได้เลือกรูปภาพใหม่ แทน
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Image.file(
                          value_image!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  )
                //2. รูปจากฐานข้อมูล และยังไม่ได้เลือกรูปภาพใหม่
                : (imageFB != null)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Image.network(
                              imageFB!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      )
                    //3.กรณีที่ยังไม่ได้เลือกรูปภาพ
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.image,
                            color: Color(0xFFD1D1D1),
                            size: 30,
                          ),
                          const SizedBox(width: 10.0),
                          Text("Adding your image",
                              style: Roboto14_B_brightGray),
                        ],
                      ),
          ),
        ),
      ],
    );
  }
}
