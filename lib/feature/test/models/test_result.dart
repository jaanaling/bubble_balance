// ignore_for_file: public_member_api_docs, sort_constructors_first
class TestResult {
  int totalScore;
  final int testId;
  final String outcome;

  TestResult({
    required this.testId,
    required this.totalScore,
    required this.outcome,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'testId': testId,
      'totalScore': totalScore,
      'outcome': outcome,
    };
  }

  factory TestResult.fromMap(Map<String, dynamic> map) {
    return TestResult(
      testId: map['testId'] as int,
      totalScore: map['totalScore'] as int,
      outcome: map['outcome'] as String,
    );
  }
}
