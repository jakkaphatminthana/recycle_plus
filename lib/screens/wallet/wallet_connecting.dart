import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/wallet/wallet_screen.dart';
import 'package:recycle_plus/service/wallet_smartcontract.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:walletconnect_secure_storage/walletconnect_secure_storage.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:web3dart/web3dart.dart';

class Wallet_Connecting extends StatefulWidget {
  const Wallet_Connecting({Key? key}) : super(key: key);
  //Location page
  static String routeName = "/Conenct Wallet";

  @override
  State<Wallet_Connecting> createState() => _Wallet_ConnectingState();
}

class _Wallet_ConnectingState extends State<Wallet_Connecting> {
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
            name: 'TestMode',
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
          print("_uri: $_uri");
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

  @override
  Widget build(BuildContext context) {
    //===============================================================================================================
    return (_account == '')
        ? GestureDetector(
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
                    //TODO 1: Contaner Header
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 180,
                      decoration: BoxDecoration(
                        color: const Color(0xFF30AE68),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          //TODO 2: Balance
                          const SizedBox(height: 30.0),
                          Text("Balance", style: Roboto12_B_black),
                          Text("- - - -", style: Roboto22_R_black),
                          const SizedBox(height: 5.0),

                          //TODO 3: Address wallet
                          Text(
                            "You haven't connected wallet yet.",
                            style: Roboto18_B_black,
                          ),
                          const SizedBox(height: 8.0),

                          //TODO 4: Button
                          ElevatedButton(
                            child:
                                Text("Connect wallet", style: Roboto14_B_white),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.black,
                            ),
                            onPressed: () async {
                              await createSession(context);
                            },
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 30.0),

                    //TODO 5: Transaction
                    Text("Transaction", style: Roboto18_B_black),
                    const Divider(
                      height: 10,
                      thickness: 1,
                      color: Colors.black,
                    ),
                    const SizedBox(height: 15.0),

                    //TODO 6: List Transaction
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
          )
        : WalletScreen(connector: _connector, session: _session);
  }
}
