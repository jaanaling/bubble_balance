import 'package:advertising_id/advertising_id.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bubblebalance/core/utils/icon_provider.dart';
import 'package:bubblebalance/routes/route_value.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    await Future.delayed(const Duration(milliseconds: 1000));

    final adId = await AdvertisingId.id(true);
   FirebaseMessaging instance = FirebaseMessaging.instance;
   final settings =
       await instance.requestPermission(alert: true, badge: true, sound: true);
   if (settings.authorizationStatus != AuthorizationStatus.authorized) {
     SharedPreferences.getInstance()
         .then((prefs) => prefs.setBool('notificationsEnabled', false));

      
   }
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
            child: const CupertinoActivityIndicator(
              color: Colors.black12,
              radius: 44,
            ),
          ),
        ),
      ],
    );
  }
}
