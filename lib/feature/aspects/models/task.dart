// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String name;
  final Map<String, double> aspectScores;

  const Task({
    required this.name,
    required this.aspectScores,
  });

  @override
  List<Object> get props => [name, aspectScores];

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'aspectScores': aspectScores,
    };
  }

  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      name: map['name'] as String,
      aspectScores: Map<String, double>.from(map['aspectScores'] as Map),
    );
  }
}

class IdentifiedTask {
  final String id;
  final Task task;

  IdentifiedTask({required this.id, required this.task});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'task': task.toMap(),
    };
  }

  factory IdentifiedTask.fromMap(Map<String, dynamic> map) {
    return IdentifiedTask(
      id: map['id'] as String,
      task: Task.fromMap(map['task'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory IdentifiedTask.fromJson(String source) => IdentifiedTask.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant IdentifiedTask other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.task == task;
  }

  @override
  int get hashCode => id.hashCode ^ task.hashCode;
}
