import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../product_textfield.dart';

class AddProduct_Setting extends StatefulWidget {
  AddProduct_Setting({
    Key? key,
    required this.price,
    required this.amount,
    required this.pickup,
    required this.delivery,
  }) : super(key: key);

  TextEditingController price = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController pickup = TextEditingController();
  TextEditingController delivery = TextEditingController();

  @override
  State<AddProduct_Setting> createState() => _AddProduct_SettingState();
}

class _AddProduct_SettingState extends State<AddProduct_Setting> {
  //formkey = ตัวแสดงตัวแบบยูนืคของฟอร์มนี้
  final formKey = GlobalKey<ScaffoldState>();
  bool pickupBool = false;
  bool deliveryBool = false;

  //TODO : เมื่อกด Switch
  onChangeStatus(bool newValue, String type) async {
    setState(() {
      if (type == "เข้ามารับเอง") {
        pickupBool = newValue;
        widget.pickup.text = "$newValue";
        widget.delivery.text = "$deliveryBool";
      } else if (type == "รถขนส่ง") {
        deliveryBool = newValue;
        widget.delivery.text = "$newValue";
        widget.pickup.text = "$pickupBool";
      }
    });
  }

//===========================================================================================
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("กำหนดสินค้า", style: Roboto14_B_black),
          const SizedBox(height: 20.0),

          //TODO 1. Input Price
          TextFormField(
            controller: widget.price,
            obscureText: false,
            keyboardType: TextInputType.number,
            // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: Roboto14_black,
            decoration: styleTextFieldNews(
              'Price',
              'กำหนดราคา เช่น 10.50',
            ),
          ),
          const SizedBox(height: 20.0),

          //TODO 2. Input Amount
          TextFormField(
            controller: widget.amount,
            obscureText: false,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: Roboto14_black,
            decoration: styleTextFieldNews(
              'Amount',
              'จำนวนสินค้า เช่น 20',
            ),
          ),
          const SizedBox(height: 20.0),

          Text("การนำส่งสินค้า", style: Roboto14_B_black),
          const SizedBox(height: 5.0),

          //TODO 3. CheckList
          _buildCheckList(
            "เข้ามารับเอง",
            pickupBool,
            const FaIcon(FontAwesomeIcons.store),
            onChangeStatus,
          ),
          _buildCheckList(
            "รถขนส่ง",
            deliveryBool,
            const FaIcon(FontAwesomeIcons.truck),
            onChangeStatus,
          ),
        ],
      ),
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
        print("picker = ${pickupBool}");
        print("delivery = ${deliveryBool}");
      },
    );
  }
}
