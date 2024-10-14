import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:plinko/core/utils/log.dart';
import 'package:plinko/feature/test/bloc/test_bloc.dart';
import 'package:plinko/feature/test/models/psychological_test.dart';
import 'package:plinko/routes/route_value.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: BlocBuilder<TestBloc, TestState>(
        builder: (context, state) {
          if (state is TestInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TestLoadedState) {
            final curTest = state.currentTest;

            if (curTest == null) {
              return Container();
            }

            final currentQuestion =
                curTest.questions[curTest.currentQuestionIndex];

                logger.d(curTest.currentQuestionIndex);


            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(currentQuestion.question),
                ListView.separated(
                  separatorBuilder: (context, index) => const Gap(14),
                  shrinkWrap: true,
                  itemCount: currentQuestion.answers.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        context.read<TestBloc>().add(
                              SubmitAnswerEvent(
                                context: context,
                                currentQuestionIndex:
                                    int.parse(currentQuestion.id),
                                score: currentQuestion.answers[index].score,
                                testId: int.parse(curTest.id),
                              ),
                            );
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(37.5),
                        ),
                        color: const Color(0xFFEFEFEF),
                        child: Padding(
                          padding: EdgeInsets.all(11),
                          child: Row(
                            children: [
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFF5C660),
                                      Color(0xFFF264CE),
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Gap(13),
                              Text(currentQuestion.answers[index].answerText),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          }
          ;
          return const Center(child: Text('Error loading tests'));
        },
      ),
    );
  }
}
