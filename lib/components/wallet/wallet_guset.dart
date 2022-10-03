import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/login_no/login_no.dart';
import 'package:recycle_plus/screens/wallet/wallet_connecting.dart';
import 'package:recycle_plus/service/wallet_smartcontract.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:walletconnect_secure_storage/walletconnect_secure_storage.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Wallet_cardGuset extends StatefulWidget {
  Wallet_cardGuset({
    Key? key,
    required this.colorEZ,
  }) : super(key: key);

  final Color colorEZ;

  @override
  State<Wallet_cardGuset> createState() => _Wallet_cardGusetState();
}

class _Wallet_cardGusetState extends State<Wallet_cardGuset> {
  @override
  Widget build(BuildContext context) {
    //==============================================================================================================
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, PleaseLogin.routeName);
      },
      child: Material(
        color: Colors.transparent,
        elevation: 2.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.82,
          height: 75,
          decoration: BoxDecoration(
              color: widget.colorEZ,
              borderRadius: BorderRadius.circular(15.0),
              shape: BoxShape.rectangle,
              border: Border.all(color: Colors.black, width: 1.0)),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.40,
                  height: MediaQuery.of(context).size.height,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      //TODO 1. Token image
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Image.asset(
                          "assets/image/token.png",
                          width: 45,
                          height: 45,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10.0),

                      //TODO 2. Text Wallet
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Text(
                              "MyWallet",
                              textAlign: TextAlign.start,
                              style: Roboto16_B_black,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Text(
                              "ยังไม่ได้เชื่อมต่อ",
                              textAlign: TextAlign.start,
                              style: Roboto12_black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                //TODO 3. Token Amount
                Expanded(
                  child: Align(
                    alignment: const AlignmentDirectional(0.2, 0),
                    child: Text(
                      "Not Connected",
                      style: Roboto16_B_red,
                    ),
                  ),
                ),

                //TODO 4. arrow icon
                const Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Icon(
                    Icons.arrow_forward_ios,
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
}
