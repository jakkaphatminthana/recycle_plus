import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_User/exchange/detail/dialog_buy.dart';
import 'package:recycle_plus/screens/_User/tabbar_control.dart';
import 'package:web3dart/web3dart.dart' as web3;

//TODO : Blockchain Part
//(((((((((((((((((((((((((((((((((((((((((((((((((((((((())))))))))))))))))))))))))))))))))))))))))))))))))))))))
final infura = dotenv.env["INFURA_ADDRESS"];
final privateK = dotenv.env["METAMASK_PRIVATE_KEY"];
final contractEZ = dotenv.env["CONTRACT_ADDRESS"];
final CenterWallet = dotenv.env["METAMASK_WALLET_ADDRESS"];
final chainID = dotenv.env["CHAIN_ID"];
int? chainID_int = 5;

//TODO 1: Get Smartcontract from Remix <----------------------------------------
Future<web3.DeployedContract> loadContract() async {
  String abi = await rootBundle.loadString('assets/abi.json');
  String contractAddress = "$contractEZ";

  final contract = web3.DeployedContract(
    web3.ContractAbi.fromJson(abi, "RecycleToken"), //abi file
    web3.EthereumAddress.fromHex(contractAddress), //contract address
  );

  return contract;
}

//TODO 2: น่าจะดึงสัญญามาเรียกใช้แบบ function <-------------------------------------
Future<List<dynamic>> query(
    web3.Web3Client ethClient, String functionName, List<dynamic> args) async {
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

//TODO 3: ลงชื่ออนุญาติในสัญญาที่เป็นแบบ write <-------------------------------------
Future<String> submit(
    web3.Web3Client ethClient, String functionName, List<dynamic> args) async {
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
    chainId: chainID_int,
  );
  return result;
}

//TODO 4: Function TransferToken
Future<String> TransferToken(
    web3.Web3Client ethClient, double amount, String to) async {
  web3.EthereumAddress address_to = web3.EthereumAddress.fromHex(to);

  // //แปลงค่าให้มี 0 จำนวน 18 ตัว
  final decimal = pow(10, 18);
  var value = amount * decimal;
  var bigAmount = BigInt.from(value);

  //sign transaction
  var response = await submit(ethClient, "transfer", [address_to, bigAmount]);

  print("to: $to");
  print("amounts: $value");
  return response; //TxHash
}
//(((((((((((((((((((((((((((((((((((((((((((((((((((((((())))))))))))))))))))))))))))))))))))))))))))))))))))))))

showDialogMissionSuccess({
  required BuildContext context,
  required user_ID,
  required mission_ID,
  required mission_type,
  required user_loginDaily,
  required reward_type,
  required double reward_num,
  required session,
  required web3.Web3Client ethClient,
}) async {
  bool onCLick = false;

  //TODO : important for login everyday
  String mission_login = 'bAlVt6qw8b52VuQonLTM';

  //TimeZone
  DateTime now = DateTime.now();
  String dateNow = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String timeScale =
      "${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)))},${DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: DateTime.daysPerWeek - DateTime.now().weekday)))}";

  //============================================================================================================
  return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Container(
              height: 320,
              width: MediaQuery.of(context).size.width * 0.85,
              decoration: BoxDecoration(
                color: const Color(0xFFfcfefc),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/image/timeing2.gif",
                      width: 150,
                      height: 150,
                    ),
                    Text("Success!", style: Roboto20_B_black),
                    const SizedBox(height: 8.0),
                    const Text("กำลังทำรายการอาจใช้เวลา 1 นาที"),
                    const Text("ระหว่างนี้ท่านสามารถออกไปทำอย่างอื่นได้เลย"),
                    const SizedBox(height: 8.0),
                    TextButton(
                      child: const Text("ตกลง"),
                      onPressed: onCLick
                          ? null
                          : () {
                              var walletAddress = session.accounts[0];
                              var MainAddress = "$CenterWallet";
                              var transactionEZ;
                              onCLick = true;

                              // print("wallet: $walletAddress");
                              // print("wallet center: $MainAddress");

                              //TODO 1: Status Claim Mission to Firebase ---------------------------<<<<
                              db
                                  .createMissionOrder(
                                typeMission: mission_type,
                                mission_ID: mission_ID,
                                user_ID: user_ID,
                                timescale: (mission_type == 'day')
                                    ? dateNow
                                    : timeScale,
                              )
                                  .then((value) async {
                                print('add success');

                                //TODO 2: IF | Mission Login to Firebsae ----------------------------<<<<
                                (mission_ID == mission_login)
                                    ? await db
                                        .updateLoginUser(
                                          user_ID: user_ID,
                                          CurLogin: user_loginDaily,
                                        )
                                        .then((value) =>
                                            print('add login success'))
                                    : null;

                                //TODO 3.1: IF | Reward EXP = add EXP on Firebase ---------------------<<<<
                                if (reward_type == "Exp") {
                                  await db
                                      .updateAddExp(
                                          user_ID: user_ID, exp: reward_num)
                                      .then((value) async {
                                    print('Earn EXP success');
                                    //TODO 3.2: Create Order Misison on Firebase ---------------------<<<<
                                    await db
                                        .createOrder_Mission(
                                      ID_user: user_ID,
                                      ID_mission: mission_ID,
                                      mission_type: mission_type,
                                      reward_type: reward_type,
                                      reward_num: reward_num,
                                      wallet: walletAddress,
                                      txHash: transactionEZ,
                                    )
                                        .then((value) {
                                      print('order mission success');
                                      //รีเฟรชหน้านี้
                                      Navigator.of(context).pop();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Member_TabbarHome(1)),
                                      );
                                    }).catchError((err) =>
                                            print('order mission error'));
                                  }).catchError((err) =>
                                          print('Earn EXP error: $err'));

                                  //TODO 4.1: IF | Reward Token = Send Transaction Blockchain --------<<<<
                                } else if (reward_type == "Token") {
                                  var txHash = await TransferToken(
                                    ethClient,
                                    reward_num,
                                    walletAddress,
                                  ).then((value) async {
                                    transactionEZ = "$value";
                                    print('transaction success');

                                    //TODO 4.2: Create Trasaction on Firebase --------------------------<<<<
                                    await db
                                        .createTransaction(
                                      ID_user: user!.uid,
                                      wallet: walletAddress,
                                      txHash: transactionEZ,
                                      token: reward_num,
                                      order: "mission",
                                    )
                                        .then((value) async {
                                      print('tran firebase');

                                      //TODO 4.3: Create Order Misison on Firebase ---------------------<<<<
                                      await db
                                          .createOrder_Mission(
                                        ID_user: user_ID,
                                        ID_mission: mission_ID,
                                        mission_type: mission_type,
                                        reward_type: reward_type,
                                        reward_num: reward_num,
                                        wallet: walletAddress,
                                        txHash: transactionEZ,
                                      )
                                          .then((value) {
                                        print('order mission success');
                                        //รีเฟรชหน้านี้
                                        Navigator.of(context).pop();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Member_TabbarHome(1)),
                                        );
                                      }).catchError((err) =>
                                              print('order mission error'));
                                    }).catchError((err) =>
                                            print('tran firebase error'));
                                  }).catchError(
                                      (err) => print('transaction error'));
                                }
                              }).catchError(
                                      (err) => print('misison error: $err'));
                            },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      });
}
//========================================================================================

//TODO : Dialog
