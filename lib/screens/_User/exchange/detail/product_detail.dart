import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/components/image_full.dart';
import 'package:recycle_plus/screens/_User/exchange/detail/dialog_buy.dart';
import 'package:recycle_plus/screens/_User/exchange/detail/product_detail2.dart';
import 'package:recycle_plus/service/auth.dart';
import 'package:recycle_plus/service/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:walletconnect_secure_storage/walletconnect_secure_storage.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

class Member_ProductDetail extends StatefulWidget {
  const Member_ProductDetail({Key? key, required this.data}) : super(key: key);
  final data;

  @override
  State<Member_ProductDetail> createState() => _Member_ProductDetailState();
}

class _Member_ProductDetailState extends State<Member_ProductDetail> {
  //db = ติดต่อ firebase
  //_auth = ติดต่อกับ auth
  DatabaseEZ db = DatabaseEZ.instance;
  AuthService _auth = AuthService();
  User? user = FirebaseAuth.instance.currentUser;

  int _counter = 1;
  var _price_value = 0.0; //ราคาสินค้า
  var _user_verify; //เงินในกระเป๋า

  //TODO : Blockchain past
  //START -------------------------------------------------------------------------------------------------------------------
  //Contract nesecsarily
  late Client httpClient;
  late Web3Client ethClient;
  bool dataConnent = false;
  final infura = dotenv.env["INFURA_ADDRESS"];
  final contractEZ = dotenv.env["CONTRACT_ADDRESS"];
  final chainID = dotenv.env["CHAIN_ID"];
  int? chainID_int;

  //Wallet Object
  late WalletConnect connector;
  String _account = '';
  String MyAddress = '';
  bool? statusConnect;
  var myBalance = 0.0;

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
      _timer.cancel();
    });
  }

  //END -------------------------------------------------------------------------------------------------------------------

  //TODO : Counter Amount
  void _incrementCounter(token, token_change) {
    setState(() {
      if (_counter <= (widget.data!.get('amount') - 1)) {
        _counter++;
        token_change = token * _counter;
        _price_value = token_change;
        print(token_change);
      }
    });
  }

  void _decrementCounter(token, token_change) {
    setState(() {
      if (_counter > 1) {
        _counter--;
        token_change = (token * (_counter + 1)) - token;
        _price_value = token_change;
      }
    });
  }

  //TODO : Get User
  Future<void> getUserVerify(id) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .snapshots()
        .listen((event) {
      setState(() {
        _user_verify = event.get('verify');
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _price_value = widget.data!.get('token');
    if (user != null) {
      getUserVerify(user?.uid);

      initWalletConnect();

      httpClient = Client();
      ethClient = Web3Client("$infura", httpClient);
      chainID_int = int.parse('$chainID');

      //ป้องกัน error
      _timer = Timer(const Duration(seconds: 2), () {
        (_account != '') ? getBalance(_account) : null;
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final image = widget.data!.get('image');
    final name = widget.data!.get('name');
    final token = widget.data!.get('token');
    final token_change = token;
    final amount = widget.data!.get('amount');
    final description = widget.data!.get('description');
    final pickup = widget.data!.get('pickup');
    final delivery = widget.data!.get('delivery');

    //================================================================================================================
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00883C),
        title: Text("รายละเอียดของรางวัล", style: Roboto16_B_white),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.info_outline,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //TODO 2. Image Product
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageFullScreen(
                            imageNetwork: image,
                          ),
                        ),
                      );
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 240,
                      child: Align(
                        alignment: const AlignmentDirectional(0, 0),
                        child: Image.network(
                          image,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 1,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                    height: 10.0,
                    thickness: 10,
                    color: Color(0xFFC4C4C4),
                  ),

                  //TODO 3. Header Product
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //TODO 3.1: Product Name
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 200.0,
                            maxWidth: MediaQuery.of(context).size.width,
                          ),
                          child: Text(name, style: Roboto18_B_black),
                        ),
                        const SizedBox(height: 10.0),

                        //TODO 3.2: Price and amount
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 10, 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //1.Token
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/image/token.png',
                                    width: 30,
                                    height: 30,
                                  ),
                                  const SizedBox(width: 5.0),
                                  Text(
                                    "$_price_value",
                                    style: Roboto18_B_green,
                                  ),
                                ],
                              ),

                              //2.Counter
                              Row(
                                children: [
                                  Container(
                                    width: 150,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(25),
                                      shape: BoxShape.rectangle,
                                      border: Border.all(
                                        color: const Color(0xFF9E9E9E),
                                      ),
                                    ),
                                    child: build_counter(token, token_change),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  //TODO 4: Amout Product & Status
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8F9DD),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //Amount
                          Row(
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.box,
                                color: Colors.black,
                                size: 20,
                              ),
                              const SizedBox(width: 7.0),
                              Text("$amount ชิ้น", style: Roboto16_B_black),
                            ],
                          ),

                          //Status Product
                          Row(
                            children: [
                              _buildStatusIcon(
                                StatusEZ: pickup,
                                iconEZ: FontAwesomeIcons.store,
                                title: "รับที่ร้าน",
                              ),
                              const SizedBox(width: 5.0),
                              _buildStatusIcon(
                                StatusEZ: delivery,
                                iconEZ: FontAwesomeIcons.truck,
                                title: "ขนส่ง",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    height: 2,
                    thickness: 2,
                    color: Color(0xFFC4C4C4),
                  ),

                  //TODO 5: Description Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Text("รายละเอียดสินค้า", style: Roboto14_B_black),
                  ),

                  //TODO 6: Description Contet
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 200.0,
                            maxWidth: MediaQuery.of(context).size.width,
                          ),
                          child: Text(description, style: Roboto14_black),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  //TODO 7: Button Buy
                  (_user_verify != true || user == null)
                      //7.1 ทำการยืนตัวตนแล้ว
                      ? Center(
                          child: Text(
                            "โปรดยืนยันตัวตนก่อน",
                            style: Roboto16_B_red,
                          ),
                        )
                      //7.2 ยังไม่ได้ยืนยันตัวตน
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("แต้มของฉัน : ", style: Roboto16_B_black),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: (_session != null)
                                  ? (dataConnent)
                                      ? Text(
                                          "$myBalance",
                                          style: (myBalance < _price_value)
                                              ? Roboto16_B_red
                                              : Roboto16_B_green,
                                        )
                                      : Text(
                                          "กำลังโหลด...",
                                          style: Roboto16_B_green,
                                        )
                                  : Text("No connected wallet",
                                      style: Roboto16_B_red),
                            ),
                          ],
                        ),
                  const SizedBox(height: 5.0),

                  //TODO 8: Button Buy
                  Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      height: 50.0,
                      child: Text('ถัดไป', style: Roboto18_B_white),
                      color: Colors.green,
                      elevation: 2.0,
                      disabledColor: Colors.grey,
                      onPressed: (dataConnent != true || _user_verify != true)
                          ? (_price_value > myBalance)
                              ? null
                              : build_buttonBuy()
                          : (_price_value <= myBalance)
                              ? build_buttonBuy()
                              : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //=================================================================================================================
  //TODO : Widget Conuter
  Widget build_counter(token, token_change) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //Button ลบ
        FloatingActionButton(
          heroTag: 'btn1',
          backgroundColor: Colors.transparent,
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightElevation: 0.0,
          hoverElevation: 0.0,
          elevation: 0.0,
          onPressed: () => _decrementCounter(token, token_change),
          child: const Icon(
            Icons.remove,
            size: 30,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 5.0),
        Text("$_counter", style: Roboto14_B_black),
        const SizedBox(width: 5.0),
        //Button บวก
        FloatingActionButton(
          heroTag: 'btn2',
          backgroundColor: Colors.transparent,
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightElevation: 0.0,
          hoverElevation: 0.0,
          elevation: 0.0,
          onPressed: () => _incrementCounter(token, token_change),
          child: const Icon(
            Icons.add,
            size: 30,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  //TODO : Icon Status
  Widget _buildStatusIcon({
    required bool StatusEZ,
    required IconData iconEZ,
    required String title,
  }) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor:
              (StatusEZ == true) ? const Color(0xFF00883C) : Colors.grey,
          radius: 14,
          child: FaIcon(
            iconEZ,
            size: 14,
            color: (StatusEZ == true) ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(width: 5.0),
        Text(title, style: Roboto12_black),
      ],
    );
  }

  //TODO : Button Buy
  GestureTapCallback build_buttonBuy() {
    return () {
      //ไปหน้าโดยที่ ส่งค่าข้อมูลไปด้วย
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Member_ProductDetail2(
            data: widget.data,
            amounts: _counter,
            total: _price_value,
            session: _session,
            ethClient: ethClient,
          ),
        ),
      );
    };
  }
}
