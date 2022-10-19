import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/models/varidator.dart';
import 'package:recycle_plus/screens/_Admin/achievement/textStyleForm.dart';
import 'package:recycle_plus/screens/_Admin/sponsor/bill/edit_bill/dialog_delete.dart';
import 'package:recycle_plus/service/database.dart';

class Admin_BillEdit extends StatefulWidget {
  const Admin_BillEdit({Key? key, required this.data}) : super(key: key);
  final data;

  @override
  State<Admin_BillEdit> createState() => _Admin_BillEditState();
}

class _Admin_BillEditState extends State<Admin_BillEdit> {
  //formkey = ตัวแสดงตัวแบบยูนืคของฟอร์มนี้
  //db = ติดต่อ firebase
  final formKey = GlobalKey<FormState>();
  DatabaseEZ db = DatabaseEZ.instance;

  TextEditingController TC_title = TextEditingController();
  TextEditingController TC_money = TextEditingController();

  //New Value
  var value_title;
  var value_money;

  //Pick file
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  var file_name;

  //TODO 1: Picker File
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
    final titleFB = widget.data!.get('title');
    final fileFB = widget.data!.get('file');
    final timeFB = widget.data!.get('timestamp');
    final moneyFB = widget.data!.get('money');

    //กำหนดค่าเริ่มต้นของ textfield ให้แสดงเป็นไปตามข้อมูล firebase
    TC_title = (value_title == null)
        ? TextEditingController(text: titleFB) //ค่าเริ่มต้นตาม firebase
        : TextEditingController(text: value_title); //ค่าที่กำลังป้อน
    TC_money = (value_money == null)
        ? TextEditingController(text: "$moneyFB") //ค่าเริ่มต้นตาม firebase
        : TextEditingController(text: value_money); //ค่าที่กำลังป้อน

    (file_name == null) ? GetFileStorage(fileFB) : null;
    //=============================================================================================================
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF00883C),
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: Text("แก้ไขข้อมูลบิล", style: Roboto16_B_white),
          actions: [
            //TODO 1.1: Save Icon
            IconButton(
              icon: const Icon(
                Icons.save,
                color: Colors.white,
                size: 33,
              ),
              onPressed: () async {},
            ),

            //TODO 1.2 Delete Icon
            IconButton(
              icon: const Icon(
                Icons.delete_forever_rounded,
                color: Colors.white,
                size: 35,
              ),
              onPressed: () {
                showDialogBill_Delete(
                    context: context, bill_ID: widget.data.id);
              },
            ),
          ],
        ),
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 30, 15, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //TODO 2: Input File
                  _build_FilePicker(fileFB),
                  const SizedBox(height: 20.0),

                  //TODO 2: Head Detail
                  Text('รายละเอียด', style: Roboto14_B_black),
                  const SizedBox(height: 20.0),

                  //TODO 3.1 Input Title
                  TextFormField(
                    controller: TC_title,
                    obscureText: false,
                    style: Roboto14_black,
                    maxLength: 40,
                    decoration: styleTextFieldAchi(
                      'Header',
                      'หัวข้อของบิลนี้',
                    ),
                    validator: ValidatorEmpty,
                    onSaved: (value) => value_title.text = value!,
                  ),
                  const SizedBox(height: 20.0),

                  //TODO 3.2: Input Number to Finish
                  TextFormField(
                    controller: TC_money,
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
                    onSaved: (value) => value_money.text = value!,
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //================================================================================================================
  //TODO 2.1: Widget pickFile
  Widget _build_FilePicker(fileFB) {
    return //TODO 2.2: Upload File
        GestureDetector(
      onTap: () => selectFile(),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 1,
          ),
        ),
        //TODO 2.3.1: กรณีที่ยังไม่ได้เลือกไฟล์
        child: (pickedFile == null)
            ? Row(
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
                          maxWidth: MediaQuery.of(context).size.width * 0.60,
                        ),
                        child: Text(
                          "$file_name",
                          style: Roboto12_black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 5.0),
                ],
              )
            //TODO 2.3.2: กรณีที่เลือกไฟล์
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
                          maxWidth: MediaQuery.of(context).size.width,
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
                      print("picker file = $pickedFile");
                      setState(() {
                        pickedFile = null;
                      });
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
      ),
    );
  }

  //===============================================================================================================
  //TODO : Get File from storage
  Future<void> GetFileStorage(url) async {
    Reference fileRef = await FirebaseStorage.instance.refFromURL(url);
    print("myFile = $fileRef");
    print("fileName = ${fileRef.name}");

    setState(() {
      file_name = fileRef.name;
    });
  }
}
