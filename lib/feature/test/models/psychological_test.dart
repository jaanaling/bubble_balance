// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import 'package:bubblebalance/feature/test/models/test_outcome.dart';
import 'package:bubblebalance/feature/test/models/test_question.dart';
import 'package:bubblebalance/feature/test/models/test_result.dart';

class PsychologicalTest {
  final String id;
  final String title;
  final String link;
  final String description;
  final List<TestQuestion> questions;
  final String category;
  final List<TestOutcome> outcomes; // Переименовал results в outcomes
  bool isComplete;
  int currentQuestionIndex;
  TestResult? result; // Поле для хранения результата теста

  PsychologicalTest({
    required this.id,
    required this.title,
    required this.link,
    required this.description,
    required this.questions,
    required this.category,
    required this.outcomes,
    this.isComplete = false,
    this.currentQuestionIndex = 0,
    this.result, // Поле для хранения результата теста
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'link': link,
      'description': description,
      'questions': questions.map((q) => q.toMap()).toList(),
      'category': category,
      'outcomes': outcomes.map((o) => o.toMap()).toList(), // Изменил на outcomes
      'isComplete': isComplete,
      'currentQuestionIndex': currentQuestionIndex,
      'result': result?.toMap(), // Сохранение результата теста
    };
  }

  factory PsychologicalTest.fromMap(Map<String, dynamic> map) {
    return PsychologicalTest(
      id: map['id'] as String,
      link: map['link'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      questions: List<TestQuestion>.from(
        (map['questions'] as List)
            .map((q) => TestQuestion.fromMap(q as Map<String, dynamic>)),
      ),
      category: map['category'] as String,
      outcomes: List<TestOutcome>.from(
        (map['outcomes'] as List)
            .map((o) => TestOutcome.fromMap(o as Map<String, dynamic>)),
      ),
      isComplete: map['isComplete'] as bool? ?? false,
      currentQuestionIndex: map['currentQuestionIndex'] as int? ?? 0,
      result: map['result'] != null
          ? TestResult.fromMap(map['result'] as Map<String, dynamic>)
          : null, // Загружаем результат теста
    );
  }

  PsychologicalTest copyWith({
    String? id,
    String? title,
    String? link,
    String? description,
    List<TestQuestion>? questions,
    String? category,
    List<TestOutcome>? outcomes,
    bool? isComplete,
    int? currentQuestionIndex,
    TestResult? result,
  }) {
    return PsychologicalTest(
      id: id ?? this.id,
      title: title ?? this.title,
      link: link ?? this.link,
      description: description ?? this.description,
      questions: questions ?? this.questions,
      category: category ?? this.category,
      outcomes: outcomes ?? this.outcomes,
      isComplete: isComplete ?? this.isComplete,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      result: result ?? this.result,
    );
  }

  @override
  bool operator ==(covariant PsychologicalTest other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.title == title &&
      other.link == link &&
      other.description == description &&
      listEquals(other.questions, questions) &&
      other.category == category &&
      listEquals(other.outcomes, outcomes) &&
      other.isComplete == isComplete &&
      other.currentQuestionIndex == currentQuestionIndex &&
      other.result == result;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      link.hashCode ^
      title.hashCode ^
      description.hashCode ^
      questions.hashCode ^
      category.hashCode ^
      outcomes.hashCode ^
      isComplete.hashCode ^
      currentQuestionIndex.hashCode ^
      result.hashCode;
  }

  @override
  String toString() {
    return 'PsychologicalTest(id: $id, title: $title, description: $description, questions: $questions, category: $category, outcomes: $outcomes, isComplete: $isComplete, currentQuestionIndex: $currentQuestionIndex, result: $result)';
  }
}
