import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recycle_plus/models/varidator.dart';
import 'package:recycle_plus/screens/_Admin/exchange/add_product/1_detail/product_textfield.dart';

class AddProduct_detail extends StatefulWidget {
  AddProduct_detail({
    Key? key,
    required this.categoryEZ,
    required this.name,
    required this.description,
  }) : super(key: key);

  TextEditingController categoryEZ = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();

  @override
  State<AddProduct_detail> createState() => _AddProduct_detailState();
}

class _AddProduct_detailState extends State<AddProduct_detail> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<ScaffoldState>();

//======================================================================================================
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //TODO 1.Header Image
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("อัปโหลดรูปภาพ", style: Roboto14_B_black),
            ],
          ),
          const SizedBox(height: 5.0),

          //TODO 2. Upload Image
          GestureDetector(
            onTap: () {},
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.image,
                    color: Color(0xFFD1D1D1),
                    size: 30,
                  ),
                  const SizedBox(width: 10.0),
                  Text("Adding your image", style: Roboto14_B_brightGray),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20.0),

          //TODO 3. Head category
          Text("ประเภทสินค้า", style: Roboto14_B_black),
          const SizedBox(height: 5.0),

          //TODO 4. Choice category
          Row(
            children: [
              _buildChoice(state: "Normal", iconEZ: Icons.circle),
              const SizedBox(width: 10.0),
              _buildChoice(state: "Limited", iconEZ: Icons.star_rounded),
              const SizedBox(width: 10.0),
              _buildChoice(state: "NFT", iconEZ: Icons.panorama),
            ],
          ),
          const SizedBox(height: 25.0),

          //TODO 5. Input Name Product
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

          //TODO 5. Input Name Product
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
