import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivicyScreen extends StatefulWidget {
  const PrivicyScreen({super.key});

  @override
  State<PrivicyScreen> createState() => _PrivicyScreenState();
}

class _PrivicyScreenState extends State<PrivicyScreen> {
  late final WebViewController _controller;
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: CupertinoColors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: WebViewWidget(
                controller: _controller
                  ..loadRequest(
                     Uri.parse("https://bubblebalancea.com/privacy.html"))
                  ..setBackgroundColor(
                    Colors.white,
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
