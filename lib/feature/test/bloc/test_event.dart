part of 'test_bloc.dart';

abstract class TestEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTestsEvent extends TestEvent {}

class SubmitAnswerEvent extends TestEvent {
  final int testId;
  final int currentQuestionIndex;
  final int score;
  final BuildContext context;

  SubmitAnswerEvent({
    required this.context,
    required this.testId,
    required this.currentQuestionIndex,
    required this.score,
  });

  @override
  List<Object> get props => [testId, currentQuestionIndex, score];
}

class SetCurrentTestEvent extends TestEvent {
  final PsychologicalTest test;

  SetCurrentTestEvent(this.test);

  @override
  List<Object?> get props => [test];
}

class ResetTestEvent extends TestEvent {
  final PsychologicalTest test;
  final BuildContext context;

  ResetTestEvent({required this.test, required this.context});

  @override
  List<Object> get props => [test];
}
