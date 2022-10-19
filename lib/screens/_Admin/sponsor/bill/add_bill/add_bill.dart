import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/models/varidator.dart';
import 'package:recycle_plus/screens/_Admin/achievement/textStyleForm.dart';
import 'package:recycle_plus/screens/_Admin/sponsor/bill/admin_bill.dart';
import 'package:recycle_plus/screens/_Admin/tabbar_control.dart';
import 'package:recycle_plus/service/database.dart';
import 'package:uuid/uuid.dart';

class Admin_BillAdd extends StatefulWidget {
  const Admin_BillAdd({Key? key}) : super(key: key);
  //Location page
  static String routeName = "/Admin_BillAdd";

  @override
  State<Admin_BillAdd> createState() => _Admin_BillAddState();
}

class _Admin_BillAddState extends State<Admin_BillAdd> {
  //formkey = ตัวแสดงตัวแบบยูนืคของฟอร์มนี้
  //db = ติดต่อ firebase
  final formKey = GlobalKey<FormState>();
  DatabaseEZ db = DatabaseEZ.instance;

  TextEditingController title = TextEditingController();
  TextEditingController money = TextEditingController();

  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  //TODO 1: Pick File
  Future selectFile() async {
    //เลือกไฟล์
    final result = await FilePicker.platform.pickFiles();
    //ไม่ได้เลือกอะไรเลย
    if (result == null) return;
    //set value file
    setState(() {
      pickedFile = result.files.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    //===============================================================================================================
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF00883C),
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: Text("สร้างบิล", style: Roboto16_B_white),
          actions: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Admin_TabbarHome(0)),
                );
              },
            ),
          ],
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 30, 15, 15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //TODO 1: Upload File
                  GestureDetector(
                    onTap: () => (pickedFile == null) ? selectFile() : null,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 1,
                        ),
                      ),
                      //TODO 1.1: กรณีที่ยังไม่ได้เลือกไฟล์
                      child: (pickedFile == null)
                          ? Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //1. Icon
                                const Icon(
                                  Icons.add_box,
                                  color: Colors.black,
                                  size: 45,
                                ),
                                const SizedBox(width: 5.0),

                                //2. Text upload
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Upload file',
                                        style: Roboto18_B_black),
                                    Text('ไฟล์ขนาดไม่เกิน 5 MB',
                                        style: Roboto12_black),
                                  ],
                                ),
                              ],
                            )
                          //TODO 1.2: กรณีที่เลือกไฟล์
                          : Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //1. Icon
                                const Icon(
                                  Icons.insert_drive_file,
                                  color: Colors.black,
                                  size: 45,
                                ),
                                const SizedBox(width: 5.0),

                                //2. file name
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxHeight: 200.0,
                                        maxWidth:
                                            MediaQuery.of(context).size.width,
                                      ),
                                      child: Text(
                                        pickedFile!.name,
                                        style: Roboto12_black,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 5.0),

                                //3.delete file
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      pickedFile = null;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  //TODO 2: Head Detail
                  Text('รายละเอียด', style: Roboto14_B_black),
                  const SizedBox(height: 20.0),

                  //TODO 3.1 Input Title
                  TextFormField(
                    controller: title,
                    obscureText: false,
                    style: Roboto14_black,
                    maxLength: 40,
                    decoration: styleTextFieldAchi(
                      'Header',
                      'หัวข้อของบิลนี้',
                    ),
                    validator: ValidatorEmpty,
                    onSaved: (value) => title.text = value!,
                  ),
                  const SizedBox(height: 20.0),

                  //TODO 3.2: Input Number to Finish
                  TextFormField(
                    controller: money,
                    obscureText: false,
                    style: Roboto14_black,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: styleTextFieldAchi(
                      'Total',
                      'จำนวนเงินที่ใช้',
                    ),
                    maxLength: 10,
                    validator: ValidatorEmpty,
                    onSaved: (value) => money.text = value!,
                  ),
                  const SizedBox(height: 20.0),

                  //TODO 4: Button
                  Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      height: 50.0,
                      child: Text('สร้างบิล', style: Roboto18_B_white),
                      color: Colors.green,
                      elevation: 2.0,
                      disabledColor: Colors.grey,
                      onPressed: () async {
                        //TODO : About Upload Firebase -----------------------------------------------<<<<
                        if (formKey.currentState!.validate()) {
                          //สั่งประมวลผลข้อมูลที่กรอก
                          formKey.currentState?.save();

                          //generate ID เพื่อใช้สร้าง id unique
                          var uid = Uuid();
                          String uuid = uid.v1();
                          int money_int = int.parse(money.text);

                          //เลือกไฟล์แล้วยัง?
                          if (pickedFile == null) {
                            Fluttertoast.showToast(
                              msg: "โปรดเลือกไฟล์",
                              gravity: ToastGravity.BOTTOM,
                            );
                          } else {
                            //อัพโหลดไฟล์ลง storage
                            var file_URL = await uploadFile(
                              fileEZ: pickedFile,
                              uploadTask: uploadTask,
                              uid: uuid,
                            );

                            await db
                                .createBill(
                              uid: uuid,
                              file: file_URL,
                              title: title.text,
                              money: money_int,
                            )
                                .then((value) {
                              print('add success');
                              Navigator.pushReplacementNamed(
                                  context, Admin_BillScreen.routeName);
                            }).catchError((e) => print('error add: $e'));
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //==============================================================================================================
  //TODO : Upload File to FireStorage
  Future uploadFile({
    required fileEZ,
    required uploadTask,
    required uid,
  }) async {
    final path = 'bill/$uid.pdf';
    final file = File(fileEZ.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask.whenComplete(() => null);

    final urlDownload = await snapshot.ref.getDownloadURL();
    print('url = $urlDownload');
    return urlDownload;
  }
}
