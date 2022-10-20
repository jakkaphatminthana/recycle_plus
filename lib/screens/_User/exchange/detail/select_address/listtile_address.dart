import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_User/exchange/detail/product_detail2.dart';
import 'package:recycle_plus/screens/_User/profile/address/dialog_edit.dart';

class ListTile_ProductAddress extends StatefulWidget {
  const ListTile_ProductAddress({
    Key? key,
    required this.address,
    required this.phone,
    required this.tag,
    this.number,
  }) : super(key: key);
  final address;
  final phone;
  final tag;
  final number;

  @override
  State<ListTile_ProductAddress> createState() =>
      _ListTile_ProductAddressState();
}

class _ListTile_ProductAddressState extends State<ListTile_ProductAddress> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 110,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F4F8),
          border: Border.all(
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              //TODO 1: Continer 80%
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //TODO 1.1: Tag Address
                    (widget.tag == "บ้าน")
                        ? _build_tag(
                            Icons.home,
                            const Color(0xFFFC5963),
                            'ที่อยู่บ้าน',
                          )
                        : (widget.tag == "ที่ทำงาน")
                            ? _build_tag(
                                Icons.business,
                                const Color(0xFFF6A94C),
                                'ที่ทำงาน',
                              )
                            : _build_tag(
                                Icons.location_pin,
                                const Color(0xFF288752),
                                'ที่อยู่จัดส่ง',
                              ),
                    const SizedBox(height: 5.0),

                    //TODO 1.2: Address Content
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: 100.0,
                        maxWidth: MediaQuery.of(context).size.width,
                      ),
                      child: Text(
                        widget.address,
                        style: Roboto14_black,
                      ),
                    ),

                    //TODO 1.3: Phone number
                    Row(
                      children: [
                        Text('เบอร์โทร: ', style: Roboto14_B_black),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            widget.phone,
                            style: Roboto14_black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              //TODO 2: Continer 10%
              Container(
                width: MediaQuery.of(context).size.width * 0.10,
                height: MediaQuery.of(context).size.height,
                child: const Icon(
                  Icons.arrow_forward_sharp,
                  color: Colors.black,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //=================================================================================================================
  Widget _build_tag(IconData iconEZ, Color colorEZ, title) {
    return Row(
      children: [
        FaIcon(
          iconEZ,
          color: colorEZ,
          size: 25,
        ),
        const SizedBox(width: 5.0),
        Text(
          '$title',
          style: GoogleFonts.getFont(
            'Roboto',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: colorEZ,
          ),
        ),
      ],
    );
  }
}
