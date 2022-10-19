import 'package:flutter/material.dart';
import 'package:recycle_plus/screens/_Sponsor/home/sponsor_home.dart';
import 'package:recycle_plus/screens/_User/tabbar_control.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class MoreSupportform extends StatefulWidget {
  //Location Page
  static String routeName = "/Report";

  @override
  _MoreSupportformState createState() => _MoreSupportformState();
}

class _MoreSupportformState extends State<MoreSupportform> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF107027),
        title: const Text(
          'สนับสนุนเพิ่มเติม',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Sponsor_HomeScreen()),
                );
              },
              icon: const Icon(Icons.home))
        ],
      ),
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl:
            'https://docs.google.com/forms/d/e/1FAIpQLSd9mhUJnmGgsnDd_0wXEelnyl5nVhVu58dIrscXVldcxXfi1A/viewform',
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
    );
  }
}
