import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/models/varidator.dart';
import 'package:recycle_plus/screens/_Admin/achievement/edit/dialog_delete.dart';
import 'package:recycle_plus/screens/_Admin/achievement/edit/dialog_edit.dart';
import 'package:recycle_plus/service/database.dart';

import '../textStyleForm.dart';

class Admin_AchievementEdit extends StatefulWidget {
  const Admin_AchievementEdit({Key? key, required this.data}) : super(key: key);
  final data;

  @override
  State<Admin_AchievementEdit> createState() => _Admin_AchievementEditState();
}

class _Admin_AchievementEditState extends State<Admin_AchievementEdit> {
//formkey = ตัวแสดงตัวแบบยูนืคของฟอร์มนี้
  //db = ติดต่อ firebase
  final formKey = GlobalKey<FormState>();
  DatabaseEZ db = DatabaseEZ.instance;

  final CategoryList = ["Login", "Recycle", "Trash", "Level"];
  final TrashList = ["PETE", "LDPE", "PP"];

  TextEditingController TC_category = TextEditingController();
  TextEditingController TC_trash = TextEditingController();
  TextEditingController TC_title = TextEditingController();
  TextEditingController TC_num_finish = TextEditingController();
  TextEditingController TC_description = TextEditingController();

  //new value
  var value_category;
  var value_trash;
  var value_title;
  var value_num_finish;
  var value_description;

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

  //TODO 2: เมื่อกด Option
  onChangeCategory({String? mission, String? selectTrash}) async {
    setState(() {
      if (mission == "Trash") {
        value_category = mission!;
        value_trash = selectTrash!;
      } else {
        value_category = mission!;
        value_trash = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var imageFB = widget.data!.get('image');
    var categoryFB = widget.data!.get("category");
    var trashFB = widget.data!.get("trash");
    var titleFB = widget.data!.get("title");
    var num_finishFB = widget.data!.get("num_finish");
    var descriptionFB = widget.data!.get("description");

    //กำหนดค่าเริ่มต้นของ textfield ให้แสดงเป็นไปตามข้อมูล firebase
    TC_title = (value_title == null)
        ? TextEditingController(text: titleFB) //ค่าเริ่มต้นตาม firebase
        : TextEditingController(text: value_title); //ค่าที่กำลังป้อน
    TC_num_finish = (value_num_finish == null)
        ? TextEditingController(text: '$num_finishFB') //ค่าเริ่มต้นตาม firebase
        : TextEditingController(text: value_num_finish); //ค่าที่กำลังป้อน
    TC_description = (value_description == null)
        ? TextEditingController(text: descriptionFB) //ค่าเริ่มต้นตาม firebase
        : TextEditingController(text: value_description); //ค่าที่กำลังป้อน

    //===============================================================================================================
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF00883C),
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: Text("Achievement Edit", style: Roboto16_B_white),
          actions: [
            //TODO 1.1 Save Iconr
            IconButton(
              icon: const Icon(
                Icons.save,
                color: Colors.white,
                size: 33,
              ),
              onPressed: () async {
                //TODO : Update on Firebase -------------------------------------------------<<<<
                if (formKey.currentState!.validate()) {
                  //สั่งประมวลผลข้อมูลที่กรอก
                  formKey.currentState?.save();

                  //ตรวจสอบค่าว่าง ของพวก Trash
                  if (value_category == 'Trash' && value_trash == null) {
                    Fluttertoast.showToast(
                      msg: "กรุณาป้อนข้อมูลให้ครบถ้วน",
                      gravity: ToastGravity.BOTTOM,
                    );
                  } else {
                    //ปรับค่าให้เป็นข้อมูลเดิม เนื่องจากไม่ได้ไปแก้ไขอะไร
                    setState(() {
                      (value_category == null)
                          ? value_category = categoryFB
                          : value_category;

                      (value_category == 'Trash' && value_trash == null)
                          ? value_trash = trashFB
                          : value_trash;
                    });

                    //1.กรณีที่เปลี่ยนรูปด้วย
                    if (value_image != null) {
                      await showDialogAchimentEdit(
                        context: context,
                        Achiment_ID: widget.data.id,
                        category: value_category,
                        title: value_title,
                        num_finish: value_num_finish,
                        description: value_description,
                        trash: value_trash,
                        image_file: image_file,
                        image_path: image_path,
                      );
                      //2.กรณีที่ไม่เปลี่ยนรูป
                    } else {
                      await showDialogAchimentEdit(
                        context: context,
                        Achiment_ID: widget.data.id,
                        category: value_category,
                        title: value_title,
                        num_finish: value_num_finish,
                        description: value_description,
                        trash: value_trash,
                      );
                    }

                    // print('value_image = $value_image');
                    // print('value_category = $value_category');
                    // print('value_title = $value_title');
                    // print('value_num_finish = $value_num_finish');
                    // print('value_description = $value_description');
                    // print('value_trash = $value_trash');
                    // print('trashFB = $trashFB');
                    // print('--------------');
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
                showDialogAchiment_Delete(
                  context: context,
                  Achiment_ID: widget.data.id,
                );
              },
            ),
          ],
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //TODO 1: Image Input
                        _buildImage(imageFB),
                        Text(
                          'หมายเหตุ: ควรเป็นรูปสกุล PNG และมีลักษณะแบบไอคอน',
                          style: Roboto12_black,
                        ),
                        const SizedBox(height: 15.0),

                        //TODO 2.1 Head Category
                        Text("ประเภทความสำเร็จ", style: Roboto14_B_black),
                        const SizedBox(height: 5.0),

                        //TODO 2.2 Category Option
                        _build_Option(
                          hint: (value_category == null)
                              ? categoryFB
                              : value_category,
                          listEZ: CategoryList,
                          listShow: _build_CategoryDescription,
                          onChangeOption: onChangeCategory,
                        ),

                        //TODO 2.3 กรณีที่ภารกิจแบบ Trash
                        //1.กรณีที่ ตอนแรกเป็นแบบ Trash อยู่แล้ว
                        (categoryFB == 'Trash' && value_category == null)
                            ? Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: _build_Option(
                                  hint: (value_trash == null)
                                      ? trashFB
                                      : value_trash,
                                  listEZ: TrashList,
                                  onChangeOption: onChangeCategory,
                                ),
                              )
                            //2. กรณีที่เปลี่ยนเป็นบบ Trash
                            : (value_category == 'Trash')
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: _build_Option(
                                      hint: (value_trash == null)
                                          ? 'เลือกประเภทขยะ'
                                          : value_trash,
                                      listEZ: TrashList,
                                      onChangeOption: onChangeCategory,
                                    ),
                                  )
                                : Container(),
                        const SizedBox(height: 20.0),

                        //TODO 3.1 Head Detail
                        Text("รายละเอียด", style: Roboto14_B_black),
                        const SizedBox(height: 20.0),

                        //TODO 3.2 Input Title
                        TextFormField(
                          controller: TC_title,
                          obscureText: false,
                          style: Roboto14_black,
                          maxLength: 20,
                          decoration: styleTextFieldAchi(
                            'Name',
                            'ชื่อของความสำเร็จ',
                          ),
                          validator: ValidatorEmpty,
                          onSaved: (value) => value_title = value!,
                          onChanged: (value) => value_title = value,
                        ),
                        const SizedBox(height: 20.0),

                        //TODO 3.3: Input Description
                        Row(
                          children: [
                            //พื้นที่ขยายได้
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: 400,
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.89,
                              ),
                              child: TextFormField(
                                controller: TC_description,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                minLines: 1,
                                obscureText: false,
                                style: Roboto14_black,
                                decoration: styleTextFieldAchi(
                                  'Description',
                                  'คำอธิบายหรือวิธีการของความสำเร็จ',
                                ),
                                validator: ValidatorEmpty,
                                onSaved: (value) => value_description = value!,
                                onChanged: (value) => value_description = value,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),

                        //TODO 3.4: Input Number to Finish
                        TextFormField(
                          controller: TC_num_finish,
                          obscureText: false,
                          style: Roboto14_black,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: styleTextFieldAchi(
                            'Finish',
                            'จำนวนสะสมเพื่อให้สำเสร็จ',
                          ),
                          maxLength: 3,
                          validator: ValidatorEmpty,
                          onSaved: (value) => value_num_finish = value!,
                          onChanged: (value) => value_num_finish = value,
                        ),
                        const SizedBox(height: 20.0),
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

  //=================================================================================================================
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
          .child("images/achievements/$uid") //แหล่งเก็บภาพนี้
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

  //TODO 1: Widget Input Image
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

  //TODO 2: Option Dropdown
  Widget _build_Option({
    hint,
    List<String>? listEZ,
    Function? listShow,
    Function? onChangeOption,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      height: 45,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: //ลบเส้นออกใต้ออก
          DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          //ทำให้แสดงข้อมูลที่ตั้งไว้
          hint: Text(hint),
          style: Roboto14_black,
          value: (listShow != null) ? value_category : value_trash,
          isExpanded: true, //ทำให้กว้าง
          //รายการที่กดเลือกได้
          items: listEZ
              ?.map(
                (value) => DropdownMenuItem(
                  value: value,
                  //กรณีที่อยากให้มี คำอธิบายด้านหลังก็ใส่ function มา
                  child: (listShow != null) ? listShow(value) : Text(value),
                ),
              )
              .toList(),
          onChanged: (value) {
            setState(() {
              //1. กรณีที่เป็นภารกิจ Trash
              if (listShow == null) {
                value_trash = value;
                onChangeOption!(mission: 'Trash', selectTrash: value);
                //2. กรณีที่เป็นภารกิจแบบ Recycle, Login
              } else {
                value_category = value;
                onChangeOption!(mission: value);
              }
            });
            print("valueEZ = ${value}");
          },
        ),
      ),
    );
  }

  //TODO 3: Option Category Select
  _build_CategoryDescription(option) {
    String? title;
    String? subtitle;

    if (option == 'Login') {
      title = 'Login';
      subtitle = 'จำนวนวันเช็คอินสะสม';
    } else if (option == 'Recycle') {
      title = 'Recycle';
      subtitle = 'จำนวนครั้งของการรีไซเคิลขยะ';
    } else if (option == 'Trash') {
      title = 'Trash';
      subtitle = 'จำนวนขยะโดยแยกประเภท';
    } else if (option == 'Level') {
      title = 'Level';
      subtitle = 'ระดับเลเวลบัญชี';
    } else {
      title = option;
      subtitle = '';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title!),
        Text(subtitle, style: Roboto14_gray),
      ],
    );
  }
}
