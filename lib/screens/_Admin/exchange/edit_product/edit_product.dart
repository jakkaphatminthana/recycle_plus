import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recycle_plus/service/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../../components/font.dart';
import 'package:recycle_plus/service/database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recycle_plus/models/varidator.dart';
import 'package:uuid/uuid.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../product_textfield.dart';

class Admin_editProduct extends StatefulWidget {
  //ก่อนจะเรียกหน้านี้จำเป็นต้องมี paramiter data
  const Admin_editProduct({Key? key, required this.data}) : super(key: key);
  final data; //data Querysnapshot

  @override
  State<Admin_editProduct> createState() => _Admin_editProductState();
}

class _Admin_editProductState extends State<Admin_editProduct> {
  //formkey = ตัวแสดงตัวแบบยูนืคของฟอร์มนี้
  //db = ติดต่อ firebase
  final _formKey = GlobalKey<FormState>();
  DatabaseEZ db = DatabaseEZ.instance;

  late TextEditingController TC_name;
  late TextEditingController TC_description;
  late TextEditingController TC_token;
  late TextEditingController TC_amount;

  String? value_name;
  String? value_description;
  String? value_token;
  String? value_amount;
  String? value_category;
  bool? value_pickup;
  bool? value_delivery;

  //url รูปที่อัพโหลด
  File? value_image;
  var image_path;
  var image_file;

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
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  //TODO : เมื่อกด Switch
  onChangeStatus(bool newValue, String type) async {
    setState(() {
      // if (type == "เข้ามารับเอง") {
      //   pickupBool = newValue;
      //   widget.pickup.text = "$newValue";
      //   widget.delivery.text = "$deliveryBool";
      // } else if (type == "รถขนส่ง") {
      //   deliveryBool = newValue;
      //   widget.delivery.text = "$newValue";
      //   widget.pickup.text = "$pickupBool";
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    var imageFB = widget.data!.get("image");
    var nameFB = widget.data!.get("name");
    var descriptionFB = widget.data!.get("description");
    var categoryFB = widget.data!.get("category");
    var tokenFB = widget.data!.get("token");
    var amountFB = widget.data!.get("amount");
    var pickupFB = widget.data!.get("pickup");
    var deliveryFB = widget.data!.get("delivery");

    //กำหนดค่าเริ่มต้นของ textfield ให้แสดงเป็นไปตามข้อมูล firebase
    TC_name = (value_name == null)
        ? TextEditingController(text: nameFB) //ค่าเริ่มต้นตาม firebase
        : TextEditingController(text: value_name); //ค่าที่กำลังป้อน

    TC_description = (value_description == null)
        ? TextEditingController(text: descriptionFB) //ค่าเริ่มต้นตาม firebase
        : TextEditingController(text: value_description); //ค่าที่กำลังป้อน

    TC_token = (value_token == null)
        ? TextEditingController(text: "$tokenFB") //ค่าเริ่มต้นตาม firebase
        : TextEditingController(text: value_token); //ค่าที่กำลังป้อน

    TC_amount = (value_amount == null)
        ? TextEditingController(text: "$amountFB") //ค่าเริ่มต้นตาม firebase
        : TextEditingController(text: value_amount); //ค่าที่กำลังป้อน

    //=============================================================================================================
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        //TODO 1. Appbar header
        appBar: AppBar(
          backgroundColor: const Color(0xFF00883C),
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: Text("แก้ไขสินค้า", style: Roboto16_B_white),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.save,
                color: Colors.white,
                size: 33,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(
                Icons.delete_forever_rounded,
                color: Colors.white,
                size: 35,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20.0),
                        //TODO 2: Image Uploade
                        _buildImage(imageFB),
                        const SizedBox(height: 5.0),

                        //TODO 3: Category
                        Center(child: _buildChoice(title: categoryFB),),
                        const SizedBox(height: 15.0),

                        Text("การนำส่งสินค้า", style: Roboto14_B_black),
                        const SizedBox(height: 5.0),
                        //TODO 8: CheckList
                        _buildCheckList(
                          "เข้ามารับเอง",
                          pickupFB,
                          const FaIcon(FontAwesomeIcons.store),
                          onChangeStatus,
                        ),

                        _buildCheckList(
                          "รถขนส่ง",
                          deliveryFB,
                          const FaIcon(FontAwesomeIcons.truck),
                          onChangeStatus,
                        ),

                        const SizedBox(height: 20.0),
                        Text("รายละเอียดสินค้า", style: Roboto14_B_black),
                        const SizedBox(height: 20.0),

                        //TODO 4: Name
                        TextFormField(
                          controller: TC_name,
                          obscureText: false,
                          style: Roboto14_black,
                          decoration: styleTextFieldNews(
                            'Product Name',
                            'ชื่อสินค้า',
                          ),
                        ),
                        const SizedBox(height: 15.0),

                        //TODO 5: Price
                        TextFormField(
                          controller: TC_token,
                          keyboardType: TextInputType.number,
                          obscureText: false,
                          style: Roboto14_black,
                          decoration: styleTextFieldNews(
                            'Price',
                            'กำหนดราคา เช่น 10.50',
                          ),
                        ),
                        const SizedBox(height: 15.0),

                        //TODO 6: Amount
                        TextFormField(
                          controller: TC_amount,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          obscureText: false,
                          style: Roboto14_black,
                          decoration: styleTextFieldNews(
                            'Amount',
                            'จำนวนสินค้า เช่น 20',
                          ),
                        ),
                        const SizedBox(height: 15.0),

                        //TODO 7: Descirption
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //พื้นที่ขยายได้
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: 400,
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.89,
                              ),
                              child: TextFormField(
                                //พิมพ์หลายบรรทัดได้
                                keyboardType: TextInputType.multiline,
                                controller: TC_description,
                                maxLines: null,
                                minLines: 1,
                                style: Roboto14_black,
                                decoration: styleTextFieldNews(
                                  'Description',
                                  'คำอธิบายของสินค้า',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //============================================================================================================
  //TODO : Widget Input Image
  Widget _buildImage(imageFB) {
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

  //TODO : Choice Category
  Widget _buildChoice({title}) {
    return ChoiceChip(
      label: Text(title, style: Roboto14_B_white),
      avatar: Icon(
        (title == "Limited") ? Icons.star_rounded : Icons.panorama,
        color: Colors.white,
      ),
      backgroundColor: Colors.white,
      disabledColor: Colors.white,
      selectedColor: const Color(0xFF00883C),
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      elevation: 2,
      selected: true,
      onSelected: (value) {},
    );
  }

  Widget _buildCheckList(
      String title, bool status, FaIcon iconEZ, Function onChangeMethod) {
    return SwitchListTile(
      value: status,
      dense: true,
      controlAffinity: ListTileControlAffinity.leading,
      title: Row(
        children: [
          iconEZ,
          const SizedBox(width: 10.0),
          Text(title, style: Roboto14_B_black),
        ],
      ),
      tileColor: const Color(0x00F5F5F5),
      activeColor: const Color(0xFF00883C),
      onChanged: (value) {
        onChangeMethod(value, title);
        // print("picker = ${pickupBool}");
        // print("delivery = ${deliveryBool}");
      },
    );
  }
}
