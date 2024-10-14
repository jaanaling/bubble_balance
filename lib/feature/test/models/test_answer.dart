class TestAnswer {
  final String id;
  final String answerText;
  final int score; // Очки или рейтинг за выбор данного ответа

  TestAnswer({
    required this.id,
    required this.answerText,
    required this.score,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'answerText': answerText,
      'score': score,
    };
  }

  factory TestAnswer.fromMap(Map<String, dynamic> map) {
    return TestAnswer(
      id: map['id'] as String,
      answerText: map['answerText'] as String,
      score: map['score'] as int,
    );
  }
}
