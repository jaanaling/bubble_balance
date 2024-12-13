import 'package:advertising_id/advertising_id.dart';
import 'package:core_logic/core_logic.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:bubblebalance/core/utils/icon_provider.dart';
import 'package:bubblebalance/routes/route_value.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InitializationCubit()..initialize(context),
      child: BlocListener<InitializationCubit, InitializationState>(
        listener: (context, state) {
          if (state is InitializedState) {
            context.go(state.startRoute);
          }
        },
        child: Stack(
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
        ),
      ),
    );
  }
}
