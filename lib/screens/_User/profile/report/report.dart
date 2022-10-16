import 'package:flutter/material.dart';
import 'package:recycle_plus/screens/_User/tabbar_control.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class Reportform extends StatefulWidget {
  //Location Page
  static String routeName = "/Report";

  @override
  _ReportformState createState() => _ReportformState();
}

class _ReportformState extends State<Reportform> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF107027),
        title: const Text(
          'รายงานข้อผิดพลาด',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Member_TabbarHome(0)),
                );
              },
              icon: const Icon(Icons.home))
        ],
      ),
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl:
            'https://docs.google.com/forms/d/e/1FAIpQLSdoWYyrciNFBBTPAOzDfcGPsmosXjPWbNBapkXMP8ilLejPEg/viewform',
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
    );
  }
}
