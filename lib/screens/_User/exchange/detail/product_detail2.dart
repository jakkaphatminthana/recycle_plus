import 'package:flutter/material.dart';
import 'package:recycle_plus/models/varidator.dart';
import 'package:recycle_plus/screens/_User/exchange/detail/dialog_buy.dart';
import 'package:recycle_plus/screens/_User/exchange/detail/select_address/listtile_address.dart';
import 'package:recycle_plus/screens/_User/exchange/detail/select_address/product_address.dart';
import 'package:recycle_plus/screens/_User/exchange/detail/textfieldStyle.dart';
import 'package:recycle_plus/service/auth.dart';
import 'package:recycle_plus/service/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:walletconnect_secure_storage/walletconnect_secure_storage.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

import '../../../../components/font.dart';

class Member_ProductDetail2 extends StatefulWidget {
  const Member_ProductDetail2({
    Key? key,
    required this.data,
    required this.amounts,
    required this.total,
    required this.session,
    required this.ethClient,
    this.address,
    this.phone,
    this.tag,
  }) : super(key: key);
  final data;
  final amounts;
  final total;
  final session;
  final Web3Client ethClient;
  //select address
  final address;
  final phone;
  final tag;

  @override
  State<Member_ProductDetail2> createState() => _Member_ProductDetail2State();
}

class _Member_ProductDetail2State extends State<Member_ProductDetail2> {
//TODO : Blockchain past
//START ------------------------------------------------------------------------------------------------------------------

//END ------------------------------------------------------------------------------------------------------------------

  //formkey = ตัวแสดงตัวแบบยูนืคของฟอร์มนี้
  //db = ติดต่อ firebase
  //_auth = ติดต่อกับ auth
  final _formKey = GlobalKey<FormState>();
  DatabaseEZ db = DatabaseEZ.instance;
  AuthService _auth = AuthService();
  User? user = FirebaseAuth.instance.currentUser;

  String? selectMode = "รถขนส่ง";
  var address_store = '';
  var user_address;
  var typePickup;
  //var input_address;
  late TextEditingController input_address;

  //TODO : Get Address store
  Future<void> getAddressStore() async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc('trading')
        .snapshots()
        .listen((event) {
      setState(() {
        address_store = event.get('address');
      });
    });
  }

  Future<void> getUserDatabase(uid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .listen((event) {
      setState(() {
        user_address = event.get('address');
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getAddressStore();
    getUserDatabase(user!.uid);
  }

  @override
  Widget build(BuildContext context) {
    final image = widget.data!.get('image');
    final name = widget.data!.get('name');
    final product_amount = widget.data!.get('amount');

    //กำหนดที่อยู่เริ่มต้น หากมีอยู่ใน Firebase
    input_address = (user_address == null)
        ? TextEditingController(text: '') //ค่าเริ่มต้นตาม firebase
        : TextEditingController(text: user_address); //ค่าที่กำลังป้อน

    //==============================================================================================================
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF00883C),
          title: Text("รายละเอียดของรางวัล", style: Roboto16_B_white),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //TODO 1: Product Data
                      Text("สินค้าที่จะแลกเปลี่ยน", style: Roboto14_B_black),
                      const SizedBox(height: 5.0),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F2F3),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              //TODO 1.1: Image Product
                              Image.network(
                                image,
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                              ),

                              //TODO 1.2: Description
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //Title
                                    Text(
                                      name.length > 25
                                          ? name.substring(0, 25) + '..'
                                          : name,
                                      style: Roboto16_B_greenB,
                                    ),
                                    //Amount product
                                    Row(
                                      children: [
                                        Text(
                                          "จำนวน: ",
                                          style: Roboto14_B_black,
                                        ),
                                        const SizedBox(width: 5.0),
                                        Text(
                                          "${widget.amounts} ชิ้น",
                                          style: Roboto14_black,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5.0),

                                    //Token Product
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/image/token.png',
                                          width: 25,
                                          height: 25,
                                        ),
                                        const SizedBox(width: 5.0),
                                        Text(
                                          "-${widget.total} ฿RCC",
                                          style: Roboto14_B_red,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),

                      //TODO 2: Type Send Product
                      Text("วิธีการรับสินค้า", style: Roboto14_B_black),
                      const SizedBox(height: 5.0),
                      Row(
                        children: [
                          _buildChoice(
                            title: "รถขนส่ง",
                            iconEZ: FontAwesomeIcons.truck,
                          ),
                          const SizedBox(width: 10.0),
                          _buildChoice(
                            title: "เข้ามารับเอง",
                            iconEZ: FontAwesomeIcons.store,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),

                      //TODO 3: Input Address
                      (selectMode == "เข้ามารับเอง")
                          //TODO 3.1: Store Address
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              height: 80,
                              decoration: BoxDecoration(
                                color: const Color(0xFFf1f4f8),
                                border: Border.all(width: 1),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxHeight: 200.0,
                                        maxWidth:
                                            MediaQuery.of(context).size.width,
                                      ),
                                      child: Text(
                                        address_store,
                                        style: Roboto14_black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          //TODO 3.2: Select MyAddress
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //3.2.1 Select Address
                                TextButton(
                                  child: Text(
                                    'Select Address',
                                    style: Roboto16_BU_greenB,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Member_SelectAddress(
                                          data: widget.data,
                                          amounts: widget.amounts,
                                          total: widget.total,
                                          session: widget.session,
                                          ethClient: widget.ethClient,
                                        ),
                                      ),
                                    );
                                  },
                                ),

                                //3.2.2 Show Address
                                (widget.address == null)
                                    ? Container()
                                    : ListTile_ProductAddress(
                                        address: widget.address,
                                        phone: widget.phone,
                                        tag: widget.tag,
                                      ),
                              ],
                            ),
                      const SizedBox(height: 50.0),

                      //TODO 4: Button Buy
                      Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: MaterialButton(
                          minWidth: MediaQuery.of(context).size.width,
                          height: 50.0,
                          child: Text('แลกของรางวัล', style: Roboto18_B_white),
                          color: Colors.green,
                          elevation: 2.0,
                          disabledColor: Colors.grey,
                          //ตรวจสอบดูว่าเลือกที่อยู่หรือยัง
                          onPressed: (selectMode == "รถขนส่ง" &&
                                  widget.address == null)
                              ? null
                              : () {
                                  print('address_user = ${widget.address}');
                                  print('address_store = $address_store');

                                  if (selectMode == "รถขนส่ง") {
                                    print('input_address success');
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    setState(() {
                                      typePickup = "delivery";
                                    });

                                    //TODO 4.1 Dialog confrim
                                    showAlertDialog_Buy(
                                      context: context,
                                      ethClient: widget.ethClient,
                                      session: widget.session,
                                      productData: widget.data,
                                      price: widget.total,
                                      amounts: widget.amounts,
                                      product_amount: product_amount,
                                      type_pickup: typePickup,
                                      phone: widget.phone,
                                      address: (typePickup == "delivery")
                                          ? widget.address
                                          : address_store,
                                    );
                                  } else {
                                    print('address_store success');
                                    setState(() {
                                      typePickup = "pickup";
                                    });
                                    //TODO 4.1 Dialog confrim
                                    showAlertDialog_Buy(
                                      context: context,
                                      ethClient: widget.ethClient,
                                      session: widget.session,
                                      productData: widget.data,
                                      price: widget.total,
                                      amounts: widget.amounts,
                                      product_amount: product_amount,
                                      type_pickup: typePickup,
                                      phone: widget.phone,
                                      address: (typePickup == "delivery")
                                          ? widget.address
                                          : address_store,
                                    );
                                  }
                                },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //=================================================================================================================
  Widget _buildChoice({title, iconEZ}) {
    return ChoiceChip(
      label: Text(
        title,
        style: (selectMode == title) ? Roboto14_B_white : Roboto14_B_black,
      ),
      avatar: Icon(
        iconEZ,
        color: (selectMode == title) ? Colors.white : Colors.black,
        size: 20,
      ),
      backgroundColor: Colors.white,
      disabledColor: Colors.white,
      selectedColor: const Color(0xFF00883C),
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      elevation: 2,
      selected: (selectMode == title) ? true : false,
      onSelected: (value) {
        setState(() {
          selectMode = title;
        });
      },
    );
  }
}
