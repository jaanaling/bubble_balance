import 'dart:async';
import 'dart:io';
import 'package:bubblebalance/firebase_options.dart';
import 'package:bubblebalance/routes/route_value.dart';
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
import 'package:core_logic/core_logic.dart';
import 'package:core_amplitude/core_amplitude.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  runZonedGuarded(() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencyInjection();
  tz.initializeTimeZones();
  await loadInitialData();

  await locator<UserDataRepository>().checkAndAddOverdueTasks(
    (await locator<UserDataRepository>().getUser())?.plannedTasksForWeek ?? {},
  );

  FlutterError.onError = (FlutterErrorDetails details) {
         _handleFlutterError(details);
      };

  await resetDailyScores();

   await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);

  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await InitializationUtil.coreInit(
    domain: 'bubblebalancea.com',
    amplitudeKey: '6e2e123f7a72088de2ecf4bee32a3b4',
    appsflyerDevKey: 'itWzWpyu4WUntPctTm8Jqe',
    appId: 'com.superpaper.balancebubbles',
    iosAppId: '6736939244',
    initialRoute: RouteValue.menu.path, facebookAppId: '1698188717422133', facebookClientToken: '79152d0635e71af9299df0c60d6fe545',
  );

  runApp(
    const AppRoot(),
  );
  }, (Object error, StackTrace stackTrace) {
      _handleAsyncError(error, stackTrace);
   });
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final prefs = await SharedPreferences.getInstance();
  final notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
  if (!notificationsEnabled) {
    return;
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
      await locator<UserDataRepository>().saveUserAnalytics(
        UserAnalytics(
          user: user,
          date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        ),
      );
      final updatedUser = User(
        name: user.name,
        completedTasksWeek: user.completedTasksWeek,
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

void _handleFlutterError(FlutterErrorDetails details) {
   AmplitudeUtil.logFailure(
      details.exception is Exception ? Failure.exception : Failure.error,
      details.exception.toString(),
      details.stack,
   );
}

void _handleAsyncError(Object error, StackTrace stackTrace) {
   AmplitudeUtil.logFailure(
      error is Exception ? Failure.exception : Failure.error,
      error.toString(),
      stackTrace,
   );
}
