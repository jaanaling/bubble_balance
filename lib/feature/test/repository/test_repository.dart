import 'dart:convert';
import 'package:bubblebalance/core/utils/log.dart';
import 'package:bubblebalance/feature/test/models/psychological_test.dart';
import 'package:bubblebalance/feature/test/models/test_outcome.dart';
import 'package:bubblebalance/feature/test/models/test_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestRepository {
  Future<void> saveUserPsychologicalTests(List<PsychologicalTest> tests) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String encodedTests = jsonEncode(
      tests.map((test) => test.toMap()).toList(),
    );
    await prefs.setString('psychologicalTests', encodedTests);
  }

  Future<List<PsychologicalTest>> getAllTests() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? testJson = prefs.getString('psychologicalTests');

    if (testJson != null) {
      final List<dynamic> jsonList = jsonDecode(testJson) as List<dynamic>;
      return jsonList
          .map(
              (item) => PsychologicalTest.fromMap(item as Map<String, dynamic>))
          .toList();
    }

    return [];
  }

  Future<void> saveUserTestResult(
      int testId, int score, List<TestOutcome> outcomes) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final result = TestResult(
      totalScore: score,
      outcome: _getOutcomeForScore(outcomes, score),
      testId: testId,
    );

    final List<PsychologicalTest> allTests = await getAllTests();

    for (var test in allTests) {
      if (int.parse(test.id) == testId) {
        test.isComplete = true;
        test.result = result;
        break;
      }
    }

    final String updatedTestsJson = jsonEncode(
      allTests.map((test) => test.toMap()).toList(),
    );
    await prefs.setString('psychologicalTests', updatedTestsJson);
  }

  String _getOutcomeForScore(List<TestOutcome> outcomes, int score) {
    for (final outcome in outcomes) {
      if (score >= outcome.scoreRange.first &&
          score <= outcome.scoreRange.last) {
        return outcome.result;
      }
    }
    return 'No result';
  }

  Future<void> updateTestProgress(int testId, int selectedAnswerScore) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<PsychologicalTest> allTests = await getAllTests();

    for (var test in allTests) {
      if (int.parse(test.id) == testId) {
        if (test.result != null) {
          test.result!.totalScore += selectedAnswerScore;
        } else {
          test.result = TestResult(
            totalScore: selectedAnswerScore,
            outcome: '',
            testId: testId,
          );
        }

        test.currentQuestionIndex = test.currentQuestionIndex + 1;
  

        break;
      }
    }

    final String updatedTestsJson = jsonEncode(
      allTests.map((test) => test.toMap()).toList(),
    );
    await prefs.setString('psychologicalTests', updatedTestsJson);
  }

  Future<void> resetTest(int testId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<PsychologicalTest> allTests = await getAllTests();

    for (var test in allTests) {
      if (int.parse(test.id) == testId) {
        // Сбрасываем прогресс и результат теста
        test.currentQuestionIndex = 0;
        test.result = null;
        test.isComplete = false;
        break;
      }
    }

    final String updatedTestsJson = jsonEncode(
      allTests.map((test) => test.toMap()).toList(),
    );
    await prefs.setString('psychologicalTests', updatedTestsJson);
  }
}
