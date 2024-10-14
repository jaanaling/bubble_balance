part of 'test_bloc.dart';

abstract class TestState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TestInitial extends TestState {}

class TestLoadedState extends TestState {
  final List<PsychologicalTest> tests;
  final PsychologicalTest? currentTest;

  TestLoadedState({
    required this.tests,
    this.currentTest,
  });

  TestLoadedState copyWith({
    List<PsychologicalTest>? tests,
    PsychologicalTest? currentTest,
  }) {
    return TestLoadedState(
      tests: tests ?? this.tests,
      currentTest: currentTest ?? this.currentTest,
    );
  }

  @override
  List<Object?> get props => [
        tests,
        currentTest ?? [],
      ];
}
