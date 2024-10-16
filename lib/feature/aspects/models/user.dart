// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:bubblebalance/feature/aspects/models/life_aspect.dart';
import 'package:bubblebalance/feature/aspects/models/task.dart';

class User extends Equatable {
  final String name;
  Map<String, List<IdentifiedTask>> completedTasksWeek;
  Map<String, List<IdentifiedTask>> plannedTasksForWeek;
  Map<String, List<IdentifiedTask>> overdueTasks;
  Map<LifeAspect, double> expectedScores;

  User({
    required this.name,
    required this.completedTasksWeek,
    required this.plannedTasksForWeek,
    required this.expectedScores,
    required this.overdueTasks, // Инициализация нового поля
  });

  @override
  List<Object> get props => [
        name,
        completedTasksWeek,
        plannedTasksForWeek,
        expectedScores,
        overdueTasks, // Добавление в props
      ];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'completedTasksWeek': completedTasksWeek.map(
        (key, value) => MapEntry(
          key,
          value.map((task) => task.toMap()).toList(),
        ),
      ),
      'plannedTasksForWeek': plannedTasksForWeek.map(
        (key, value) => MapEntry(
          key,
          value.map((task) => task.toMap()).toList(),
        ),
      ),
      'expectedScores': expectedScores.map(
        (key, value) => MapEntry(key.name, value), // Используем `name` как ключ
      ),
      'overdueTasks': overdueTasks.map(
        (key, value) => MapEntry(
          key,
          value.map((task) => task.toMap()).toList(),
        ),
      ), // Сериализация просроченных тасков
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] as String,
      completedTasksWeek:
          (map['completedTasksWeek'] as Map<String, dynamic>).map(
        (day, tasks) => MapEntry(
          day,
          (tasks as List<dynamic>)
              .map(
                (task) => IdentifiedTask.fromMap(task as Map<String, dynamic>),
              )
              .toList(),
        ),
      ),
      plannedTasksForWeek:
          (map['plannedTasksForWeek'] as Map<String, dynamic>).map(
        (day, tasks) => MapEntry(
          day,
          (tasks as List<dynamic>)
              .map(
                (task) => IdentifiedTask.fromMap(task as Map<String, dynamic>),
              )
              .toList(),
        ),
      ),
      expectedScores: (map['expectedScores'] as Map<String, dynamic>).map(
        (aspectName, score) => MapEntry(
          LifeAspect(
              name: aspectName,
              optimalScore: 0.0,
              currentScore: 0.0), // Восстанавливаем LifeAspect по имени
          score as double,
        ),
      ),
      overdueTasks: (map['overdueTasks'] as Map<String, dynamic>).map(
        (day, tasks) => MapEntry(
          day,
          (tasks as List<dynamic>)
              .map(
                (task) => IdentifiedTask.fromMap(task as Map<String, dynamic>),
              )
              .toList(),
        ),
      ), // Десериализация просроченных тасков
    );
  }

  User copyWith({
    String? name,
    Map<String, List<IdentifiedTask>>? completedTasksWeek,
    Map<String, List<IdentifiedTask>>? plannedTasksForWeek,
    Map<LifeAspect, double>? expectedScores,
    Map<String, List<IdentifiedTask>>?
        overdueTasks, // Добавляем copyWith для нового поля
  }) {
    return User(
      name: name ?? this.name,
      completedTasksWeek: completedTasksWeek ?? this.completedTasksWeek,
      plannedTasksForWeek: plannedTasksForWeek ?? this.plannedTasksForWeek,
      expectedScores: expectedScores ?? this.expectedScores,
      overdueTasks: overdueTasks ?? this.overdueTasks, // Присваиваем новое поле
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;
}
