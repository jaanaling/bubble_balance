import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:plinko/core/utils/icon_provider.dart';
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
    return SafeArea(
      child: ListView.separated(
        itemBuilder: itemBuilder,
        padding: const EdgeInsets.fromLTRB(16, 30, 16, 128),
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        separatorBuilder: (context, index) => const Gap(8),
        itemCount: tasks.length,
      ),
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        context.read<LifeAspectBloc>().add(
              isPlaning
                  ? PlanTaskForWeek(tasks[index], day!)
                  : AddCompletedTaskForToday(tasks[index]),
            );
        context.pop();
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(IconProvider.task.buildImageUrl()),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(9),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(2, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    tasks[index].name,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
              Gap(11),
              Align(
                alignment: Alignment.centerRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (final aspect in tasks[index].aspectScores.keys)
                      Text(
                        "${aspect}: ${tasks[index].aspectScores[aspect].toString()}",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
