import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TipsScreen extends StatefulWidget {
  const TipsScreen({super.key});

  @override
  State<TipsScreen> createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> {
  List<dynamic> tips = [];

  @override
  void initState() {
    super.initState();
    loadTips();
  }

  Future<void> loadTips() async {
    final String response =
        await rootBundle.loadString('assets/json/tips.json');
    final List<dynamic> data = jsonDecode(response) as List<dynamic>;
    setState(() {
      tips = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return tips.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : PageView.builder(
            itemCount: tips.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(25, 76, 25, 163),
                child: Card(
                  color: const Color(0xFFD69AEE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(27),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          tips[index]['title'] as String,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          tips[index]['description'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }
}
