import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:web3dart/web3dart.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:walletconnect_secure_storage/walletconnect_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'dart:math';

class Wallet_Connect {
  static Wallet_Connect instance = Wallet_Connect._();
  Wallet_Connect._();

  //Contract nesecsarily
  var myBalance;
  String? txHash;

  //ไว้ป้อนและเก็บค่าเพื่อใช้ต่อ
  var MyAddress = '';
  final privateK = dotenv.env["METAMASK_PRIVATE_KEY"];
  final infura = "https://ropsten.infura.io/v3/83b4a7881ea84cdfbf19a9de732dc800";

  Future<void> getPrint(http, ethC) async {
    print("httpClient = $http");
    print("ethClient = $ethC");
  }

  //TODO 1: Get Smartcontract from Remix <--------------------------------------
  Future<DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString('assets/abi.json');
    String contractAddress = "0x7B439D82F076e88AbC196B8D7861296EE413C47E";

    final contract = DeployedContract(
      ContractAbi.fromJson(abi, "RecycleToken"), //abi file
      EthereumAddress.fromHex(contractAddress), //contract address
    );

    return contract;
  }

  //TODO 2: น่าจะดึงสัญญามาเรียกใช้แบบ function <-----------------------------------
  Future<List<dynamic>> query(
      ethClient, String functionName, List<dynamic> args) async {
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

  //TODO 3: ลงชื่ออนุญาติในสัญญาที่เป็นแบบ write <------------------------------------
  Future<String> submit(
      ethClient, String functionName, List<dynamic> args) async {
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

  //TODO 5: Funtion GetBalance
  Future<double> getBalance(ethClient, String targetAddress) async {
    EthereumAddress address = EthereumAddress.fromHex(targetAddress);
    //ดึงตัว Function getBalance() ที่อยู่ใน Remix มาใช้
    //ปล. [] คือค่าว่าง
    List<dynamic> result = await query(ethClient, "balanceOf", [address]);
    //setting decimal to int
    final numpow = BigInt.from(pow(10, 18));
    final pro = (result[0] / numpow).toString();
    final proDouble = double.parse(pro);
    final setDecimal = proDouble.toStringAsExponential(5);
    final valueDouble = double.parse(setDecimal);

    return valueDouble;
  }
}
