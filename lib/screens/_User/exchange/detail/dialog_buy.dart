import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:recycle_plus/components/dialog.dart';
import 'package:recycle_plus/components/font.dart';
import 'package:recycle_plus/screens/_User/exchange/detail/dialog_success.dart';
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
final CenterWallet = dotenv.env["METAMASK_WALLET_ADDRESS"];

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

//TODO 4: Function SendToken
Future<String> SendToken(
    Web3Client ethClient, double amount, String from, String to) async {
  EthereumAddress address_from = EthereumAddress.fromHex(from);
  EthereumAddress address_to = EthereumAddress.fromHex(to);

  // //แปลงค่าให้มี 0 จำนวน 18 ตัว
    final decimal = pow(10, 18);
    var value = amount * decimal;
    var bigAmount = BigInt.from(value);

  //sign transaction
  var response = await submit(
    ethClient,
    "sendToken",
    [address_from, address_to, bigAmount],
  );

  print("from: $from");
  print("to: $to");
  print("amounts: $value");
  return response; //TxHash
}

//END ------------------------------------------------------------------------------------------------------------------

//db = ติดต่อ firebase
//_auth = ติดต่อกับ auth
DatabaseEZ db = DatabaseEZ.instance;
AuthService _auth = AuthService();
User? user = FirebaseAuth.instance.currentUser;
bool isLoading = false;
bool isSuccess = false;

//===================================================================================================================
showAlertDialog_Buy({
  required BuildContext context,
  required Web3Client ethClient,
  required session,
  required productData,
  required double price,
  required int amounts,
  required int product_amount,
  required type_pickup,
  required address,
}) {
  //TODO 1: Cancle Button
  Widget cancelButton(BuildContext context) {
    return FlatButton(
      child: Text("ยกเลิก", style: Roboto16_B_gray),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

//TODO 2: Continute Button
  Widget continueButton(BuildContext context) {
    return FlatButton(
      child: (isLoading == true)
          ? const CircularProgressIndicator(color: Colors.green)
          : Text("ยืนยัน", style: Roboto16_B_green),
      onPressed: ConfrimContinue(
        context,
        session,
        ethClient,
        productData,
        price,
        amounts,
        product_amount,
        type_pickup,
        address,
      ),
    );
  }

  //TODO 3.1: Dialog BeforeConfrim
  AlertDialog BeforeConfrim = AlertDialog(
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
  );

  //TODO 4: ShowDialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) => BeforeConfrim,
  );
}

//===================================================================================================================
//TODO : เมือกดปุ่มยืนยันการซื้อ
GestureTapCallback ConfrimContinue(
  BuildContext context,
  session,
  Web3Client ethClient,
  product,
  price,
  amount,
  product_amount,
  typePickup,
  address,
) {
  return () async {
    String type = "trading";
    var id_user = user?.uid;
    var id_product = product!.get("id");
    var category = product!.get("category");
    var walletAddress = session.accounts[0];
    var MainAddress = "$CenterWallet";
    var transactionEZ;

    // print("wallet: $walletAddress");
    // print("id product: $id_product");
    // print("id user: ${id_user}");
    // print("price: $price");
    // print("amount: $amount");
    // print("address: $address");
    // isLoading = true;

    //TODO 1: Send Transaction
    var txHash =
        await SendToken(ethClient, price, walletAddress, MainAddress).then((value) {
      transactionEZ = "$value";
      print("Success TXH: $value");
    }).catchError((err) => print("Error smartcontract: $err"));

    //TODO 2: Create Transaction on Firebase <----------------------------------
    await db
        .createTransaction(
      ID_user: id_user,
      wallet: walletAddress,
      txHash: transactionEZ,
      token: price,
      order: type,
    )
        .then((value) {
      print("Save Transaction success");
      //TODO 3: Create Orders on Firebase <-------------------------------------
      db
          .createOrder_trading(
        ID_user: id_user,
        ID_product: id_product,
        category: category,
        pickup: typePickup,
        address: address,
        amount: amount,
        price: price,
        wallet: walletAddress,
        txHash: transactionEZ,
      )
          .then((value) {
        print("order success");
        //TODO 4: Reduce Amount Product <---------------------------------------
        db
            .updateProduct_reduceAmount(
              ID_product: id_product,
              amount: amount,
              product_amount: product_amount,
            )
            .then((value) => print("Reduce product success"))
            .catchError((err) => print("Error reduce product: $err"));
      }).catchError((err) => print("Error transaction: $err"));
    }).catchError((err) => print("Error save transaction: $err"));

    //TODO 5: Dialog Success
    isLoading = false;
    Navigator.pop(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => Dialog_SucessBuy(),
    );
  };
}
