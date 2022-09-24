import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recycle_plus/models/news_model.dart';
import 'package:recycle_plus/models/varidator.dart';
import 'package:recycle_plus/screens/_Admin/news/textfieldStyle.dart';
import 'package:recycle_plus/screens/_Admin/tabbar_control.dart';
import 'package:recycle_plus/service/database.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../components/font.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Admin_NewsEdit extends StatefulWidget {
  //ก่อนจะเรียกหน้านี้จำเป็นต้องมี paramiter data
  const Admin_NewsEdit({required this.data});
  final data; //data Querysnapshot

  @override
  State<Admin_NewsEdit> createState() => _Admin_NewsEditState();
}

class _Admin_NewsEditState extends State<Admin_NewsEdit> {
  //formkey = ตัวแสดงตัวแบบยูนืคของฟอร์มนี้
  //db = ติดต่อ firebase
  final _formKey = GlobalKey<FormState>();
  DatabaseEZ db = DatabaseEZ.instance;

  //TFC_Title = ใช้เก็บค่า textfield ของ Title
  //TFC_Content = ใช้เก็บค่า textfield ของ Content
  late TextEditingController _TFC_Title;
  late TextEditingController _TFC_Content;

  String? value_title;
  String? value_content;
  String? image_name;

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
        this.image_name = basename;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleFB = widget.data!.get("title");
    final contentFB = widget.data!.get("content");
    var imageFB = widget.data!.get("image");

    //กำหนดค่าเริ่มต้นของ textfield ให้แสดงเป็นไปตามข้อมูล firebase
    _TFC_Title = (value_title == null)
        ? TextEditingController(text: titleFB) //ค่าเริ่มต้นตาม firebase
        : TextEditingController(text: value_title); //ค่าที่กำลังป้อน

    _TFC_Content = (value_content == null)
        ? TextEditingController(text: contentFB) //ค่าเริ่มต้นตาม firebase
        : TextEditingController(text: value_content); //ค่าที่กำลังป้อน

    //==========================================================================================
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        //TODO 1. Appbar header
        appBar: AppBar(
          backgroundColor: const Color(0xFF00883C),
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: Text("แก้ไขข่าวสาร", style: Roboto16_B_white),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.save,
                color: Colors.white,
                size: 33,
              ),
              onPressed: () async {
                await UpdateNews(imageFB: imageFB);
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
        //---------------------------------------------------------------------------------------
        body: Form(
          key: _formKey,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 20.0),

                        //TODO 2. Upload Image
                        GestureDetector(
                          onTap: () => pickImage(), //เลือกรูปภาพ
                          child: Container(
                            width: 200,
                            height: 100,
                            decoration: BoxDecoration(
                              color: const Color(0xFFfafafa),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(1, 2),
                                  blurRadius: 4,
                                ),
                              ],
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            //TODO : ตรวจสอบว่าได้เลือกรูปภาพ หรือยัง
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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

                                    //3. ลบรูปภาพออก และไม่ได้เลือกรูปอะไรเลย
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.add_circle,
                                            color: Color(0xCD00883C),
                                            size: 70,
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(5, 10, 5, 10),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('Upload image',
                                                    style: Roboto16_B_black),
                                                Text('ขนาดไม่เกิน 20 MB',
                                                    style: Roboto12_black),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                          ),
                        ),
                        const SizedBox(height: 10.0),

                        //TODO : ชื่อไฟล์รุปภาพ
                        Center(
                          //หากเลือกรูปภาพใหม่ หรือ มีรูปภาพในระบบ ก็ให้แสดงชื่อไฟล์
                          child: (value_image != null)
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      image_name!,
                                      style: Roboto12_black,
                                    ),
                                    const SizedBox(height: 5.0),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          child: const Icon(
                                            Icons.replay_circle_filled,
                                            color: Color(0xFFE0AB3A),
                                            size: 40,
                                          ),
                                          onTap: () {
                                            pickImage();
                                          },
                                        ),
                                        const SizedBox(width: 10.0),
                                        GestureDetector(
                                          child: const Icon(
                                            Icons.cancel,
                                            color: Color(0xFFff5963),
                                            size: 40,
                                          ),
                                          onTap: () {
                                            setState(() {
                                              value_image = null;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : (value_image == null && imageFB != null)
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              child: const Icon(
                                                Icons.replay_circle_filled,
                                                color: Color(0xFFE0AB3A),
                                                size: 40,
                                              ),
                                              onTap: () {
                                                pickImage();
                                              },
                                            ),
                                            const SizedBox(width: 10.0),
                                            GestureDetector(
                                              child: const Icon(
                                                Icons.cancel,
                                                color: Color(0xFFff5963),
                                                size: 40,
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  imageFB = null;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  : null,
                        ),
                        const SizedBox(height: 30.0),

                        //TODO 3. Textfield Title
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: TextFormField(
                            controller: _TFC_Title,
                            obscureText: false,
                            style: Roboto14_black,
                            decoration: styleTextFieldNews(
                              'Title',
                              'เพิ่มหัวเรื่องข่าว',
                            ),
                            validator: ValidatorEmpty,
                            onSaved: (value) => value_title = value,
                            onChanged: (value) => value_title = value,
                          ),
                        ),
                        const SizedBox(height: 20.0),

                        //TODO 4. Textfield content
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
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
                                  controller: _TFC_Content,
                                  //พิมพ์หลายบรรทัดได้
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  minLines: 1,
                                  style: Roboto14_black,
                                  decoration: styleTextFieldNews(
                                    'Content',
                                    'เพิ่มเนื้อหาของข่าวสาร',
                                  ),
                                  validator: ValidatorEmpty,
                                  onSaved: (value) => value_content = value,
                                  onChanged: (value) => value_content = value,
                                ),
                              ),
                            ],
                          ),
                        ),
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

  //===================================================================================================
//TODO 1: อัพโหลด ภาพลงใน Storage ใน firebase
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
          .child("images/news/$uid") //แหล่งเก็บภาพนี้
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

  //TODO 2: Update News
  UpdateNews({imageFB}) async {
    //เมื่อกรอกข้อมูลถูกต้อง
    if (_formKey.currentState!.validate()) {
      //สั่งประมวลผลข้อมูลที่กรอก
      _formKey.currentState?.save();
      // print("imageFB = $imageFB");
      // print("value_image = $value_image");

      // print("value_title = $value_title");
      // print("value_content = $value_content");

      //ถ้าเปลี่ยนรูป ก็ต้องอัพโหลดรูปใหม่อีก
      if (value_image != null) {
        print("start to upload");
        var image_url = await uploadImage(
          gallery: image_path,
          image: image_file,
          img_name: image_name,
          uid: widget.data!.get('id'),
        );

        //TODO 2.1: upload on firebase
        await db
            .updateNews(
              newsID: NewsModel(id: widget.data!.get("id")),
              titleEZ: NewsModel(title: value_title),
              contentEZ: NewsModel(content: value_content),
              imageEZ: NewsModel(image: image_url),
            )
            .then(
              (value) => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Admin_TabbarHome(1), //หน้า News
                ),
              ),
            )
            .catchError(
              (error) => const Text(
                "Something is wrong please try again",
              ),
            );
        //ถ้าใช้รูปเดิม เปลี่ยนแค่เนื้อหา
      } else {
        //TODO 2.2: upload on firebase
        await db
            .updateNews(
              newsID: NewsModel(id: widget.data!.get("id")),
              titleEZ: NewsModel(title: value_title),
              contentEZ: NewsModel(content: value_content),
              imageEZ: NewsModel(image: imageFB),
            )
            .then(
              (value) => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Admin_TabbarHome(1), //หน้า News
                ),
              ),
            )
            .catchError(
              (error) => const Text(
                "Something is wrong please try again",
              ),
            );
      }
    }
  }

  //TODO 3: Alert Dialog Delete
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
        await DeleteNews(news_ID: widget.data!.get('id'));
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

  //TODO : Delete Product(Hide)
  DeleteNews({news_ID}) async {
    await db.updateNewsStatus(news_ID: news_ID, value: false).then((value) {
      print('delete news success');
      Navigator.of(context).pop();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Admin_TabbarHome(1), //หน้า Exchange
        ),
      );
    }).catchError((err) => print('delete fail: $err'));
  }
}
