import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_User/mission/mission_day.dart';
import 'package:recycle_plus/screens/_User/mission/mission_week.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:walletconnect_secure_storage/walletconnect_secure_storage.dart';
import 'package:web3dart/web3dart.dart';

class Member_MissionScreen extends StatefulWidget {
  const Member_MissionScreen({Key? key}) : super(key: key);
  //Location page
  static String routeName = "/Mission";

  @override
  State<Member_MissionScreen> createState() => _Member_MissionScreenState();
}

class _Member_MissionScreenState extends State<Member_MissionScreen> {
  //TODO 1. Set Tabbar list here
  TabBar get _tabbar {
    return TabBar(
      indicatorWeight: 2,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.black,
      indicatorSize: TabBarIndicatorSize.label,
      indicator: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        color: Color(0xFF1CCC6A),
      ),
      tabs: [
        Tab(
          child: Align(
            alignment: Alignment.center,
            child: Text("DAILY", style: Roboto18_B),
          ),
        ),
        Tab(
          child: Align(
            alignment: Alignment.center,
            child: Text("WEEKLY", style: Roboto18_B),
          ),
        ),
      ],
    );
  }

//TODO : Blockchain Part
//(((((((((((((((((((((((((((((((((((((((((((((((((((((((())))))))))))))))))))))))))))))))))))))))))))))))))))))))
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

//(((((((((((((((((((((((((((((((((((((((((((((((((((((((())))))))))))))))))))))))))))))))))))))))))))))))))))))))
  //TODO 0: Start First run
  @override
  void initState() {
    super.initState();
    initWalletConnect();
    httpClient = Client();
    ethClient = Web3Client("$infura", httpClient);
    chainID_int = int.parse('$chainID');
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //=================================================================================================================
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  initialIndex: 0,
                  child: Column(
                    children: [
                      const SizedBox(height: 10.0),
                      Text('MISSION', style: Roboto20_B_black),
                      const SizedBox(height: 30.0),

                      //TODO 1: Tabbar
                      PreferredSize(
                        preferredSize: _tabbar.preferredSize,
                        child: ColoredBox(
                          color: Colors.transparent,
                          child: Container(
                            height: 40,
                            child: _tabbar,
                          ),
                        ),
                      ),

                      //TODO 2: TabView
                      Expanded(
                        child: TabBarView(
                          children: [
                            Member_MissionDay(
                              session: _session,
                              ethClient: ethClient,
                            ),
                            Member_MissionWeek(
                              session: _session,
                              ethClient: ethClient,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
