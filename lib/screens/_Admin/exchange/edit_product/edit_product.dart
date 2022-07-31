import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recycle_plus/screens/_Admin/tabbar_control.dart';
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
  bool? isloading = false;

  late TextEditingController TC_name;
  late TextEditingController TC_description;
  late TextEditingController TC_token;
  late TextEditingController TC_amount;
  late TextEditingController TC_pickup;
  late TextEditingController TC_delivery;

  final CategoryList = ["Limited", "Markable", "NFT"];
  String? value_name;
  String? value_description;
  String? value_token;
  String? value_amount;
  String? value_category;
  String? value_pickup;
  String? value_delivery;

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
      if (type == "เข้ามารับเอง") {
        value_pickup = "$newValue";
        // widget.pickup.text = "$newValue";
        // widget.delivery.text = "$deliveryBool";
      } else if (type == "รถขนส่ง") {
        value_delivery = "$newValue";
        // value_delivery = newValue;
        // widget.delivery.text = "$newValue";
        // widget.pickup.text = "$pickupBool";
      }
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

    TC_pickup = (value_pickup == null)
        ? TextEditingController(text: "$pickupFB") //ค่าเริ่มต้นตาม firebase
        : TextEditingController(text: value_pickup); //ค่าที่กำลังป้อน

    TC_delivery = (value_delivery == null)
        ? TextEditingController(text: "$deliveryFB") //ค่าเริ่มต้นตาม firebase
        : TextEditingController(text: value_delivery); //ค่าที่กำลังป้อน

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
              onPressed: () async {
                //TODO : Update Data
                //เมื่อกรอกข้อมูลถูกต้อง
                if (_formKey.currentState!.validate()) {
                  //สั่งประมวลผลข้อมูลที่กรอก
                  _formKey.currentState?.save();

                  //ปรับค่าให้เป็นข้อมูลเดิม เนื่องจากไม่ได้ไปแก้ไขอะไร
                  setState(() {
                    (value_category == null)
                        ? value_category = categoryFB
                        : value_category;
                    (value_pickup == null)
                        ? value_pickup = "$pickupFB"
                        : value_pickup;
                    (value_delivery == null)
                        ? value_delivery = "$deliveryFB"
                        : value_delivery;
                  });

                  print("value_image = $value_image");
                  print("value_name = $value_name");
                  print("value_description = $value_description");
                  print("value_category = $value_category");
                  print("value_token = $value_token");
                  print("value_amount = $value_amount");
                  print("value_pickup = $value_pickup");
                  print("value_delivery = $value_delivery");

                  _showAlertDialogUpdate(context);
                }
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.delete_forever_rounded,
                color: Colors.white,
                size: 35,
              ),
              onPressed: () {
                _showAlertDialogDelete(context);
              },
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
                        const SizedBox(height: 15.0),

                        //TODO 3: Category
                        Text("ประเภทสินค้า", style: Roboto14_B_black),
                        const SizedBox(height: 5.0),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          height: 45,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                          child: //ลบเส้นออกใต้ออก
                              DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              //ทำให้แสดงข้อมูลที่ตั้งไว้
                              hint: (categoryFB == null)
                                  ? const Text("เลือกประเภทสินค้า")
                                  : _buildListOption(categoryFB),
                              style: Roboto14_black,
                              value: value_category,
                              isExpanded: true, //ทำให้กว้าง
                              //รายการที่กดเลือกได้
                              items: CategoryList.map(
                                (value) => DropdownMenuItem(
                                  value: value,
                                  child: _buildListOption(value),
                                ),
                              ).toList(),
                              onChanged: (value) {
                                setState(() {
                                  value_category = value;
                                });
                                print("valueEZ = ${value_category}");
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 15.0),

                        Text("การนำส่งสินค้า", style: Roboto14_B_black),
                        const SizedBox(height: 5.0),

                        //TODO 4: CheckList
                        _buildCheckList(
                          "เข้ามารับเอง",
                          (TC_pickup.text == "true") ? true : false,
                          const FaIcon(FontAwesomeIcons.store),
                          onChangeStatus,
                        ),
                        _buildCheckList(
                          "รถขนส่ง",
                          (TC_delivery.text == "true") ? true : false,
                          const FaIcon(FontAwesomeIcons.truck),
                          onChangeStatus,
                        ),

                        const SizedBox(height: 20.0),
                        Text("รายละเอียดสินค้า", style: Roboto14_B_black),
                        const SizedBox(height: 20.0),

                        //TODO 5: Name
                        TextFormField(
                          controller: TC_name,
                          obscureText: false,
                          style: Roboto14_black,
                          decoration: styleTextFieldNews(
                            'Product Name',
                            'ชื่อสินค้า',
                          ),
                          validator: ValidatorEmpty,
                          onChanged: (value) => value_name = value,
                          onSaved: (value) => value_name = value,
                        ),
                        const SizedBox(height: 15.0),

                        //TODO 6: Price
                        TextFormField(
                          controller: TC_token,
                          keyboardType: TextInputType.number,
                          obscureText: false,
                          style: Roboto14_black,
                          decoration: styleTextFieldNews(
                            'Price',
                            'กำหนดราคา เช่น 10.50',
                          ),
                          validator: ValidatorEmpty,
                          onChanged: (value) => value_token = value,
                          onSaved: (value) => value_token = value,
                        ),
                        const SizedBox(height: 15.0),

                        //TODO 7: Amount
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
                          validator: ValidatorEmpty,
                          onChanged: (value) => value_amount = value,
                          onSaved: (value) => value_amount = value,
                        ),
                        const SizedBox(height: 15.0),

                        //TODO 8: Descirption
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
                                validator: ValidatorEmpty,
                                onChanged: (value) => value_description = value,
                                onSaved: (value) => value_description = value,
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
        //Header Image
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

        //Upload Image
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

  //TODO : CheckList
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
        print("value = ${value}");
        print("picker = ${value_pickup}");
        print("delivery = ${value_delivery}");
      },
    );
  }

  //TODO : ทำให้ List Option แสดง Icon ได้
  _buildListOption(option) {
    return Row(
      children: [
        (option == "Limited")
            ? Row(
                children: [
                  const Icon(Icons.star_rounded),
                  const SizedBox(width: 7.0),
                  Text(option, style: Roboto14_black),
                ],
              )
            : (option == "Markable")
                ? Row(
                    children: [
                      const Icon(Icons.recommend),
                      const SizedBox(width: 7.0),
                      Text(option, style: Roboto14_black),
                    ],
                  )
                : Row(
                    children: [
                      const Icon(Icons.panorama),
                      const SizedBox(width: 7.0),
                      Text(option, style: Roboto14_black),
                    ],
                  ),
      ],
    );
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

  //TODO : Alert Dialog Update
  _showAlertDialogUpdate(BuildContext context) {
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
        Navigator.of(context).pop();
        _fetchData(context);

        if (value_image != null) {
          //TODO : uplode image at firestroge
          var image_url = await uploadImage(
            gallery: image_path,
            image: image_file,
            uid: widget.data!.get('id'),
          );

          //TODO : uploade data to firebase
          await db
              .updateProduct(
            Id_product: widget.data!.get("id"),
            imageURL: image_url,
            name: value_name,
            description: value_description,
            category: value_category,
            token: double.parse(value_token!),
            amount: int.parse(value_amount!),
            pickup: (value_pickup == "true") ? true : false,
            delivery: (value_delivery == "true") ? true : false,
          )
              .then((value) {
            setState(() {
              //ไปหน้าของรางวัล
              isloading = true;
            });
          }).catchError((err) => print("Update Faild"));
        } else {
          //TODO : uploade data to firebase
          await db
              .updateProduct(
            Id_product: widget.data!.get("id"),
            imageURL: widget.data!.get("image"),
            name: value_name,
            description: value_description,
            category: value_category,
            token: double.parse(value_token!),
            amount: int.parse(value_amount!),
            pickup: (value_pickup == "true") ? true : false,
            delivery: (value_delivery == "true") ? true : false,
          )
              .then((value) {
            setState(() {
              //ไปหน้าของรางวัล
              isloading = true;
            });
          }).catchError((err) => print("Update Faild"));
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("ยืนการแก้ไขข้อมูล"),
      content: const Text("คุณต้องการแก้ไขข้อมูลนี้หรือไม่?"),
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
              builder: (context) => Admin_TabbarHome(2), //หน้า Exchange
            ),
          )
        : Navigator.of(context).pop();
  }

  //TODO : Alert Dialog Delete
  _showAlertDialogDelete(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel", style: Roboto16_B_gray),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget deleteButton = FlatButton(
      child: Text("Delete", style: Roboto16_B_red),
      onPressed: () async {
        await DeleteProduct(
          imgURL: widget.data!.get('image'),
          uid: widget.data!.get("id"),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("ยืนการลบข้อมูล"),
      content: const Text("คุณต้องการลบข้อมูลนี้หรือไม่?"),
      actions: [
        deleteButton,
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

  //TODO : Delete Storage and Firebase
  DeleteProduct({uid, imgURL}) async {
    //1.Delete image in Storage
    Reference photoRef = await FirebaseStorage.instance.refFromURL(imgURL);
    await photoRef.delete().then((value) {
      print("delete storage success");
    }).catchError((error) => print("delete storage faild: $error"));

    //2.Delete data in firebase
    await db.deleteProduct(uid: uid).then((value) {
      print("delete firebase success");
      Navigator.of(context).pop();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Admin_TabbarHome(2), //หน้า Exchange
        ),
      );
    }).catchError((error) => print("delete firebase faild: $error"));
  }
}
