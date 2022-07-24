import 'dart:io';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_Admin/exchange/add_product/1_detail/1_detail.dart';
import 'package:recycle_plus/screens/_Admin/exchange/add_product/2_setting/2_setting.dart';
import 'package:recycle_plus/service/database.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:getwidget/getwidget.dart';

class Admin_AddProduct extends StatefulWidget {
  const Admin_AddProduct({Key? key}) : super(key: key);
  //Location page
  static String routeName = "/Admin_AddProduct";

  @override
  State<Admin_AddProduct> createState() => _Admin_AddProductState();
}

class _Admin_AddProductState extends State<Admin_AddProduct> {
  //index หน้าจอ
  int _activeStepIndex = 0;

  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController category = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController amount = TextEditingController();
  bool pickup = false;
  bool delivery = false;

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
          content: Container(
            child: Column(
              children: [
                Text("Category: ${category.text}"),
                Text("Name: ${name.text}"),
                Text("Description: ${description.text}"),
              ],
            ),
          ),
          // content: const Center(child: Text("ราคา")),
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
              //TODO 4. เมื่อกดปุ่ม Continue
              onStepContinue: () {
                // print("name = ${name.text}");
                // print("description = ${description.text}");

                //TODO 4.1: หน้าที่ 1 จะไปหน้า 2
                if (_activeStepIndex == 0) {
                  //ตรวจสอบการป้อนข้อมูล
                  if (name.text == "" ||
                      description.text == "" ||
                      category.text == "") {
                    print("NOOOOOOOO");
                  }
                }

                //เมื่อไปหน้าต่อไป ต้องให้ currentIndex เพิ่มตามด้วย
                if (_activeStepIndex < (stepList().length - 1)) {
                  _activeStepIndex += 1;
                }
                setState(() {});
                FocusManager.instance.primaryFocus?.unfocus();
              },
              //TODO 5. เมื่อกดปุ่ม Cancle
              onStepCancel: () {
                //ป้องกัน index ทะลุเกิน 0 (-1,-2)
                if (_activeStepIndex == 0) {
                  return;
                }
                _activeStepIndex -= 1;
                setState(() {});
                FocusManager.instance.primaryFocus?.unfocus();
              },
              // controlsBuilder: (BuildContext context, ControlsDetails controls) {
              //   return Padding(
              //     padding: const EdgeInsets.only(top: 20.0),
              //     child: Row(
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         ElevatedButton(
              //           child: Text("Continue", style: Roboto16_B_white),
              //           style: ElevatedButton.styleFrom(
              //             fixedSize: const Size(130, 40),
              //           ),
              //           onPressed: () {},
              //         ),
              //         const SizedBox(width: 20.0),
              //         TextButton(
              //           child: Text("Cancle", style: Roboto16_B_gray),
              //           style: TextButton.styleFrom(
              //             fixedSize: const Size(130, 40),
              //           ),
              //           onPressed: () {},
              //         ),
              //       ],
              //     ),
              //   );
              // },
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
}
