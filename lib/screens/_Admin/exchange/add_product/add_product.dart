// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/components/image_full.dart';
import 'package:recycle_plus/screens/_Admin/exchange/add_product/1_detail/1_detail.dart';
import 'package:recycle_plus/screens/_Admin/exchange/add_product/2_setting/2_setting.dart';
import 'package:recycle_plus/screens/_Admin/exchange/add_product/3_confrim/3_confrim.dart';
import 'package:recycle_plus/service/database.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import '../../tabbar_control.dart';

class Admin_AddProduct extends StatefulWidget {
  Admin_AddProduct({Key? key}) : super(key: key);
  //Location page
  static String routeName = "/Admin_AddProduct";

  @override
  State<Admin_AddProduct> createState() => _Admin_AddProductState();
}

class _Admin_AddProductState extends State<Admin_AddProduct> {
  //formkey = ตัวแสดงตัวแบบยูนืคของฟอร์มนี้
  //db = ติดต่อ firebase
  final formKey = GlobalKey<FormState>();
  DatabaseEZ db = DatabaseEZ.instance;
  bool isloading = false;

  //index หน้าจอ
  int _activeStepIndex = 0;

  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController category = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController pickup = TextEditingController();
  TextEditingController delivery = TextEditingController();
  TextEditingController recommend = TextEditingController();

//------------------------------------------------------------------------------------------------------------------
  //TODO 1. Stepper
  List<Step> stepList() => [
        //Stepper Page 1
        Step(
          isActive: _activeStepIndex >= 0,
          state:
              (_activeStepIndex <= 0) ? StepState.indexed : StepState.complete,
          title: Text("Description", style: Roboto14_B_black),
          //TODO 1.1 เนื้อหาในหน้าที่ 1
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageInput(),
              const SizedBox(height: 20.0),
              AddProduct_detail(
                name: name,
                categoryEZ: category,
                description: description,
                recommend: recommend,
              ),
            ],
          ),
        ),
        //------------------------------------------------------<< 2
        //Stepper Page 2
        Step(
          isActive: _activeStepIndex >= 1,
          state:
              (_activeStepIndex <= 1) ? StepState.indexed : StepState.complete,
          title: const Text("Product"),
          //TODO 1.2 เนื้อหาในหน้าที่ 2
          content: AddProduct_Setting(
            price: price,
            amount: amount,
            pickup: pickup,
            delivery: delivery,
          ),
        ),
        //------------------------------------------------------<< 3
        //Stepper Page 3
        Step(
          isActive: _activeStepIndex >= 2,
          state:
              (_activeStepIndex <= 2) ? StepState.indexed : StepState.complete,
          title: const Text("Confrim"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImage(),
              AddProduct_Confrim(
                category: category,
                name: name,
                description: description,
                price: price,
                amount: amount,
                pickup: pickup,
                delivery: delivery,
                recommend: recommend,
              ),
            ],
          ),
        ),
      ];

  //url รูปที่อัพโหลด
  File? value_image;
  var image_path;
  var image_file;
  String? image_name;

  //เลือกรูปภาพจาก gallery
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
    //=================================================================================================
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF00883C),
          title: const Text("Add Product"),
          centerTitle: true,
        ),
        body: SafeArea(
          //TODO 2. กำหนดสีของ หน้าจอ
          child: Theme(
            data: ThemeData(
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: const Color(0xFF00883C),
                  ),
            ),
            //TODO 3. Stepper Banner
            child: Stepper(
              steps: stepList(),
              type: StepperType.horizontal,
              currentStep: _activeStepIndex,
              //TODO 4. การกดปุ่ม
              controlsBuilder:
                  (BuildContext context, ControlsDetails controls) {
                return Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //TODO 5. เมื่อกดปุ่ม Continue
                      ElevatedButton(
                        child: Text("Continue", style: Roboto16_B_white),
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(125, 35),
                        ),
                        onPressed: () {
                          //TODO 5.1: หน้าที่ 1 จะไปหน้า 2
                          if (_activeStepIndex == 0) {
                            //ตรวจสอบการป้อนข้อมูล
                            if (name.text != "" &&
                                description.text != "" &&
                                category.text != "" &&
                                value_image != null) {
                              //ไปหน้าต่อไป
                              if (_activeStepIndex < (stepList().length - 1)) {
                                _activeStepIndex += 1;
                              }
                              setState(() {});
                              FocusManager.instance.primaryFocus?.unfocus();
                            } else {
                              Fluttertoast.showToast(
                                msg: "กรุณาป้อนข้อมูลให้ครบถ้วน",
                                gravity: ToastGravity.BOTTOM,
                              );
                            }
                          }

                          //TODO 5.2: หน้าที่ 2 จะไปหน้า 3
                          else if (_activeStepIndex == 1) {
                            //ตรวจสอบการป้อนข้อมูล
                            if (price.text != "" && amount.text != "") {
                              if (pickup.text == "" && delivery.text == "") {
                                Fluttertoast.showToast(
                                  msg: "โปรดเปิดการนำส่งสินค้า 1 รายการ",
                                  gravity: ToastGravity.BOTTOM,
                                );
                              } else {
                                //ไปหน้าต่อไป
                                if (_activeStepIndex <
                                    (stepList().length - 1)) {
                                  _activeStepIndex += 1;
                                }
                                setState(() {});
                                FocusManager.instance.primaryFocus?.unfocus();
                              }
                            } else {
                              Fluttertoast.showToast(
                                msg: "กรุณาป้อนข้อมูลให้ครบถ้วน",
                                gravity: ToastGravity.BOTTOM,
                              );
                            }
                          }

                          //TODO 4.3: หน้าที่ 3
                          else if (_activeStepIndex == 2) {
                            _showAlertDialog(context);
                          }
                        },
                      ),
                      const SizedBox(width: 10.0),

                      //-------------------------------------------------------------
                      //TODO 6. เมื่อกดปุ่ม Cancle
                      TextButton(
                        child: Text("Cancle", style: Roboto16_B_gray),
                        style: TextButton.styleFrom(
                          fixedSize: const Size(100, 35),
                        ),
                        onPressed: () {
                          //ป้องกัน index ทะลุเกิน 0 (-1,-2)
                          if (_activeStepIndex == 0) {
                            return;
                          }
                          _activeStepIndex -= 1;
                          setState(() {});
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

//====================================================================================================
  //TODO : Widget Input Image
  Widget _buildImageInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //TODO : Header Image
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("อัปโหลดรูปภาพ", style: Roboto14_B_black),
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

        //TODO : Upload Image
        GestureDetector(
          onTap: () => pickImage(),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 130,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F2F3),
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                width: 1,
              ),
            ),
            child: (value_image != null)
                //1.กรณีที่เลือกรูปแล้ว
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
                //2.กรณีที่ยังไม่ได้เลือกรูปภาพ
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.image,
                        color: Color(0xFFD1D1D1),
                        size: 30,
                      ),
                      const SizedBox(width: 10.0),
                      Text("Adding your image", style: Roboto14_B_brightGray),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  //TODO : Show Image Selected
  Widget _buildImage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("รูปภาพสินค้า", style: Roboto16_B_black),
        const SizedBox(height: 5.0),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 130,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F2F3),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              width: 1,
            ),
          ),
          child: (value_image != null)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                ImageFullScreen(imageFile: value_image),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Image.file(
                          value_image!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("ไม่มีรูปภาพ", style: Roboto14_B_black),
                  ],
                ),
        ),
      ],
    );
  }

  //TODO : Alert Dialog
  _showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel", style: Roboto16_B_gray),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      //TODO : UploadData to firebase--------------------------------------------------------------------------<<
      child: Text("Continue", style: Roboto16_B_green),
      onPressed: () async {
        if (value_image != null) {
          var uid = Uuid();
          final uuid = uid.v1();
          var tokenDouble = double.parse(price.text);
          var amountInt = int.parse(amount.text);
          var pickupBool = (pickup.text == "true") ? true : false;
          var deliveryBool = (delivery.text == "true") ? true : false;
          var recommendBool = (recommend.text == "true") ? true : false;

          Navigator.of(context).pop();
          _fetchData(context);

          //uplode image at firestroge
          var image_url = await uploadImage(
            gallery: image_path,
            image: image_file,
            img_name: image_name,
            uid: uuid,
          );

          //uploade data to firebase
          await db
              .createProduct(
            uid: uuid,
            image: image_url,
            category: category.text,
            name: name.text,
            description: description.text,
            token: tokenDouble,
            amount: amountInt,
            pickup: pickupBool,
            delivery: deliveryBool,
            recommend: recommendBool,
          )
              .then((value) {
            setState(() {
              //ไปหน้าของรางวัล
              isloading = true;
            });
          }).catchError(
            (error) => print("Add Product Faild"),
          );
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("ยืนการเพิ่มข้อมูล"),
      content: const Text("คุณต้องการเพิ่มข้อมูลนี้หรือไม่?"),
      actions: [
        continueButton,
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  //TODO : Loading Alert
  void _fetchData(BuildContext context) async {
    // show the loading dialog
    showDialog(
        // The user CANNOT close this dialog  by pressing outsite it
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            // The background color
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  // The loading indicator
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 15,
                  ),
                  // Some text
                  Text('Loading...')
                ],
              ),
            ),
          );
        });
    await Future.delayed(const Duration(seconds: 4));
    //หากเพิ่มข้อมูลเสร็จแล้ว
    (isloading == true)
        ? Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Admin_TabbarHome(2), //หน้า News
            ),
          )
        : Navigator.of(context).pop();
  }

  //TODO : อัพโหลด ภาพลงใน Storage ใน firebase
  uploadImage({gallery, image, img_name, uid}) async {
    // กำหนด _storage ให้เก็บ FirebaseStorage (สโตเลท)
    final _storage = FirebaseStorage.instance;
    // เอา path ที่เราเลือกจากเครื่องมาเเปลงเป็น File เพื่อเอาไปอัพโหลดลงใน Storage ใน Firebase
    var file = File(gallery);
    // เช็คว่ามีภาพที่เลือกไหม
    if (image != null) {
      //Upload to Firebase
      var snapshot = await _storage
          .ref()
          .child("images/products/$uid") //แหล่งเก็บภาพนี้
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
}
