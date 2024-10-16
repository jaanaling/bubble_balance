import 'dart:convert';
import 'package:bubblebalance/core/dependency_injection.dart';
import 'package:bubblebalance/core/utils/log.dart';
import 'package:bubblebalance/feature/analytics/bloc/analytics_bloc.dart';
import 'package:bubblebalance/feature/aspects/models/task.dart';
import 'package:bubblebalance/feature/aspects/models/user.dart';
import 'package:bubblebalance/feature/aspects/models/life_aspect.dart';
import 'package:bubblebalance/feature/analytics/models/user_analytics.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class UserDataRepository {
  Future<void> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userJson = user.toJson();
    logger.d(userJson);
    await prefs.setString('user', userJson);
    String monthName =
        DateFormat('MMMM').format(DateTime.now()); // Получение названия месяца
    DateTime firstDayOfMonth =
        DateTime(DateTime.now().year, DateTime.now().month, 1);

    // Узнаем день недели для первого дня месяца
    int firstWeekday = firstDayOfMonth.weekday;

    // Считаем, сколько дней с начала недели до текущей даты
    int daysOffset = DateTime.now().day + firstWeekday - 1;

    // Считаем номер недели

    int monthWeek = (daysOffset / 7).ceil();

    String result = '$monthName $monthWeek';

    await saveUserAnalytics(UserAnalytics(user: user, date: result));
    locator<AnalyticsBloc>()..add(LoadAnalyticsEvent());
  }

  Future<User?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userJson = prefs.getString('user');
    if (userJson != null) {
      return User.fromMap(jsonDecode(userJson) as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> addCompletedTaskForToday(
      Map<String, List<IdentifiedTask>> completedTasksWeek) async {
    final User? user = await getUser();

    if (user != null) {
      completedTasksWeek.forEach((day, tasks) {
        if (user.completedTasksWeek.containsKey(day)) {
          user.completedTasksWeek[day]?.addAll(tasks);
        } else {
          user.completedTasksWeek[day] = tasks;
        }
      });

      await saveUser(user);
    }
  }

  Future<void> updatePlannedTasksForWeek(
    Map<String, List<Task>> plannedTasksForWeek,
  ) async {
    final User? user = await getUser();
    if (user != null) {
      user.plannedTasksForWeek = plannedTasksForWeek.map(
        (key, value) => MapEntry(
          key,
          value.map((task) {
            final uniqueId = const Uuid().v4();
            return IdentifiedTask(id: uniqueId, task: task);
          }).toList(),
        ),
      );
      await saveUser(user);
    }
  }

  Future<void> saveUserAnalytics(UserAnalytics analytics) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? existingAnalyticsJson = prefs.getString('user_analytics');

    List<UserAnalytics> analyticsList = [];
    logger.d(existingAnalyticsJson);

    if (existingAnalyticsJson != null) {
      final List<dynamic> existingAnalyticsList =
          jsonDecode(existingAnalyticsJson) as List<dynamic>;
      analyticsList = existingAnalyticsList
          .map((item) => UserAnalytics.fromMap(item as Map<String, dynamic>))
          .toList();
    }
    if (analyticsList.where((t) => t.date == analytics.date).isNotEmpty) {
      analyticsList[analyticsList.indexWhere((t) => t.date == analytics.date)] =
          analytics;
      logger.d(analyticsList);
    } else {
      analyticsList.add(analytics);
      logger.d(analyticsList);
    }

    final String newAnalyticsJson =
        jsonEncode(analyticsList.map((a) => a.toMap()).toList());
    await prefs.setString('user_analytics', newAnalyticsJson);
  }

  Future<List<UserAnalytics>?> getUserAnalytics() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? analyticsJson = prefs.getString('user_analytics');
    if (analyticsJson != null) {
      final List<dynamic> analyticsList =
          jsonDecode(analyticsJson) as List<dynamic>;
      return analyticsList
          .map((item) => UserAnalytics.fromMap(item as Map<String, dynamic>))
          .toList();
    }
    return null;
  }

  Future<void> removeTaskFromPlannedForWeek(IdentifiedTask task) async {
    final User? user = await getUser();
    if (user != null) {
      final updatedPlannedTasksForWeek =
          Map<String, List<IdentifiedTask>>.from(user.plannedTasksForWeek);

      updatedPlannedTasksForWeek.forEach((day, tasks) {
        updatedPlannedTasksForWeek[day] =
            tasks.where((t) => t.id != task.id).toList();
      });

      user.plannedTasksForWeek = updatedPlannedTasksForWeek;
      await saveUser(user);
    }
  }

  Future<void> updateExpectedScores(
    Map<LifeAspect, double> expectedScores,
  ) async {
    final User? user = await getUser();
    if (user != null) {
      user.expectedScores = expectedScores;
      await saveUser(user);
    }
  }

  Future<void> removeCompletedTaskForToday(
      IdentifiedTask task, String day) async {
    final User? user = await getUser();
    if (user != null) {
      if (user.completedTasksWeek.containsKey(day)) {
        user.completedTasksWeek[day]?.removeWhere((t) => t.id == task.id);

        if (user.completedTasksWeek[day]?.isEmpty ?? false) {
          user.completedTasksWeek.remove(day);
        }

        await saveUser(user);
      }
    }
  }

  Future<void> checkAndAddOverdueTasks(
      Map<String, List<IdentifiedTask>> plannedTasksForWeek) async {
    final User? user = await getUser();
    if (user != null) {
      final DateTime currentDate = DateTime.now();
      final int currentWeekday = currentDate.weekday;

      final updatedPlannedTasksForWeek =
          Map<String, List<IdentifiedTask>>.from(plannedTasksForWeek);

      List<String> daysToRemove = [];

      updatedPlannedTasksForWeek.forEach((day, tasks) {
        final int taskWeekday = int.parse(day);

        if (taskWeekday < currentWeekday) {
          if (user.overdueTasks.containsKey(day)) {
            user.overdueTasks[day]?.addAll(tasks);
          } else {
            user.overdueTasks[day] = tasks;
          }

          daysToRemove.add(day);
        }
      });

      for (var day in daysToRemove) {
        updatedPlannedTasksForWeek.remove(day);
      }

      user.plannedTasksForWeek = updatedPlannedTasksForWeek;

      await saveUser(user);
    }
  }

  Future<void> removeOverdueTask(String day, IdentifiedTask task) async {
    final User? user = await getUser();
    if (user != null) {
      if (user.overdueTasks.containsKey(day)) {
        user.overdueTasks[day]?.removeWhere((t) => t.id == task.id);

        if (user.overdueTasks[day]?.isEmpty ?? false) {
          user.overdueTasks.remove(day);
        }

        await saveUser(user);
      }
    }
  }

  Future<void> addCompletedTaskFromOverdue(
      String day, IdentifiedTask task) async {
    final User? user = await getUser();
    if (user != null) {
      if (user.overdueTasks.containsKey(day)) {
        await addCompletedTaskForToday({
          day: [task]
        });

        await removeOverdueTask(day, task);
      }
    }
  }

  Future<void> resetWeeklyTasks() async {
    final User? user = await getUser();
    logger.d(user.toString());
    if (user != null) {
      final updatedUser = User(
        name: user.name,
        completedTasksWeek: {},
        plannedTasksForWeek: {},
        expectedScores: user.expectedScores,
        overdueTasks: {},
      );

      await saveUser(updatedUser);
    }
  }
}
