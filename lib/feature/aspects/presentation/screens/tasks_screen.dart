import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plinko/feature/aspects/bloc/aspect_bloc.dart';
import 'package:plinko/feature/aspects/models/task.dart';

class TasksScreen extends StatelessWidget {
  final List<Task> tasks;
  final bool isPlaning;
  final String? day;

  const TasksScreen({
    super.key,
    required this.tasks,
    required this.isPlaning,
    this.day,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: itemBuilder,
      separatorBuilder: (context, index) => const Divider(),
      itemCount: tasks.length,
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => context.read<LifeAspectBloc>().add(
            isPlaning
                ? PlanTaskForWeek(tasks[index], day!)
                : AddCompletedTaskForToday(tasks[index]),
          ),
      child: Text(tasks[index].name),
    );
  }
}
