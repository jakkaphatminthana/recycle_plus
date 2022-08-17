import 'package:flutter/material.dart';
import 'package:recycle_plus/components/blockchain/dialog_help.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:flutter_web3/flutter_web3.dart';

class Test_Blockchian extends StatefulWidget {
  const Test_Blockchian({Key? key}) : super(key: key);
  //Location page
  static String routeName = "/TestBlockchain";

  @override
  State<Test_Blockchian> createState() => _Test_BlockchianState();
}

class _Test_BlockchianState extends State<Test_Blockchian> {
  var _account = "";
  var _balanceEth = "";
  var _balanceUSD = "";
  bool _isConnected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            //TODO : Connect Wallet
            Text("asdasdasdasd"),
            TextButton(
              child: Text("Connect Wallet", style: Roboto16_B_green),
              onPressed: () async {
                //มีตัว MetaMask อยู่ในเครื่องไหม
                if (ethereum == null) {
                  showDialogError(
                      context: context, message: "You don't have MetaMask");
                  return;
                }
                //account
                final accounts = await ethereum!.requestAccount();
                setState(() {
                  _account = accounts[0];
                });
              },
            ),

            //TODO : Show Data
            Text(_account, style: Roboto16_black),
          ],
        ),
      ),
    );
  }
}
