import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:recycle_plus/components/appbar_title.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/models/varidator.dart';
import 'package:recycle_plus/screens/_Admin/news/textfieldStyle.dart';

class Admin_NewsAdd extends StatefulWidget {
  //Location page
  static String routeName = "/Admin_AddNewsItem";

  @override
  State<Admin_NewsAdd> createState() => _Admin_NewsAddState();
}

class _Admin_NewsAddState extends State<Admin_NewsAdd> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //TODO 1. Appbar header
      appBar: AppBar(
        backgroundColor: const Color(0xFF00883C),
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const AppbarTitle(),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: ElevatedButton(
                child: Text("เผยแพร่", style: Roboto14_B_white),
                style: ElevatedButton.styleFrom(primary: Colors.amber),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10.0),
                    Text("เพิ่มข่าวสาร", style: Roboto18_B_black),
                    const SizedBox(height: 20.0),

                    //TODO 2. Upload File
                    Container(
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add_circle,
                            color: Color(0xCD00883C),
                            size: 70,
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                5, 10, 5, 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Upload image', style: Roboto16_B_black),
                                Text('ขนาดไม่เกิน 20 MB',
                                    style: Roboto12_black),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30.0),

                    //TODO 3. Textfield Title
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextFormField(
                        obscureText: false,
                        style: Roboto16_black,
                        decoration: styleTextFieldNews(
                          'Title',
                          'เพิ่มหัวเรื่องข่าว',
                        ),
                        validator: ValidatorEmpty,
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
                              //พิมพ์หลายบรรทัดได้
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              minLines: 1,
                              style: Roboto16_black,
                              decoration: styleTextFieldNews(
                                'Content',
                                'เพิ่มเนื้อหาของข่าวสาร',
                              ),
                              validator: ValidatorEmpty,
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
    );
  }
}
