import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/service/wallet_connect.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:walletconnect_secure_storage/walletconnect_secure_storage.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:web3dart/web3dart.dart';

class Wallet_card extends StatefulWidget {
  Wallet_card({
    Key? key,
    required this.colorEZ,
  }) : super(key: key);

  final Color colorEZ;

  @override
  State<Wallet_card> createState() => _Wallet_cardState();
}

class _Wallet_cardState extends State<Wallet_card> {
  //ดึงไฟล์ service wallet
  Wallet_Connect wallet = Wallet_Connect.instance;

  //Contract nesecsarily
  late Client httpClient;
  late Web3Client ethClient;
  bool dataConnent = false;

  //Wallet Object
  late WalletConnect connector;
  String _account = '';
  String MyAddress = '';
  bool? statusConnect;
  var myBalance;

  //ตัวแปรที่ใช้เก็บเฉยๆ ไว้ส่งไปมา
  var _session;
  var _connector;
  var _uri;
  late Timer _timer;

  //TODO 1: User Wallet
  Future initWalletConnect() async {
    // Define a session storage
    final sessionStorage = WalletConnectSecureStorage();
    final session = await sessionStorage.getSession();

    //เชื่อมต่อ wallet ผ่านตัว walletconnect.org
    var connector = WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      session: session,
      sessionStorage: sessionStorage,
      clientMeta: const PeerMeta(
          name: 'TestMode',
          description: 'Connect application for lightWallet',
          url: 'https://walletconnect.org',
          icons: [
            'https://files.gitbook.com/v0/b/gitbook-legacy-files/o/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
          ]),
    );
    //set address
    setState(() {
      _account = session?.accounts.first ?? '';
      if (_account == '') {
        statusConnect = false;
      } else {
        _session = session;
        _connector = connector;
        statusConnect = true;
      }
    });

    //show address เมื่อเชื่อมต่อเรียบร้อย
    connector.registerListeners(
      onConnect: (status) {
        setState(() {
          _account = status.accounts[0];
        });
      },
    );

    print("_account = $_account");
    print("session = $session");
    print("sessionStorage = $sessionStorage");
    print("statuscheck = $statusConnect");
  }

  //TODO 2: Get Smartcontract from Remix <--------------------------------------
  Future<DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString('assets/abi.json');
    String contractAddress = "0x7B439D82F076e88AbC196B8D7861296EE413C47E";

    final contract = DeployedContract(
      ContractAbi.fromJson(abi, "RecycleToken"), //abi file
      EthereumAddress.fromHex(contractAddress), //contract address
    );

    return contract;
  }

  //TODO 3: น่าจะดึงสัญญามาเรียกใช้แบบ function <------------------------------------
  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    //โหลดสัญญามา
    final contract = await loadContract();
    //function in remix(ชื่อของฟังก์ชัน)
    final ethFunction = contract.function(functionName);
    //call function ในสัญญามาใช้ (contract, funtion, paramiter)
    final result = await ethClient.call(
      contract: contract,
      function: ethFunction,
      params: args,
    );

    return result;
  }

  //TODO 5: Funtion GetBalance
  Future<void> getBalance(String targetAddress) async {
    EthereumAddress address = EthereumAddress.fromHex(targetAddress);
    //ดึงตัว Function getBalance() ที่อยู่ใน Remix มาใช้
    //ปล. [] คือค่าว่าง
    List<dynamic> result = await query("balanceOf", [address]);

    setState(() {
      //setting decimal to int
      //setting decimal to int
      final numpow = BigInt.from(pow(10, 18));
      final pro = (result[0] / numpow).toString();
      final proDouble = double.parse(pro);
      final setDecimal = proDouble.toStringAsExponential(5);
      final valueDouble = double.parse(setDecimal);
      myBalance = valueDouble;
      dataConnent = true;
    });
  }

  //TODO 5: เรียกใช้ครั้งเดียว โดยจะเรียกใช้ทุกครั้งเมื่อมาหน้านี้
  @override
  void initState() {
    super.initState();
    initWalletConnect();

    httpClient = Client();
    ethClient = Web3Client(
      "https://ropsten.infura.io/v3/83b4a7881ea84cdfbf19a9de732dc800",
      httpClient,
    );

    _timer = Timer(Duration(seconds: 2), () {
      getBalance(_account);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var F5address = (_account != '') ? _account.substring(0, 6) : '';
    var B5address = (_account != '') ? _account.substring(36, 42) : '';
    //==============================================================================================================
    return GestureDetector(
      onTap: () {},
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
                              (_account == '')
                                  ? "ยังไม่ได้เชื่อมต่อ"
                                  : "$F5address...$B5address",
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
                    child: (_account == '')
                        ? Text(
                            "??? RCT",
                            style: Roboto16_B_greenB,
                          )
                        : (dataConnent != true)
                            ? const CircularProgressIndicator(
                                color: Colors.green,
                              )
                            : Text(
                                "$myBalance RCT",
                                style: Roboto16_B_greenB,
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
