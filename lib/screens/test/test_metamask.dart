import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:recycle_plus/screens/test/test_blockchain.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:web3dart/web3dart.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:walletconnect_secure_storage/walletconnect_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:algorand_dart/algorand_dart.dart';
import 'package:qr_flutter/qr_flutter.dart';
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Test_MetaMask extends StatefulWidget {
  const Test_MetaMask({Key? key}) : super(key: key);
  //Location page
  static String routeName = "/TestMetaMask";

  @override
  State<Test_MetaMask> createState() => _Test_MetaMaskState();
}

class _Test_MetaMaskState extends State<Test_MetaMask> {
  //Wallet Object
  late WalletConnect connector;
  String _account = '';
  bool? statusConnect;

  //ตัวแปรที่ใช้เก็บเฉยๆ ไว้ส่งไปมา
  var _session;
  var _connector;
  var _uri;

  //TODO 1: เชื่อมต่อ Wallet (Create new session)
  createSession(BuildContext context) async {
    //TODO 1.1: กรณีที่ยังไม่เชื่อมต่อ wallet
    if (statusConnect == false) {
      final sessionStorage = WalletConnectSecureStorage();
      final session = await sessionStorage.getSession();

      //Wallet Seesion
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

      //เช็คก่อนว่า connector เชื่อมต่อหรือยังป้องกัน error
      if (!connector.connected) {
        try {
          //Create a new session
          //  * onDisplayUri = bridge: 'https://bridge.walletconnect.org'
          //  * bridge.walletconnect.org = ศูนย์กลางของ wallet มากมายที่สามารถเชื่อมต่อกับ bloackchain ได้
          final session =
              await connector.createSession(onDisplayUri: (uri) async {
            _uri = uri;
            //เรียกเปิด app wallet ที่ต้องการใช้เชื่อม
            await launchUrlString(uri, mode: LaunchMode.externalApplication);
          });
          print("Connect Session: $session");

          //set sessionData, account
          setState(() {
            _account = session.accounts.first;
            _session = session;
            _connector = connector;
            if (_account == '') {
              statusConnect = true;
            }
          });

          //set data เมื่อเชื่อมต่อได้เรียบร้อย
          connector.registerListeners(
            onConnect: (status) {
              setState(() {
                _account = status.accounts[0];
                _session = session;
                _connector = connector;
              });
            },
          );
        } catch (err) {
          print("Connect Error: $err");
        }
      }

      //TODO 1.2: กรณีที่เคยเชื่อมต่อ wallet มาแล้ว
    } else {
      //เช็คก่อนได้เชื่อมต่อ wallet หรือยัง?
      if (!connector.connected) {
        try {
          //Create a new session
          //  * onDisplayUri = bridge: 'https://bridge.walletconnect.org'
          //  * bridge.walletconnect.org = ศูนย์กลางของ wallet มากมายที่สามารถเชื่อมต่อกับ bloackchain ได้
          final session =
              await connector.createSession(onDisplayUri: (uri) async {
            _uri = uri;
            //เรียกเปิด app wallet ที่ต้องการใช้เชื่อม
            await launchUrlString(uri, mode: LaunchMode.externalApplication);
          });
          print("Connect Session: $session");
          //set sessionData
          setState(() {
            _session = session;
            _connector = connector;
          });
        } catch (err) {
          print("Connect Error: $err");
        }
      }
    }
  }

  //TODO 2: User Wallet
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
    print("connector.connected = ${connector.connected}");
    print("statuscheck = $statusConnect");
    //print("connector.accounts = ${connector.session.accounts[0]}");
  }

  //TODO 3: เรียกใช้ครั้งเดียว โดยจะเรียกใช้ทุกครั้งเมื่อมาหน้านี้
  @override
  void initState() {
    super.initState();
    initWalletConnect();
  }

  //-------------------------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    //TODO : Event Subscribe

    // //เชื่อมต่อ (event, callback)
    // connector.on(
    //   'connect',
    //   (session) => print('event conecnt: $session'),
    // );
    // //ปรับเปลี่ยน session (event, callback)
    // connector.on(
    //   'session_update',
    //   (payload) => print('event update: $payload'),
    // );
    // //ตัดการเชื่อต่อ (event, callback)
    // connector.on(
    //   'disconnect',
    //   (payload) => print('event disconnect: $payload'),
    // );
    //==============================================================================================================
    return Scaffold(
      //TODO 4: กรณียังไม่เชื่อมต่อ Wallet
      body: (_account == '')
          ? Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/image/bg_test.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SafeArea(
                    child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Connect to Metamask',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Column(
                              children: <Widget>[
                                const SizedBox(height: 20),
                                const Text(
                                  'MetaMask',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'You can login your metamask wallet or create your wallet from here',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  child: const Text('Connenct Wallet'),
                                  onPressed: () async {
                                    await createSession(context);
                                    print("_uri = $_uri");
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ))
              ],
            )
          : Test_Blockchian(connector: _connector, session: _session),
    );
  }
}
