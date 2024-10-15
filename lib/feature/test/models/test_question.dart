import 'package:bubblebalance/feature/test/models/test_answer.dart';

class TestQuestion {
  final String id;
  final String question;
  final List<TestAnswer> answers;

  TestQuestion({
    required this.id,
    required this.question,
    required this.answers,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'answers': answers.map((a) => a.toMap()).toList(),
    };
  }

  factory TestQuestion.fromMap(Map<String, dynamic> map) {
    return TestQuestion(
      id: map['id'] as String,
      question: map['question'] as String ,
      answers: List<TestAnswer>.from(
        (map['answers'] as List).map((a) => TestAnswer.fromMap(a as Map<String, dynamic>)),
      ),
    );
  }
}
