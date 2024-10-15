import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:bubblebalance/feature/analytics/models/user_analytics.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bubblebalance/core/utils/init_data.dart';
import 'package:bubblebalance/feature/aspects/models/user.dart';
import 'package:bubblebalance/feature/aspects/repository/user_data_repository.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'core/dependency_injection.dart';
import 'feature/app/presentation/app_root.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencyInjection();
  tz.initializeTimeZones();
  await requestIOSPermissions();
  await loadInitialData();

  await locator<UserDataRepository>().checkAndAddOverdueTasks(
    (await locator<UserDataRepository>().getUser())?.plannedTasksForWeek ?? {},
  );

  await resetDailyScores();

  await Firebase.initializeApp();

  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);



  runApp(
    const AppRoot(),
  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final prefs = await SharedPreferences.getInstance();
  final notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
  if (!notificationsEnabled) {
    return;
  }
}

Future<void> requestIOSPermissions() async {
  if (Platform.isIOS) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
}

Future<void> resetDailyScores() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? savedDate = prefs.getString('last_reset_date');
  final String currentDate = DateTime.now().toIso8601String().split('T').first;

  if (savedDate != currentDate) {
    await locator<UserDataRepository>().checkAndAddOverdueTasks(
      (await locator<UserDataRepository>().getUser())?.plannedTasksForWeek ??
          {},
    );

    final User? user = await locator<UserDataRepository>().getUser();

    if (user != null) {
      await locator<UserDataRepository>().saveUserAnalytics(UserAnalytics(
          user: user, date: DateFormat('yyyy-MM-dd').format(DateTime.now()),),);
      final updatedUser = User(
        name: user.name,
        completedTasksToday: const [],
        plannedTasksForWeek: user.plannedTasksForWeek,
        expectedScores: user.expectedScores,
        overdueTasks: user.overdueTasks,
      );

      await locator<UserDataRepository>().saveUser(updatedUser);
    }

    await prefs.setString('last_reset_date', currentDate);
  }

  final DateTime now = DateTime.now();
  final int dayOfWeek = now.weekday;
  final String? lastResetWeekDate = prefs.getString('last_reset_week_date');

  if (lastResetWeekDate == null || dayOfWeek == 1) {
    await locator<UserDataRepository>().resetWeeklyTasks();

    await prefs.setString('last_reset_week_date', currentDate);
  }
}
