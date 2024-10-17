import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:bubblebalance/feature/test/bloc/test_bloc.dart';
import 'package:bubblebalance/routes/route_value.dart';

class TestsScreen extends StatefulWidget {
  const TestsScreen({super.key});

  @override
  State<TestsScreen> createState() => _TestsScreenState();
}

class _TestsScreenState extends State<TestsScreen> {
  int _selectedIndex = 0;
  void _showDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('Important Notice'),
        content: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Text(
            'The tests provided are for educational and entertainment purposes only and are not medical. '
            'The results of these tests cannot replace professional consultation. '
            'If you have serious psychological or emotional issues, it is strongly recommended to consult a qualified psychologist or psychiatrist for professional assistance and accurate information.',
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: Text('Understood'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _showDialog(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TestBloc, TestState>(
      builder: (context, state) {
        if (state is TestInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TestLoadedState) {
          final completedTests = state.tests.where((test) {
            return test.isComplete;
          }).toList();

          final tests = state.tests.where((test) {
            return !test.isComplete;
          }).toList();

          final currentTests = _selectedIndex == 0 ? tests : completedTests;

          return Stack(
            children: [
              ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 140),
                itemCount: currentTests.length,
                itemBuilder: (context, index) {
                  final test = currentTests[index];

                  final isCompleted = test.isComplete;

                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    color: isCompleted
                        ? Colors.green.shade100
                        : const Color(0xFFEFEFEF),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    test.title,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Mon',
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    test.description,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Mon',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(16),
                            InkWell(
                              onTap: () {
                                context
                                    .read<TestBloc>()
                                    .add(SetCurrentTestEvent(test));

                                isCompleted
                                    ? context.push(
                                        '${RouteValue.tests.path}/${RouteValue.testResult.path}',
                                        extra: test,
                                      )
                                    : context.push(
                                        '${RouteValue.tests.path}/${RouteValue.test.path}',
                                        extra: test,
                                      );
                              },
                              borderRadius: BorderRadius.circular(25),
                              child: Ink(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFF5C660),
                                      Color(0xFFF264CE),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: const Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 11),
                                    child: Text(
                                      'Start',
                                      style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        fontFamily: 'Mon',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                  );
                },
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTabItem(0, 'Tests'),
                      const Gap(1),
                      _buildTabItem(1, 'Finished'),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else {
          return const Center(child: Text('Error loading tests'));
        }
      },
    );
  }

  Widget _buildTabItem(
    int index,
    String label,
  ) {
    final bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        width: MediaQuery.of(context).size.width * 0.41,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(index == 0 ? 10 : 0),
            bottomLeft: Radius.circular(index == 0 ? 10 : 0),
            topRight: Radius.circular(index == 1 ? 10 : 0),
            bottomRight: Radius.circular(index == 1 ? 10 : 0),
          ),
          boxShadow: [
            if (isSelected)
              const BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
              ),
          ],
        ),
        duration: Durations.short4,
        child: Text(
          label,
          style: _selectedIndex == index
              ? const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontFamily: 'Mon',
                )
              : const TextStyle(
                  fontSize: 24,
                  fontFamily: 'Mon',
                ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
