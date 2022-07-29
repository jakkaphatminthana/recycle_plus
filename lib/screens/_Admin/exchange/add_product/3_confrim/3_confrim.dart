import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddProduct_Confrim extends StatefulWidget {
  AddProduct_Confrim({
    Key? key,
    required this.category,
    required this.name,
    required this.description,
    required this.price,
    required this.amount,
    required this.pickup,
    required this.delivery,
  }) : super(key: key);

  TextEditingController category = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController pickup = TextEditingController();
  TextEditingController delivery = TextEditingController();

  @override
  State<AddProduct_Confrim> createState() => _AddProduct_ConfrimState();
}

class _AddProduct_ConfrimState extends State<AddProduct_Confrim> {
  //formkey = ตัวแสดงตัวแบบยูนืคของฟอร์มนี้
  final formKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    //===================================================================================================
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 10.0),
          Stack(
            children: [
              //TODO 1: ประเภทสินค้า
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildValue(
                      title: "สินค้าประเภท", value: widget.category.text),

                  //TODO 2: Status การส่งของ
                  Row(
                    children: [
                      _buildStatusIcon(
                        StatusEZ: widget.pickup.text,
                        iconEZ: FontAwesomeIcons.store,
                      ),
                      const SizedBox(width: 5.0),
                      _buildStatusIcon(
                        StatusEZ: widget.delivery.text,
                        iconEZ: FontAwesomeIcons.truck,
                      ),
                    ],
                  ),
                ],
              ),

              //TODO 3: Price
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: _buildValue(title: "ราคา", value: widget.price.text),
              ),

              //TODO 4: Amount
              Padding(
                padding: const EdgeInsets.only(top: 55.0),
                child: _buildValue(title: "จำนวน", value: widget.amount.text),
              ),
            ],
          ),
          const SizedBox(height: 20.0),

          //TODO 5: รายละเอียด
          Text("รายละเอียดสินค้า", style: Roboto16_B_black),
          const SizedBox(height: 5.0),
          const Divider(
            height: 1.0,
            thickness: 2.0,
            color: Color(0xFFC3C3C3),
          ),
          const SizedBox(height: 5.0),

          //TODO 6: Name
          // _buildValue(title: "ชื่อสินค้า", value: widget.name.text),
          (widget.name.text.length <= 25)
              //1. ข้อมูลไม่ยาวเกินไป
              ? _buildValue(title: "ชื่อสินค้า", value: widget.name.text)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("ชื่อสินค้า : ", style: Roboto16_B_black),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 3.0, 0, 0),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: 1000.0,
                          maxWidth: MediaQuery.of(context).size.width,
                        ),
                        child: Text(
                          widget.name.text,
                          style: Roboto16_green,
                        ),
                      ),
                    ),
                  ],
                ),

          //TODO 7: Descirption
          (widget.description.text.length <= 25)
              //1. ข้อมูลไม่ยาวเกินไป
              ? _buildValue(title: "คำอธิบาย", value: widget.description.text)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("คำอธิบาย : ", style: Roboto16_B_black),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 3.0, 0, 0),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: 1000.0,
                          maxWidth: MediaQuery.of(context).size.width,
                        ),
                        child: Text(
                          widget.description.text,
                          style: Roboto16_green,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    const Divider(
                      height: 1.0,
                      thickness: 2.0,
                      color: Color(0xFFC3C3C3),
                    ),
                    const SizedBox(height: 5.0),
                  ],
                ),
        ],
      ),
    );
  }

//=================================================================================================

  //TODO : Text + Value
  Widget _buildValue({title, value}) {
    return Row(
      children: [
        Text("$title : ", style: Roboto16_B_black),
        Padding(
          padding: const EdgeInsets.only(top: 3.0),
          child: Text(value, style: Roboto16_green),
        )
      ],
    );
  }

  //TODO : Icon Status
  Widget _buildStatusIcon(
      {required String StatusEZ, required IconData iconEZ}) {
    return CircleAvatar(
      backgroundColor:
          (StatusEZ == "true") ? const Color(0xFF00883C) : Colors.grey,
      radius: 17,
      child: FaIcon(
        iconEZ,
        size: 17,
        color: (StatusEZ == "true") ? Colors.white : Colors.black,
      ),
    );
  }
}
