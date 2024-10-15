import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:bubblebalance/core/utils/log.dart';
import 'package:bubblebalance/feature/test/bloc/test_bloc.dart';
import 'package:bubblebalance/feature/test/models/psychological_test.dart';
import 'package:bubblebalance/routes/route_value.dart';

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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Text(
                    currentQuestion.question,
                    style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: 'Mon'),
                    textAlign: TextAlign.center,
                  ),
                ),
                ListView.separated(
                  separatorBuilder: (context, index) => const Gap(14),
                  shrinkWrap: true,
                  itemCount: currentQuestion.answers.length,
                  padding: EdgeInsets.only(bottom: 80),
                  itemBuilder: (context, index) {
                    return InkWell(
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
                      splashColor: Colors.deepPurpleAccent,
                      borderRadius: BorderRadius.circular(37.5),
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
                              Ink(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFF5C660),
                                      Color(0xFFF264CE),
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: SizedBox(
                                  height: 54,
                                  width: 54,
                                  child: Center(
                                    child: Text(
                                      String.fromCharCode(index + 65),
                                      style: TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                          fontFamily: 'Mon'),
                                    ),
                                  ),
                                ),
                              ),
                              Gap(13),
                              Expanded(
                                child: Text(
                                  currentQuestion.answers[index].answerText,
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Mon'),
                                ),
                              ),
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
