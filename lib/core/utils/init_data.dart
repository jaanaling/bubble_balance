import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:plinko/core/dependency_injection.dart';
import 'package:plinko/feature/aspects/models/life_aspect.dart';

import 'package:plinko/feature/aspects/models/task.dart';
import 'package:plinko/feature/test/models/psychological_test.dart'; // Импорт модели психологических тестов
import 'package:plinko/feature/aspects/repository/life_aspect_repository.dart';
import 'package:plinko/feature/test/repository/test_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> loadInitialData() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Загрузка аспектов
  if (!prefs.containsKey('aspects')) {
    final String aspectsJson =
        await rootBundle.loadString('assets/json/aspects.json');
    final List<dynamic> aspectsList = jsonDecode(aspectsJson) as List<dynamic>;
    final List<LifeAspect> aspects = aspectsList
        .map((aspect) => LifeAspect.fromMap(aspect as Map<String, dynamic>))
        .toList();
    await locator<LifeAspectRepository>().saveAspects(aspects);
  }

  // Загрузка задач
  if (!prefs.containsKey('tasks')) {
    final String tasksJson =
        await rootBundle.loadString('assets/json/tasks.json');
    final List<dynamic> tasksList = jsonDecode(tasksJson) as List<dynamic>;
    final List<Task> tasks = tasksList
        .map((task) => Task.fromMap(task as Map<String, dynamic>))
        .toList();
    await locator<LifeAspectRepository>().saveTasks(tasks);
  }

  // Загрузка психологических тестов
  if (!prefs.containsKey('psychologicalTests')) {
    final String testsJson =
        await rootBundle.loadString('assets/json/psychological_tests.json');
    final List<dynamic> testsList = jsonDecode(testsJson) as List<dynamic>;
    final List<PsychologicalTest> tests = testsList
        .map((test) => PsychologicalTest.fromMap(test as Map<String, dynamic>))
        .toList();
    await locator<TestRepository>().saveUserPsychologicalTests(tests); // Метод для сохранения тестов
  }
}
