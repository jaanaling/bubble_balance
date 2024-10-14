import 'dart:convert';
import 'package:plinko/core/utils/log.dart';
import 'package:plinko/feature/aspects/models/task.dart';
import 'package:plinko/feature/aspects/models/user.dart';
import 'package:plinko/feature/aspects/models/life_aspect.dart';
import 'package:plinko/feature/analytics/models/user_analytics.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class UserDataRepository {
  Future<void> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userJson = user.toJson();
    logger.d(userJson);
    await prefs.setString('user', userJson);
  }

  Future<User?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userJson = prefs.getString('user');
    if (userJson != null) {
      return User.fromMap(jsonDecode(userJson) as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> addCompletedTaskForToday(IdentifiedTask task) async {
    final User? user = await getUser();
    if (user != null) {
      user.completedTasksToday.add(task);
      removeTaskFromPlannedForWeek(task);

      await saveUser(user);
    }
  }

  Future<void> updateCompletedTasks(List<IdentifiedTask> completedTasks) async {
    final User? user = await getUser();
    if (user != null) {
      user.completedTasksToday = completedTasks;
      await saveUser(user);
    }
  }

  Future<void> updatePlannedTasks(
    Map<String, List<IdentifiedTask>> plannedTasks,
  ) async {
    final User? user = await getUser();
    if (user != null) {
      user.plannedTasksForWeek = plannedTasks;
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
    final String analyticsJson = jsonEncode(analytics.toMap());
    await prefs.setString('user_analytics', analyticsJson);
  }

  Future<UserAnalytics?> getUserAnalytics() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? analyticsJson = prefs.getString('user_analytics');
    if (analyticsJson != null) {
      return UserAnalytics.fromMap(
        jsonDecode(analyticsJson) as Map<String, dynamic>,
      );
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

  Future<void> removeCompletedTaskForToday(IdentifiedTask task) async {
    final User? user = await getUser();
    if (user != null) {
      final updatedCompletedTasks =
          user.completedTasksToday.where((t) => t.id != task.id).toList();
      user.completedTasksToday = updatedCompletedTasks;
      await saveUser(user);
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
        await addCompletedTaskForToday(task);

        await removeOverdueTask(day, task);
      }
    }
  }

  Future<void> resetWeeklyTasks() async {
    final User? user = await getUser();
    logger.d(user.toString());
    if (user != null) {
      final completedTasksCount = user.completedTasksToday.length;

      final updatedUser = User(
        name: user.name,
        completedTasksToday: [],
        plannedTasksForWeek: {},
        expectedScores: user.expectedScores,
        overdueTasks: {},
      );

      await saveUser(updatedUser);
    }
  }
}
