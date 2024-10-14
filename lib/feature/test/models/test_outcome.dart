class TestOutcome {
  final List<int> scoreRange;
  final String result;

  TestOutcome({
    required this.scoreRange,
    required this.result,
  });

  Map<String, dynamic> toMap() {
    return {
      'scoreRange': scoreRange,
      'result': result,
    };
  }

  factory TestOutcome.fromMap(Map<String, dynamic> map) {
    return TestOutcome(
      scoreRange: List<int>.from(map['scoreRange'] as List),
      result: map['result'] as String,
    );
  }
}