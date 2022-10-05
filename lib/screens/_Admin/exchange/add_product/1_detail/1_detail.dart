import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recycle_plus/models/varidator.dart';
import 'package:recycle_plus/screens/_Admin/exchange/product_textfield.dart';

class AddProduct_detail extends StatefulWidget {
  AddProduct_detail({
    Key? key,
    required this.categoryEZ,
    required this.name,
    required this.description,
    required this.recommend,
  }) : super(key: key);

  TextEditingController categoryEZ = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController recommend = TextEditingController();

  @override
  State<AddProduct_detail> createState() => _AddProduct_detailState();
}

class _AddProduct_detailState extends State<AddProduct_detail> {
  //formkey = ตัวแสดงตัวแบบยูนืคของฟอร์มนี้
  final formKey = GlobalKey<ScaffoldState>();
  var check_recom = false;

  @override
  Widget build(BuildContext context) {
//======================================================================================================
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //TODO 1. Head recommend
          Text("จัดเรียงสินค้า", style: Roboto14_B_black),
          const SizedBox(height: 5.0),

          //TODO 2. Checkbox recommend
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Transform.scale(
                scale: 1.3,
                child: Checkbox(
                  value: check_recom,
                  activeColor: const Color(0xFF00883C),
                  onChanged: (checked) {
                    setState(() {
                      check_recom = checked!;
                      widget.recommend.text = "$checked";
                    });
                  },
                ),
              ),
              const Icon(Icons.favorite),
              const SizedBox(width: 5.0),
              Text("สินค้าแนะนำ", style: Roboto14_B_blackw500),
            ],
          ),
          const SizedBox(height: 5.0),

          //TODO 1. Head category
          Text("ประเภทสินค้า", style: Roboto14_B_black),
          const SizedBox(height: 5.0),

          //TODO 2. Choice category
          Row(
            children: [
              _buildChoice(state: "Limited", iconEZ: Icons.star_rounded),
              const SizedBox(width: 10.0),
              // _buildChoice(state: "Markable", iconEZ: Icons.recommend),
              // const SizedBox(width: 10.0),
              _buildChoice(state: "NFT", iconEZ: Icons.panorama),
            ],
          ),
          const SizedBox(height: 25.0),

          //TODO 3. Input Name Product
          TextFormField(
            controller: widget.name,
            obscureText: false,
            style: Roboto14_black,
            decoration: styleTextFieldNews(
              'Product Name',
              'ชื่อสินค้า',
            ),
          ),
          const SizedBox(height: 20.0),

          //TODO 4. Input Description Product
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //พื้นที่ขยายได้
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 400,
                  maxWidth: MediaQuery.of(context).size.width * 0.875,
                ),
                child: TextFormField(
                  //พิมพ์หลายบรรทัดได้
                  keyboardType: TextInputType.multiline,
                  controller: widget.description,
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
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }

  //============================================================================================
  Widget _buildChoice({state, iconEZ}) {
    return ChoiceChip(
      label: Text(
        state,
        style: (widget.categoryEZ.text == state)
            ? Roboto14_B_white
            : Roboto14_B_black,
      ),
      avatar: Icon(
        iconEZ,
        color: (widget.categoryEZ.text == state) ? Colors.white : Colors.black,
      ),
      backgroundColor: Colors.white,
      disabledColor: Colors.white,
      selectedColor: const Color(0xFF00883C),
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      elevation: 2,
      selected: (widget.categoryEZ.text == state ? true : false),
      onSelected: (value) {
        setState(() {
          widget.categoryEZ.text = state;
        });
      },
    );
  }
}
