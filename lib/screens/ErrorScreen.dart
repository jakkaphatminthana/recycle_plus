import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:recycle_plus/components/font.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key, required this.err}) : super(key: key);
  final err;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("ERORR 404!!", style: Roboto18_B_black),
          const SizedBox(height: 20.0),
          Text(err, style: Roboto12_black),
        ],
      ),
    );
  }
}
