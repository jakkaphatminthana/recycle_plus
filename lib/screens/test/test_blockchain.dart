import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:walletconnect_secure_storage/walletconnect_secure_storage.dart';

class Test_Blockchian extends StatefulWidget {
  Test_Blockchian({
    Key? key,
    required this.connector,
    required this.session,
  }) : super(key: key);
  //Location page
  static String routeName = "/TestBlockchain";

  WalletConnect connector;
  final session;

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20.0),
          //TODO : Connect Wallet
          Text("My Wallet", style: Roboto16_B_black),
          const SizedBox(height: 30.0),

          Text('Sesstion', style: Roboto12_B_black),
          Text('${widget.session}'),
          const SizedBox(height: 20.0),

          Text('Connector.connected', style: Roboto12_B_black),
          Text('${widget.connector.connected}'),
          const SizedBox(height: 10.0),

          Text('Connector.address', style: Roboto12_B_black),
          Text('${widget.connector.session.accounts[0]}'),
          const SizedBox(height: 10.0),

          Text('Connector.sessionStorage', style: Roboto12_B_black),
          Text('${widget.connector.sessionStorage?.getSession()}'),
          const SizedBox(height: 50.0),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: const Text("Kill Session"),
                onPressed: () async {
                  widget.connector.killSession();
                  widget.connector.sessionStorage?.removeSession();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
