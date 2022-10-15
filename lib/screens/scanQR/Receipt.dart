import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:recycle_plus/screens/_User/tabbar_control.dart';
import 'package:recycle_plus/screens/scanQR/QRscan.dart';
import 'package:recycle_plus/screens/scanQR/Reward.dart';
import 'package:recycle_plus/service/database.dart';
import 'package:uuid/uuid.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:walletconnect_secure_storage/walletconnect_secure_storage.dart';
import 'package:web3dart/web3dart.dart' as web3;

class Receipt extends StatefulWidget {
  Receipt({
    Key? key,
    required this.amount,
    required this.value_image,
    required this.image_name,
    required this.image_file,
    required this.image_path,
    required this.trash_id,
  }) : super(key: key);
  final int amount;
  final value_image;
  final image_name;
  final image_path;
  final image_file;
  final trash_id;

  @override
  State<Receipt> createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  DatabaseEZ db = DatabaseEZ.instance;
  User? user = FirebaseAuth.instance.currentUser;

  //TODO : Blockchain Part
  //(((((((((((((((((((((((((((((((((((((((((((((((((((((((())))))))))))))))))))))))))))))))))))))))))))))))))))))))
  //Contract nesecsarily
  late Client httpClient;
  late web3.Web3Client ethClient;
  bool dataConnent = false;
  final infura = dotenv.env["INFURA_ADDRESS"];
  final privateK = dotenv.env["METAMASK_PRIVATE_KEY"];
  final contractEZ = dotenv.env["CONTRACT_ADDRESS"];
  final chainID = dotenv.env["CHAIN_ID"];
  int? chainID_int;

  //Wallet Object
  late WalletConnect connector;
  String _account = '';
  bool? statusConnect;

  //ตัวแปรที่ใช้เก็บเฉยๆ ไว้ส่งไปมา
  var _session;
  var _connector;
  var _uri;

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
          name: 'Recycle+',
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

  //TODO 2: Get Smartcontract from Remix <----------------------------------------
  Future<web3.DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString('assets/abi.json');
    String contractAddress = "$contractEZ";

    final contract = web3.DeployedContract(
      web3.ContractAbi.fromJson(abi, "RecycleToken"), //abi file
      web3.EthereumAddress.fromHex(contractAddress), //contract address
    );

    return contract;
  }

//TODO 3: น่าจะดึงสัญญามาเรียกใช้แบบ function <-------------------------------------
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

//TODO 4: ลงชื่ออนุญาติในสัญญาที่เป็นแบบ write <-------------------------------------
  Future<String> submit(String functionName, List<dynamic> args) async {
    //private key ของกระเป๋าเราคือ
    web3.EthPrivateKey credentials = web3.EthPrivateKey.fromHex(privateK!);

    //โหลดตัวสัญญามาใช้ contract
    web3.DeployedContract contract = await loadContract();
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
      //this contract for only chainID  นี้เท่านั้น
      fetchChainIdFromNetworkId: false,
      chainId: chainID_int,
    );
    return result;
  }

  //TODO 4: Function TransferToken
  Future<String> TransferToken(double amount, String to) async {
    web3.EthereumAddress address_to = web3.EthereumAddress.fromHex(to);

    // //แปลงค่าให้มี 0 จำนวน 18 ตัว
    final decimal = pow(10, 18);
    var value = amount * decimal;
    var bigAmount = BigInt.from(value);

    //sign transaction
    var response = await submit("transfer", [address_to, bigAmount]);

    print("to: $to");
    print("amounts: $value");
    return response; //TxHash
  }

  //(((((((((((((((((((((((((((((((((((((((((((((((((((((((()))))))))))))))))))))))))))))))))))))))))))))))))))))))))

  bool delay = false;
  bool loading = false;
  Timer? _timer;
  Timer? _timer2;
  var user_bonus;
  var user_exp;
  var trash_token;
  var trash_exp;

  var reward_bonus_token;
  var reward_total_token;
  var reward_token;
  var reward_exp;

  //TODO : Get User Database
  Future<void> getUserData(Id_user) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Id_user)
        .snapshots()
        .listen((event) {
      setState(() {
        user_bonus = event.get('bonus');
      });
    });
  }

  //TODO : Get Trash Database
  Future<void> getTrashData(Id_trash) async {
    await FirebaseFirestore.instance
        .collection('trash')
        .doc(Id_trash)
        .snapshots()
        .listen((event) {
      setState(() {
        trash_token = event.get('token');
        trash_exp = event.get('exp');
      });
    });
  }

  //TODO : First call whenever run
  @override
  void initState() {
    super.initState();
    getUserData(user!.uid);
    getTrashData(widget.trash_id);

    _timer = Timer(const Duration(milliseconds: 1000), () {
      setState(() {
        delay = true;
        var trash_tokenNum = double.parse(trash_token);
        var trash_expNum = double.parse(trash_exp);

        //1.reward zone
        reward_exp = widget.amount * trash_expNum;
        reward_token = (widget.amount * trash_tokenNum);
        //1.1 token reward + bonus
        var tokenCal = ((widget.amount * trash_tokenNum) * user_bonus);
        var tokenDB = double.parse(tokenCal.toString()).toStringAsFixed(2);
        var tokenResult = double.parse(tokenDB);
        reward_total_token = tokenResult;
        //1.2 token bonus
        var bonusCal = (tokenCal - (widget.amount * trash_tokenNum));
        var bonusDB = double.parse(bonusCal.toString()).toStringAsFixed(2);
        var bonusResult = double.parse(bonusDB);
        reward_bonus_token = bonusResult;

        //Blockchain Part
        initWalletConnect();
        httpClient = Client();
        ethClient = web3.Web3Client("$infura", httpClient);
        chainID_int = int.parse('$chainID');
        print('chain ID: $chainID_int');
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    //================================================================================================================
    return (delay == false)
        ? const Center(child: CircularProgressIndicator(color: Colors.green))
        : Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFF107027),
              automaticallyImplyLeading: false,
              title: const Text(
                'รางวัลที่จะได้รับทั้งหมด',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.home),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Member_TabbarHome(0)),
                    );
                  },
                )
              ],
              centerTitle: true,
              elevation: 2,
            ),
            body: SafeArea(
              child: GestureDetector(
                onTap: (() => FocusScope.of(context).unfocus()),
                child: ListView(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.9,
                      decoration: BoxDecoration(
                        //รูปพื้นหลัง
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: Image.asset(
                            'assets/image/image-from-rawpixel-id-2758016-jpeg.jpg',
                          ).image,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
                            child: Container(
                              width: 300,
                              height: 150,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xE7000000),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    width: 150,
                                    height: 300,
                                    decoration: BoxDecoration(),
                                    child: Image.file(
                                      widget.value_image!, // รูปที่reqมา
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
//---------------------------------------------------------------------------------------------------------
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        15, 0, 0, 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 120,
                                              height: 80,
                                              decoration: BoxDecoration(),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      widget
                                                          .image_name, // ชื่อที่reqมา
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
//---------------------------------------------------------------------------------------------------------
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Container(
                                              width: 60,
                                              height: 35,
                                              decoration: BoxDecoration(),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Text(
                                                    'จำนวน',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: 35,
                                              height: 35,
                                              decoration: BoxDecoration(),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "${widget.amount}", //จำนวนที่reqมา
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 17),
                                                  ),
                                                ],
                                              ),
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
//---------------------------------------------------------------------------------------------------------
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                            child: Container(
                              width: 300,
                              height: 250,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xE7000000),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 15, 0, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(25, 0, 0, 0),
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: Image.asset(
                                                  'assets/image/token.png', //รูปโทเคน
                                                ).image,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  120, 0, 0, 0),
                                          child: Container(
                                            width: 100,
                                            height: 40,
                                            decoration: BoxDecoration(),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '${reward_token}', //จำนวนที่ได้รับ
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
//---------------------------------------------------------------------------------------------------------
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 25, 0, 15),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  25, 0, 0, 0),
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(),
                                            child: Image.asset(
                                              'assets/image/exp2.png', //รูปexp
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
//---------------------------------------------------------------------------------------------------------
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  120, 0, 0, 0),
                                          child: Container(
                                            width: 100,
                                            height: 40,
                                            decoration: BoxDecoration(),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '$reward_exp', // จำนวนexpที่ได้รับ
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
//---------------------------------------------------------------------------------------------------------
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        15, 0, 0, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  5, 0, 0, 0),
                                          child: Container(
                                            width: 80,
                                            height: 40,
                                            decoration: BoxDecoration(),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'โบนัสเหรียญ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  15, 0, 0, 0),
                                          child: Container(
                                            width: 25,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: Image.asset(
                                                  'assets/image/token.png',
                                                ).image,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '$reward_bonus_token', //เหรียญโบนัส
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
//---------------------------------------------------------------------------------------------------------
                                  const Divider(
                                    thickness: 3,
                                    color: Color(0x3B020407),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 10, 0, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  20, 0, 0, 0),
                                          child: Text(
                                            'รวมทั้งหมด',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  5, 0, 0, 0),
                                          child: Container(
                                            width: 35,
                                            height: 35,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: Image.asset(
                                                  'assets/image/token.png',
                                                ).image,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  5, 0, 0, 0),
                                          child: Container(
                                            width: 50,
                                            height: 35,
                                            decoration: BoxDecoration(),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '$reward_total_token',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  15, 0, 0, 0),
                                          child: Container(
                                            width: 35,
                                            height: 35,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: Image.asset(
                                                  'assets/image/exp2.png',
                                                ).image,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 50,
                                          height: 35,
                                          decoration: BoxDecoration(),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '$reward_exp',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 45, 0, 0),
                            child: (loading == true)
                                ? Column(
                                    children: const [
                                      CircularProgressIndicator(
                                        color: Colors.green,
                                      ),
                                      SizedBox(height: 8.0),
                                      Text('โปรดรอสักครู่...')
                                    ],
                                  )
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: const Color(0xFF107027),
                                      fixedSize: const Size(200, 50),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                    ),
                                    child: const Text(
                                      'Continue',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    //TODO : About Database ------------------------------------<<<<<<<<<<<<
                                    onPressed: () async {
                                      var transactionEZ;

                                      setState(() {
                                        loading = true;
                                      });

                                      // print('image value: ${widget.value_image}');
                                      // print('image file: ${widget.image_file}');
                                      // print('image path: ${widget.image_path}');
                                      // print('amount: ${widget.amount}');

                                      // print('user bonus: $user_bonus');
                                      // print('user bonus: $user_bonus');
                                      // print('trash token: $trash_token');
                                      // print('token bonus: $reward_bonus_token');
                                      // print('trash exp: $trash_exp');

                                      // print(
                                      //     'trash reward token: $reward_token');
                                      // print('trash reward exp: $reward_exp');

                                      //generate key id
                                      var uid = Uuid();
                                      final uuid = uid.v1();

                                      //TODO 1: Upload Image to storage ---------------
                                      var imageURL = await uploadImage(
                                        gallery: widget.image_path,
                                        image: widget.image_file,
                                        uid: uuid,
                                      );
                                      //TODO 2: SendTransaction Blockchain ----------------------------<<<<<<<<
                                      var txHash = await TransferToken(
                                              reward_total_token, _account)
                                          .then((value) {
                                        print('transfer success');
                                        setState(() {
                                          transactionEZ = value;
                                        });
                                      }).catchError((err) {
                                        print('transaction error: $err');
                                      });

                                      //TODO 3: Create Transaction on firebase ------------------------<<<<<<<
                                      await db
                                          .createTransaction(
                                        ID_user: user!.uid,
                                        wallet: _account,
                                        txHash: transactionEZ,
                                        token: reward_total_token,
                                        order: "trash",
                                      )
                                          .then(
                                        (value) {
                                          print('transaction firebase');
                                          //TODO 4: UPDATE EXP USER -------------------------------------<<<<<<<<
                                          db
                                              .updateAddExp(
                                            user_ID: user!.uid,
                                            exp: reward_exp,
                                          )
                                              .then((value) {
                                            print('exp success');

                                            //TODO 5: UPDATE Garbage User --------------------------------<<<<<<<
                                            db
                                                .updateAddGarbage(
                                              user_ID: user!.uid,
                                              amounts: widget.amount,
                                            )
                                                .then((value) {
                                              print('garbage success');

                                              //TODO 6: Create Order Trash reward --------------------------<<<<<<<
                                              db
                                                  .createOrder_trashReward(
                                                uid: uuid,
                                                ID_user: user!.uid,
                                                trash_type: widget.trash_id,
                                                imageURL: imageURL,
                                                amount: widget.amount,
                                                token: reward_token,
                                                exp: reward_exp,
                                                wallet: _account,
                                                txHash: transactionEZ,
                                              )
                                                  .then((value) {
                                                print('order success');
                                                setState(() {
                                                  loading = false;
                                                });
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        RewardWidget(
                                                      token: reward_total_token,
                                                      exp: reward_exp,
                                                    ),
                                                  ),
                                                );
                                              }).catchError((err) => print(
                                                      'order error: $err'));
                                            }).catchError((err) => print(
                                                    'garbage error: $err'));
                                          }).catchError((err) =>
                                                  print('expError: $err'));
                                        },
                                      ).catchError((err) =>
                                              print('error tran fire: $err'));
                                    },
                                  ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }

  //===============================================================================================================
  //TODO : อัพโหลด ภาพลงใน Storage ใน firebase
  uploadImage({gallery, image, img_name, uid}) async {
    // กำหนด _storage ให้เก็บ FirebaseStorage (สโตเลท)
    final _storage = FirebaseStorage.instance;
    // เอา path ที่เราเลือกจากเครื่องมาเเปลงเป็น File เพื่อเอาไปอัพโหลดลงใน Storage ใน Firebase
    var file = File(gallery);
    // เช็คว่ามีภาพที่เลือกไหม
    if (image != null) {
      //Upload to Firebase
      var snapshot = await _storage
          .ref()
          .child("images/orders/trash/$uid") //แหล่งเก็บภาพนี้
          .putFile(file);
      //เอาลิ้ง url จากภาพที่เราได้อัปโหลดไป เอาออกมากเก็บไว้ใน downloadUrl
      var downloadURL = await snapshot.ref.getDownloadURL();
      //ส่ง URL ของรูปภาพที่อัพโหลดขึ้น stroge แล้วไปใช้ต่อ
      // print("downloadURL = ${downloadURL}");
      return downloadURL;
    } else {
      return Text("ไม่พบรูปภาพ");
    }
  }
}
