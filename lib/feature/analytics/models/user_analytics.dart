// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class UserAnalytics extends Equatable {
  final Map<String, double> aspectScores; // Хранит очки по аспектам
  final int totalTasksCompleted;
  final int totalTasksPlanned;

  UserAnalytics({
    required this.aspectScores,
    required this.totalTasksCompleted,
    required this.totalTasksPlanned,
  });

  @override
  List<Object?> get props =>
      [aspectScores, totalTasksCompleted, totalTasksPlanned];

  // Генерация рекомендаций
  List<String> generateRecommendations() {
    List<String> recommendations = [];
    for (var entry in aspectScores.entries) {
      if (entry.value < 50) {
        recommendations.add('Уделите больше времени на ${entry.key}.');
      }
    }
    return recommendations;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'aspectScores': aspectScores,
      'totalTasksCompleted': totalTasksCompleted,
      'totalTasksPlanned': totalTasksPlanned,
    };
  }

  factory UserAnalytics.fromMap(Map<String, dynamic> map) {
    return UserAnalytics(
      aspectScores: Map<String, double>.from((map['aspectScores'] as Map<String, double>)),
      totalTasksCompleted: map['totalTasksCompleted'] as int,
      totalTasksPlanned: map['totalTasksPlanned'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserAnalytics.fromJson(String source) => UserAnalytics.fromMap(json.decode(source) as Map<String, dynamic>);
}
