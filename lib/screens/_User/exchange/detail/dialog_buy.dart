import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/service/auth.dart';
import 'package:recycle_plus/service/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firebase;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recycle_plus/service/wallet_smartcontract.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:walletconnect_secure_storage/walletconnect_secure_storage.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';


//TODO : Blockchain past
//START ------------------------------------------------------------------------------------------------------------------
final infura = dotenv.env["INFURA_ROPSTEN_ADDRESS"];
final privateK = dotenv.env["METAMASK_PRIVATE_KEY"];
final contractEZ = dotenv.env["CONTRACT_ADDRESS"];

//TODO 1: Get Smartcontract from Remix <----------------------------------------
Future<DeployedContract> loadContract() async {
  String abi = await rootBundle.loadString('assets/abi.json');
  String contractAddress = "$contractEZ";

  final contract = DeployedContract(
    ContractAbi.fromJson(abi, "RecycleToken"), //abi file
    EthereumAddress.fromHex(contractAddress), //contract address
  );

  return contract;
}

//TODO 2: น่าจะดึงสัญญามาเรียกใช้แบบ function <-------------------------------------
Future<List<dynamic>> query(
    Web3Client ethClient, String functionName, List<dynamic> args) async {
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
    Web3Client ethClient, String functionName, List<dynamic> args) async {
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

//END ------------------------------------------------------------------------------------------------------------------

//db = ติดต่อ firebase
//_auth = ติดต่อกับ auth
DatabaseEZ db = DatabaseEZ.instance;
AuthService _auth = AuthService();
User? user = FirebaseAuth.instance.currentUser;
bool isLoading = false;

//===================================================================================================================
showAlertDialog_Buy({
  required BuildContext context,
  required Web3Client ethClient,
  required session,
  required productData,
  required double price,
  required int amounts,
}) {
  //TODO : Cancle Button
  Widget cancelButton(BuildContext context) {
    return FlatButton(
      child: Text("ยกเลิก", style: Roboto16_B_gray),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

//TODO : Continute Button
  Widget continueButton(BuildContext context) {
    return FlatButton(
      child: Text("ยืนยัน", style: Roboto16_B_green),
      onPressed: ConfrimContinue(
        session,
        productData,
        price,
        amounts,
      ),
    );
  }

  //TODO : ShowDialog
  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text("ยืนยันการแลกของรางวัล", style: Roboto18_B_black),
      actions: [continueButton(context), cancelButton(context)],
      //TODO : Cotent Dialog
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("คุณต้องการจะแลกของรางวัลนี้ กับแต้มสะสมของคุณหรือไม่?"),
          Row(
            children: [
              Text("แต้มที่ใช้แลกเปลี่ยน: ", style: Roboto14_B_black),
              const SizedBox(width: 5.0),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text("$price", style: Roboto14_B_red),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

//===================================================================================================================
//TODO : เมือกดปุ่มยืนยัน
GestureTapCallback ConfrimContinue(session, product, price, amount) {
  return () {
    String type = "trading";
    print("sesion: $session");
    print("product: $product");
    print("user: ${user?.uid}");
    print("price: $price");
    print("amount: $amount");
  };
}

Future Order_buy(data_product, user) async {}
