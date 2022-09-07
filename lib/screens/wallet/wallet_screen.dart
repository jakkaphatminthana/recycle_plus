import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/service/wallet_smartcontract.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:walletconnect_secure_storage/walletconnect_secure_storage.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:web3dart/contracts.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart' as web3;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:recycle_plus/service/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
  late web3.Web3Client ethClient;
  bool dataConnent = false;
  var myBalance;
  String? txHash;
  //ไว้ป้อนและเก็บค่าเพื่อใช้ต่อ
  var MyAddress = '';
  bool isloading = false;
  final privateK = dotenv.env["METAMASK_PRIVATE_KEY"];
  final infura = dotenv.env["INFURA_ROPSTEN_ADDRESS"];
  User? user = FirebaseAuth.instance.currentUser;
  var data_length;

  //TODO 1: Always call first run
  @override
  void initState() {
    super.initState();
    MyAddress = widget.connector.session.accounts[0];
    print("MyAddress: $MyAddress");

    //Rospten Infura
    httpClient = Client();
    ethClient = web3.Web3Client("$infura", httpClient);

    getBalance(MyAddress);
    getLengthData(user?.uid);
  }

  //TODO : Blockchain Past
  //START ------------------------------------------------------------------------------------------------------------
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
      web3.Transaction.callContract(
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

  //END ----------------------------------------------------------------------------------------------------------------

  //TODO : กำหนด Loading more
  var item_limit = 3;
  Timer? _timer;

  Future timeingLoad() async {
    _timer = Timer(const Duration(milliseconds: 1500), () {
      setState(() {
        isloading = false;
        item_limit += 3;
      });
    });
  }

  //TODO :
  Future<void> getLengthData(user) async {
    final _collection = FirebaseFirestore.instance
        .collection('users')
        .doc(user)
        .collection('wallet')
        .doc(MyAddress)
        .collection("transaction")
        .get();
    var result = await _collection.then((value) {
      data_length = value.size;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    final _collection = FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('wallet')
        .doc(MyAddress)
        .collection("transaction");

    final Stream<QuerySnapshot> _transaction = _collection
        .limit(item_limit)
        .orderBy('timestamp', descending: true)
        .snapshots();

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
              //TODO 2: Contaner Header
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFF30AE68),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    //TODO 3: Balance
                    const SizedBox(height: 30.0),
                    Text("Balance", style: Roboto12_B_black),
                    const SizedBox(height: 5.0),
                    (dataConnent)
                        ? Text("$myBalance RCT", style: Roboto20_B_black)
                        : const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                    const SizedBox(height: 15.0),

                    //TODO 4: Address wallet
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

                    //TODO 5: Button Refresh
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

              //TODO 6: Transaction Head
              Text("Transaction", style: Roboto18_B_black),
              const Divider(
                height: 10,
                thickness: 1,
                color: Colors.black,
              ),

              //TODO 7: List Transaction
              Expanded(
                child: StreamBuilder(
                  stream: _transaction.asBroadcastStream(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return _build_Notfound();
                    } else {
                      return ListView(
                        children: [
                          //TODO : Fetch data here --------------------------
                          ...snapshot.data!.docs
                              .map((QueryDocumentSnapshot<Object?> data) {
                            //ได้ตัว Data มาละ ----------<<<
                            final String txHash = data.get("TxnHash");
                            final token = data.get("amount");
                            final time = data.get("timestamp");
                            final String order = data.get("order");

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: _build_listTransaction(
                                txHash: txHash,
                                token: token,
                                order: order,
                                time: time,
                              ),
                            );
                          }),
                          // //TODO 8: Load More
                          (isloading == true)
                              ? const SpinKitWave(
                                  color: Colors.black,
                                  size: 30.0,
                                )
                                //กรณีที่ไม่เหลือให้ load more แล้วให้หยุด
                              : (item_limit >= data_length)
                                  ? Container()
                                  : RaisedButton(
                                      child: const Text("MORE"),
                                      onPressed: () async {
                                        print("len: $data_length");
                                        setState(() {
                                          isloading = true;
                                          timeingLoad();
                                        });
                                      }),
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //=================================================================================================================
  //TODO : Not Found Transaction
  _build_Notfound() {
    return Column(
      children: [
        const SizedBox(height: 15.0),
        const Icon(
          Icons.insert_drive_file_outlined,
          size: 80,
          color: Colors.grey,
        ),
        const SizedBox(height: 5.0),
        Text("Not found", style: Roboto20_grey),
      ],
    );
  }

  //TODO : Format Time
  String formattedDate(timeStamp) {
    var dateFromTimeStamp =
        DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
    return DateFormat('dd/MM/yyyy | hh:mm a').format(dateFromTimeStamp);
  }

  //TODO 1: Transaction List
  _build_listTransaction({
    required txHash,
    required token,
    required order,
    required time,
  }) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: txHash)).then((value) {
          Fluttertoast.showToast(
            msg: "Copy to clipboard",
            gravity: ToastGravity.BOTTOM,
          );
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 108.0,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F4F8),
          border: Border.all(
            color: const Color(0xA43C3C3C),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //TODO 1.1: Order Type
              Row(
                children: [
                  Text("Timestamp: ", style: Roboto12_B_black),
                  Text(formattedDate(time), style: Roboto12_black),
                ],
              ),
              //TODO 1.2: Order Type
              Row(
                children: [
                  Text("Order: ", style: Roboto12_B_black),
                  Text(order, style: Roboto12_black),
                ],
              ),
              //TODO 1.3: Amounts token
              Row(
                children: [
                  Text("Amounts: ", style: Roboto12_B_black),
                  Text("$token", style: Roboto12_black),
                ],
              ),

              //TODO 1.4: TxnHash
              Text("TxnHash: ", style: Roboto12_B_black),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 100.0,
                  maxWidth: MediaQuery.of(context).size.width * 0.85,
                ),
                child: Text(txHash, style: Roboto12_black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
