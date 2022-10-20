import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_User/achievement/dialog_claim.dart';
import 'package:recycle_plus/screens/wallet/wallet_connecting.dart';
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

import 'dialog_wrong.dart';

class WalletScreen extends StatefulWidget {
  WalletScreen({
    Key? key,
    required this.connector,
    required this.session,
    required this.user_walletFB,
  }) : super(key: key);

  //TODO : Wallet Data
  WalletConnect connector;
  final session;
  final user_walletFB;

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  String? checkWallet;

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
  final infura = dotenv.env["INFURA_ADDRESS"];
  final contractEZ = dotenv.env["CONTRACT_ADDRESS"];
  final chainID = dotenv.env["CHAIN_ID"];
  int? chainID_int;

  User? user = FirebaseAuth.instance.currentUser;
  var data_length;
  var wallet_lenght;

  Timer? _timer_daley;
  bool daley = false;

  //TODO 0: Always call first run
  @override
  void initState() {
    super.initState();
    print('start| user_walletFB = ${widget.user_walletFB}');

    //TODO : 1.Check wallet wrong
    if (widget.user_walletFB == 'doubly') {
      print('Final| wallet already');
      checkWallet = 'doubly';
    } else if (widget.user_walletFB == widget.connector.session.accounts[0]) {
      print('Final| wallet ok');
      checkWallet = 'match';
    } else {
      print('Final| wallet wrong');
      checkWallet = 'wrong';
    }

    MyAddress = widget.connector.session.accounts[0];
    print("MyAddress: $MyAddress");

    //Infura Node
    httpClient = Client();
    ethClient = web3.Web3Client("$infura", httpClient);
    chainID_int = int.parse('$chainID');

    getBalance(MyAddress);
    getLengthData(user?.uid);

    //TODO 2.Check wallet wrong
    _timer_daley = Timer(const Duration(milliseconds: 1000), () {
      //2.1 กรณีที่ กระเป่าไม่ตรงอันเก่า
      if (checkWallet == "wrong") {
        widget.connector.killSession();
        widget.connector.sessionStorage?.removeSession();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Wallet_Connecting(
              wrong: 'not yours',
            ),
          ),
        );
      } else if (checkWallet == "doubly") {
        widget.connector.killSession();
        widget.connector.sessionStorage?.removeSession();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Wallet_Connecting(
              wrong: 'already',
            ),
          ),
        );
      } else {
        daley = true;
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer_daley?.cancel();
    super.dispose();
  }

  // //TODO : get length wallet
  // Future<void> CheckWallet_SameLike(wallet_address) async {
  //   final _collection = FirebaseFirestore.instance
  //       .collection('users')
  //       .where('wallet', isEqualTo: wallet_address)
  //       .get();

  //   var result = await _collection.then((value) {
  //     print('len same = ${value.size}');
  //     setState(() {
  //       wallet_lenght = value.size;
  //     });
  //   });
  // }

  //TODO : Blockchain Past
  //START ------------------------------------------------------------------------------------------------------------
  //TODO 2: Get Smartcontract from Remix <--------------------------------------
  Future<DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString('assets/abi.json');
    String contractAddress = "$contractEZ";

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
      chainId: chainID_int,
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

  //TODO : get length data
  Future<void> getLengthData(user) async {
    final _collection = FirebaseFirestore.instance
        .collection('users')
        .doc(user)
        .collection('wallet')
        .doc(MyAddress)
        .collection("transaction")
        .get();
    var result = await _collection.then((value) {
      print('len = ${value.size}');
      setState(() {
        data_length = value.size;
      });
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
        body: (daley == false)
            ? const Center(
                child: SpinKitCircle(
                  color: Colors.green,
                  size: 70.0,
                ),
              )
            : Padding(
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
                    //     print('Kill Success');
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
                      child: (data_length == 0)
                          ? _build_Notfound()
                          : StreamBuilder(
                              stream: _transaction,
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (!snapshot.hasData) {
                                  return _build_Notfound();
                                } else if (snapshot.hasError) {
                                  return Column(
                                    children: [
                                      _build_Notfound(),
                                      const Text('Something is wrong'),
                                    ],
                                  );
                                } else {
                                  return (daley == false)
                                      ? const SpinKitRing(
                                          color: Colors.green,
                                          size: 60.0,
                                        )
                                      : ListView(
                                          children: [
                                            //TODO : Fetch data here --------------------------
                                            ...snapshot.data!.docs.map(
                                                (QueryDocumentSnapshot<Object?>
                                                    data) {
                                              //ได้ตัว Data มาละ ----------<<<
                                              final String txHash =
                                                  data.get("TxnHash");
                                              final token = data.get("amount");
                                              final time =
                                                  data.get("timestamp");
                                              final String order =
                                                  data.get("order");

                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 5.0),
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
                                                        child:
                                                            const Text("MORE"),
                                                        onPressed: () async {
                                                          print(
                                                              "len: $data_length");
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
