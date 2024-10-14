import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plinko/core/utils/icon_provider.dart';
import 'package:plinko/routes/route_value.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startLoading(context);
  }

  Future<void> startLoading(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 5000));

    context.go(RouteValue.menu.path);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            IconProvider.splash.buildImageUrl(),
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: LinearProgressIndicator(
              minHeight: 10,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFF320072)),
              backgroundColor: Colors.grey[300],
            ),
          ),
        ),
      ],
    );
  }
}
