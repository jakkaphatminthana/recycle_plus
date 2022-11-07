import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_User/exchange/detail/product_detail2.dart';
import 'package:recycle_plus/screens/_User/profile/address/dialog_edit.dart';

class ListTile_SelectAddress extends StatefulWidget {
  const ListTile_SelectAddress({
    Key? key,
    required this.data_address,
    required this.address,
    required this.phone,
    required this.tag,
    required this.number,
    required this.data,
    required this.amounts,
    required this.total,
    required this.session,
    required this.ethClient,
  }) : super(key: key);
  final data_address;
  final address;
  final phone;
  final tag;
  final number;

  final data;
  final amounts;
  final total;
  final session;
  final ethClient;

  @override
  State<ListTile_SelectAddress> createState() => _ListTile_SelectAddressState();
}

class _ListTile_SelectAddressState extends State<ListTile_SelectAddress> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Member_ProductDetail2(
              data: widget.data,
              amounts: widget.amounts,
              total: widget.total,
              session: widget.session,
              ethClient: widget.ethClient,
              address: widget.address,
              phone: widget.phone,
              tag: widget.tag,
            ),
          ),
        );
      },
      child: Padding(
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
                  width: MediaQuery.of(context).size.width * 0.78,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //TODO 1.1: Tag Address
                      (widget.tag == "Home")
                          ? _build_tag(
                              Icons.home,
                              const Color(0xFFFC5963),
                              'Home',
                            )
                          : (widget.tag == "Work")
                              ? _build_tag(
                                  Icons.business,
                                  const Color(0xFFF6A94C),
                                  'Work',
                                )
                              : (widget.tag == "")
                                  ? _build_tag(
                                      Icons.location_pin,
                                      const Color(0xFF288752),
                                      'Address',
                                    )
                                  : _build_tag(
                                      Icons.location_pin,
                                      const Color(0xFF288752),
                                      '${widget.tag}',
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
                  width: MediaQuery.of(context).size.width * 0.12,
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
          (title != "Home" && title != "Work" && title != "Address")
              ? title
              : '$title ${widget.number}',
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
