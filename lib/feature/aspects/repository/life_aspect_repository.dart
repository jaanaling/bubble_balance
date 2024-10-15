import 'dart:convert';

import 'package:bubblebalance/feature/aspects/models/life_aspect.dart';
import 'package:bubblebalance/feature/aspects/models/task.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LifeAspectRepository {
  Future<void> saveAspects(List<LifeAspect> aspects) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> aspectsJson =
        aspects.map((aspect) => jsonEncode(aspect.toMap())).toList();
    await prefs.setStringList('aspects', aspectsJson);
  }

  Future<List<LifeAspect>> getAspects() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? aspectsJson = prefs.getStringList('aspects');
    if (aspectsJson != null) {
      return aspectsJson
          .map((json) =>
              LifeAspect.fromMap(jsonDecode(json) as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<void> saveTasks(List<Task> tasks) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tasksJson =
        tasks.map((task) => jsonEncode(task.toMap())).toList();
    await prefs.setStringList('tasks', tasksJson);
  }

  Future<List<Task>> getTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? tasksJson = prefs.getStringList('tasks');
    if (tasksJson != null) {
      return tasksJson
          .map((json) => Task.fromMap(jsonDecode(json) as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
