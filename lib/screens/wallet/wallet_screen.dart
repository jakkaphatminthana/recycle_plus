import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/service/wallet_smartcontract.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:walletconnect_secure_storage/walletconnect_secure_storage.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WalletScreen extends StatefulWidget {
  WalletScreen({
    Key? key,
    required this.connector,
    required this.session,
  }) : super(key: key);

  //TODO : Wallet Data
  WalletConnect connector;
  final session;

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  //Contract nesecsarily
  late Client httpClient;
  late Web3Client ethClient;
  bool dataConnent = false;
  var myBalance;
  String? txHash;
  //ไว้ป้อนและเก็บค่าเพื่อใช้ต่อ
  var MyAddress = '';
  bool isloading = false;
  final privateK = dotenv.env["METAMASK_PRIVATE_KEY"];
  final infura = dotenv.env["INFURA_ROPSTEN_ADDRESS"];

  //TODO 1: Always call first run
  @override
  void initState() {
    super.initState();
    MyAddress = widget.connector.session.accounts[0];
    print("MyAddress: $MyAddress");

    //Rospten Infura
    httpClient = Client();
    ethClient = Web3Client("$infura", httpClient);

    getBalance(MyAddress);
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

  //TODO 4: ลงชื่ออนุญาติในสัญญาที่เป็นแบบ write <------------------------------------
  Future<String> submit(String functionName, List<dynamic> args) async {
    //private key ของกระเป๋าเราคือ
    EthPrivateKey credentials = EthPrivateKey.fromHex(privateK!);

    //โหลดตัวสัญญามาใช้ contract
    DeployedContract contract = await loadContract();
    //เรียกใช้ function ที่อยู่ในสัญญาด้วย functionName
    final ethFunction = contract.function(functionName);

    //send function ในสัญญามาใช้ (contract, funtion, paramiter)
    //โดยจำเป็นต้องใช้ private key ด้วยในการทำธุรกรรมที่เป็นแบบ write
    final result = await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: ethFunction,
        parameters: args,
        maxGas: 200000,
      ),
      //this contract for only chainID 3 เท่านั้น
      fetchChainIdFromNetworkId: false,
      chainId: 3,
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

  @override
  Widget build(BuildContext context) {
    //==============================================================================================================
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF00883C),
          centerTitle: true,
          title: Text("My Wallet", style: Roboto16_B_white),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // //TODO 1: Kill Session
              // MaterialButton(
              //   child: const Text("KillSession"),
              //   onPressed: () {
              //     widget.connector.killSession();
              //     widget.connector.sessionStorage?.removeSession();
              //   },
              //   color: Colors.redAccent,
              // ),
              //TODO : Contaner Header
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFF30AE68),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    //TODO : Balance
                    const SizedBox(height: 30.0),
                    Text("Balance", style: Roboto12_B_black),
                    const SizedBox(height: 5.0),
                    (dataConnent)
                        ? Text("$myBalance RCT", style: Roboto20_B_black)
                        : const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                    const SizedBox(height: 15.0),

                    //TODO : Address wallet
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: MyAddress))
                            .then((value) {
                          Fluttertoast.showToast(
                            msg: "Copy to clipboard",
                            gravity: ToastGravity.BOTTOM,
                          );
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFFF1F2F3),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.content_copy,
                              color: Colors.black,
                              size: 15,
                            ),
                            const SizedBox(width: 5.0),
                            Text(
                              MyAddress,
                              style: Roboto12_black,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),

                    //TODO : Button
                    ElevatedButton.icon(
                      label: Text("Refesh", style: Roboto14_B_white),
                      icon: const Icon(
                        Icons.refresh,
                        size: 15,
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                      ),
                      onPressed: () async {
                        setState(() {
                          dataConnent = false;
                        });
                        await getBalance(MyAddress);
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30.0),

              //TODO : Transaction
              Text("Transaction", style: Roboto18_B_black),
              const Divider(
                height: 10,
                thickness: 1,
                color: Colors.black,
              ),
              const SizedBox(height: 15.0),

              //TODO : List Transaction
              Column(
                children: [
                  const Icon(
                    Icons.insert_drive_file_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 5.0),
                  Text("Not found", style: Roboto20_grey),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
