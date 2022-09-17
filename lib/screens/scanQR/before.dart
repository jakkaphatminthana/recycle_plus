import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recycle_plus/screens/scanQR/trash_reward.dart';
import 'package:uuid/uuid.dart';

class TestSend extends StatefulWidget {
  const TestSend({Key? key}) : super(key: key);

  @override
  State<TestSend> createState() => _TestSendState();
}

class _TestSendState extends State<TestSend> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          MaterialButton(
            child: Text('Upload image'),
            onPressed: () {
              pickImage();
            },
          ),
          MaterialButton(
            child: Text('Send data'),
            onPressed: () {
              print('image: $value_image');

              var uid = Uuid();
              final uuid = uid.v1();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RewardWidget(
                    trash_id: 'PP',
                    image_uid: uuid,
                    trash_image: value_image,
                    trash_image_path: image_path,
                    trash_image_file: image_file,
                    trash_amount: 1,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
