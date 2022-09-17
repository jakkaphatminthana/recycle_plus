import 'dart:async';
import 'dart:math';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/service/database.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:walletconnect_secure_storage/walletconnect_secure_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:web3dart/web3dart.dart' as web3;

class RewardWidget extends StatefulWidget {
  const RewardWidget({
    Key? key,
    required this.trash_id,
    required this.trash_image,
    required this.trash_image_path,
    required this.trash_image_file,
    required this.image_uid,
    required this.trash_amount,
  }) : super(key: key);
  final trash_id;
  final trash_image;
  final trash_image_path;
  final trash_image_file;
  final image_uid;
  final trash_amount;

  @override
  _RewardWidgetState createState() => _RewardWidgetState();
}

class _RewardWidgetState extends State<RewardWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  DatabaseEZ db = DatabaseEZ.instance;
  User? user = FirebaseAuth.instance.currentUser;

  //TODO : Blockchain Part
  //(((((((((((((((((((((((((((((((((((((((((((((((((((((((())))))))))))))))))))))))))))))))))))))))))))))))))))))))
  //Contract nesecsarily
  late Client httpClient;
  late web3.Web3Client ethClient;
  bool dataConnent = false;
  final infura = dotenv.env["INFURA_ROPSTEN_ADDRESS"];
  final privateK = dotenv.env["METAMASK_PRIVATE_KEY"];
  final contractEZ = dotenv.env["CONTRACT_ADDRESS"];

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
      //this contract for only chainID 3 เท่านั้น
      fetchChainIdFromNetworkId: false,
      chainId: 3,
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
  Timer? _timer;
  Timer? _timer2;
  var user_bonus;
  var user_exp;
  var trash_token;
  var trash_exp;

  var trash_tokenNum;
  var trash_expNum;
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
        trash_tokenNum = double.parse(trash_token);
        trash_expNum = double.parse(trash_exp);

        //reward zone
        reward_exp = widget.trash_amount * trash_expNum;
        var tokenCal =
            ((widget.trash_amount * trash_tokenNum) * user_bonus).toString();
        var tokenDB = double.parse(tokenCal).toStringAsFixed(2);
        var tokenResult = double.parse(tokenDB);
        reward_token = tokenResult;

        //Blockchain Part
        initWalletConnect();
        httpClient = Client();
        ethClient = web3.Web3Client("$infura", httpClient);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer!.cancel();
    _timer2!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    //==============================================================================================================
    return Scaffold(
      key: scaffoldKey,
      body: (delay == false)
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: ListView(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.95,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: Image.asset(
                          'assets/image/bg-green2.jpg',
                        ).image,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(0, 0),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 60, 0, 0),
                            child: Image.asset(
                              'assets/image/success.png',
                              width: 300,
                              height: 300,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                          child: Text('ทำรายการสำเร็จ',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w400)),
                        ),
                        const Divider(
                          height: 15,
                          thickness: 3,
                          indent: 100,
                          endIndent: 100,
                          color: Color(0x3B6E6E6F),
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.access_time,
                                color: Color(0xE7FF0000),
                                size: 24,
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                                child:
                                    Text('ระบบจะทำการตรวจสอบและส่งรางวัลไปให้ ',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          color: Color(0xE7FF0000),
                                        )),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                          child: Text(
                            'รางวัลที่จะได้รับ',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: const Color.fromARGB(231, 0, 0, 0),
                              ),
                            ),
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        'assets/image/token.png',
                                        width: 35,
                                        height: 35,
                                        fit: BoxFit.cover,
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(5, 0, 0, 0),
                                        child: Text(
                                          '$reward_token',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      15, 0, 0, 0),
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Image.asset(
                                          'assets/image/exp2.png',
                                          width: 35,
                                          height: 35,
                                          fit: BoxFit.cover,
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(5, 0, 0, 0),
                                          child: Text(
                                            '$reward_exp',
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.black,
                              fixedSize: const Size(200, 50),
                              side: const BorderSide(
                                  width: 2.0, color: Colors.white), //ขอบ
                              elevation: 2.0, //เงา
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            child: Text(
                              'Back to Home',
                              style: Roboto16_B_white,
                            ),
                            onPressed: () async {
                              var transactionEZ;

                              print('user bonus: $user_bonus');
                              print('user bonus: $user_bonus');
                              print('trash token: $trash_token');
                              print('trash exp: $trash_exp');

                              print('trash reward token: $reward_token');
                              print('trash reward exp: $reward_exp');

                              print('wallet conect: $statusConnect');
                              print('wallet addrss: $_account');

                              print('uid: ${widget.image_uid}');
                              print('ID_user: ${user!.uid}');
                              print('trash_type: ${widget.trash_id}');
                              print('value_image: ${widget.trash_image}');

                              //TODO : Upload Image to storage
                              var imageURL = await uploadImage(
                                gallery: widget.trash_image_path,
                                image: widget.trash_image_file,
                                uid: widget.image_uid,
                              );

                              //TODO : SendTransaction Blockchain ----------------------------<<<<<<<<
                              var txHash =
                                  await TransferToken(reward_token, _account)
                                      .then((value) {
                                print('transfer success');
                                setState(() {
                                  transactionEZ = value;
                                });
                              }).catchError((err) {
                                print('transaction error: $err');
                              });

                              //TODO : Create Transaction on firebase ------------------------<<<<<<<
                              await db
                                  .createTransaction(
                                ID_user: user!.uid,
                                wallet: _account,
                                txHash: txHash,
                                token: reward_token,
                                order: "trash",
                              )
                                  .then(
                                (value) {
                                  print('transaction firebase');
                                  //TODO : UPDATE EXP USER -------------------------------------<<<<<<<<
                                  db
                                      .updateAddExp(
                                    user_ID: user!.uid,
                                    exp: reward_exp,
                                  )
                                      .then((value) {
                                    print('exp success');
                                    //TODO : Create Order Trash reward --------------------------<<<<<<<
                                    db
                                        .createOrder_trashReward(
                                          uid: widget.image_uid,
                                          ID_user: user!.uid,
                                          trash_type: widget.trash_id,
                                          imageURL: imageURL,
                                          amount: widget.trash_amount,
                                          token: reward_token,
                                          exp: reward_exp,
                                          wallet: _account,
                                          txHash: transactionEZ,
                                        )
                                        .then((value) => print('order success'))
                                        .catchError((err) =>
                                            print('order error: $err'));
                                  }).catchError(
                                          (err) => print('expError: $err'));
                                },
                              ).catchError(
                                      (err) => print('error tran fire: $err'));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
