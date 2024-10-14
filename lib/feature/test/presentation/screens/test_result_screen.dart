import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:plinko/core/dependency_injection.dart';
import 'package:plinko/core/utils/log.dart';
import 'package:plinko/feature/test/bloc/test_bloc.dart';
import 'package:plinko/feature/test/models/psychological_test.dart';
import 'package:plinko/feature/test/repository/test_repository.dart';
import 'package:plinko/routes/route_value.dart';

class TestResultScreen extends StatelessWidget {
  final PsychologicalTest test;
  const TestResultScreen({super.key, required this.test});

  @override
  Widget build(BuildContext context) {
    logger.d(test);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Total Score: ${test.result?.totalScore ?? 0}'),
          Text('Outcome: ${test.result?.outcome ?? 'No outcome available'}'),
          ElevatedButton(
            onPressed: () {
              context.pop();
            },
            child: Text('Go Back'),
          ),
          ElevatedButton(
            onPressed: () {
              context.pushReplacement(
                "${RouteValue.tests.path}/${RouteValue.test.path}",
                extra: test,
              );
              context.read<TestBloc>().add(ResetTestEvent(int.parse(test.id)));
            },
            child: Text('Go Back'),
          ),
        ],
      ),
    );
  }
}
