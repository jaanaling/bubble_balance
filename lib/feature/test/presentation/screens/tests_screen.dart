import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:plinko/core/utils/icon_provider.dart';
import 'package:plinko/core/utils/log.dart';
import 'package:plinko/feature/test/bloc/test_bloc.dart';
import 'package:plinko/routes/route_value.dart';

class TestsScreen extends StatefulWidget {
  const TestsScreen({super.key});

  @override
  State<TestsScreen> createState() => _TestsScreenState();
}

class _TestsScreenState extends State<TestsScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TestBloc, TestState>(
      builder: (context, state) {
        if (state is TestInitial) {
          return Center(child: CircularProgressIndicator());
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
                      borderRadius: BorderRadius.circular(37.5),
                    ),
                    color: isCompleted ? Colors.green : Color(0xFFEFEFEF),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(test.title),
                        subtitle: Text(test.description),
                        trailing: ElevatedButton(
                          onPressed: () {
                            context
                                .read<TestBloc>()
                                .add(SetCurrentTestEvent(test));

                            isCompleted
                                ? context.push(
                                    "${RouteValue.tests.path}/${RouteValue.testResult.path}",
                                    extra: test,
                                  )
                                : context.push(
                                    "${RouteValue.tests.path}/${RouteValue.test.path}",
                                    extra: test,
                                  );
                          },
                          child: Text('Start'),
                        ),
                      ),
                    ),
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
          return Center(child: Text('Error loading tests'));
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
              ? TextStyle(fontSize: 24, color: Colors.white)
              : TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
