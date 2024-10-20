import 'package:bubblebalance/routes/route_value.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:bubblebalance/feature/test/bloc/test_bloc.dart';
import 'package:bubblebalance/feature/test/models/psychological_test.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TestResultScreen extends StatelessWidget {
  final PsychologicalTest test;
  const TestResultScreen({super.key, required this.test});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 36, bottom: 80),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () {
                context.pop();
              },
              iconSize: 54,
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  const Gap(16),
                  Text(
                    test.result?.outcome ?? 'No outcome available',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      fontFamily: 'Mon',
                    ),
                  ),
                  CupertinoButton(
                    onPressed: () async {
                      if (await canLaunch(test.link)) {
    await launch(test.link);
  }
                     
                    },
                    child: Text(
                      "Link to the Research",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                        color: CupertinoColors.activeBlue,
                        fontFamily: 'Mon',
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: const Color(0xFFEFEFEF),
                      child: Padding(
                        padding: const EdgeInsets.all(28),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Score',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mon',
                              ),
                            ),
                            Text(
                              '${test.result?.totalScore ?? 0}',
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Mon',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Gap(16),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        context
                            .read<TestBloc>()
                            .add(ResetTestEvent(test: test, context: context));
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFF59E60),
                              Color(0xFFF264CE),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 18),
                            child: Text(
                              'RESTART',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontFamily: 'Mon',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ResearchScreen extends StatefulWidget {
  final String url;
  const ResearchScreen({super.key, required this.url});

  @override
  State<ResearchScreen> createState() => _ResearchScreenState();
}

class _ResearchScreenState extends State<ResearchScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

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
                  ..loadRequest(Uri.parse(widget.url))
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
