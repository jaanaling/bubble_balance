import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:plinko/feature/aspects/bloc/aspect_bloc.dart';
import 'package:plinko/feature/aspects/models/task.dart';
import 'package:plinko/feature/aspects/utils/utils.dart';
import 'package:plinko/routes/route_value.dart';
import 'package:plinko/ui_kit/base_container/base_container.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _selectedIndex = 0;
  int pageIndex = 0;
  String day = '${DateTime.now().weekday} ';
  final PageController _pageController = PageController();
  final List<String> weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  String getFormattedDate(String dayString) {
    int dayNumber = int.parse(dayString);
    DateTime date = DateTime(2023, 1, dayNumber + 1);
    return DateFormat('EEEE').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTabItem(0, 'DAY'),
                const Gap(1),
                _buildTabItem(1, 'WEEK'),
              ],
            ),
          ),
        ),

        if(_selectedIndex==1)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: CupertinoButton(
            onPressed: () {
              showCupertinoModalPopup(
                context: context,
                builder: (context) {
                  return Container(
                    height: 250,
                    color: CupertinoColors.systemBackground,
                    child: CupertinoPicker(
                      itemExtent: 32.0,
                      onSelectedItemChanged: (int index) {
                        setState(() {
                          day = '${index + 1}';
                        });
                      },
                      children: weekdays.map((day) => Text(day)).toList(),
                    ),
                  );
                },
              );
            },
            color: Color(0xFFEFEFEF),
            padding: EdgeInsets.zero,
            borderRadius: BorderRadius.circular(15),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    getFormattedDate(day),
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontFamily: 'Mon',
                    ),
                  ),
                  const Gap(20),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xFF939393),
                  )
                ],
              ),
            ),
          ),
        ),
        BlocBuilder<LifeAspectBloc, LifeAspectState>(
          builder: (context, state) {
            if (state is AspectsLoaded) {
              return Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      pageIndex = index;
                    });
                  },
                  itemCount: state.aspects.length,
                  itemBuilder: (context, index) {
                    final aspect = state.aspects[index];
                    final completedTasks = state.user.completedTasksToday;
                    final plannedTasks =
                        state.user.plannedTasksForWeek[day] ?? [];
                    final overdueTasks = state.user.overdueTasks[day] ?? [];

                    final tasks = [
                      ...completedTasks,
                      ...plannedTasks,
                      ...overdueTasks,
                    ]
                        .where(
                          (task) =>
                              task.task.aspectScores.containsKey(aspect.name),
                        )
                        .toList();

                    final aspectScores = state.user.completedTasksToday
                        .where(
                          (t) => t.task.aspectScores.containsKey(aspect.name),
                        )
                        .map(
                          (t) => t.task.aspectScores[aspect.name] ?? 0,
                        );

                    final Color color = aspectScores.isNotEmpty
                        ? getColorFromScores(
                            aspectScores.reduce(
                              (value, element) => value + element,
                            ),
                            state.aspects[index].optimalScore,
                          ).withOpacity(1.0)
                        : const Color(0xFFD72E58);

                    return Column(
                      children: [
                        Text(
                          aspect.name,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        const Gap(14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (pageIndex > 0)
                              IconButton(
                                onPressed: () => setState(() {
                                  _pageController.jumpToPage(--pageIndex);
                                }),
                                icon: const Icon(
                                  CupertinoIcons.left_chevron,
                                  color: Color(0xFFB5B5B5),
                                ),
                                iconSize: 55,
                              ),
                            if (state.aspects.length > pageIndex + 1)
                              const Spacer(),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: MediaQuery.of(context).size.height * 0.3,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    Color.lerp(
                                      color,
                                      Colors.white,
                                      0.8,
                                    )!,
                                    color,
                                  ],
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                ),
                              ),
                            ),
                            if (state.aspects.length > pageIndex + 1)
                              IconButton(
                                onPressed: () => setState(() {
                                  _pageController.jumpToPage(++pageIndex);
                                }),
                                icon: const Icon(
                                  CupertinoIcons.right_chevron,
                                  color: Color(0xFFB5B5B5),
                                ),
                                iconSize: 55,
                              ),
                            if (state.aspects.length <= pageIndex + 1)
                              const Spacer(),
                          ],
                        ),
                        const Gap(25),
                        GestureDetector(
                          onTap: () => context.push(
                            '${RouteValue.menu.path}/${RouteValue.tasks.path}',
                            extra: {
                              'tasks': state.tasks
                                  .where(
                                    (Task t) =>
                                        t.aspectScores.containsKey(aspect.name),
                                  )
                                  .toList(),
                              'day': _selectedIndex == 1 ? day : null,
                            },
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 56),
                            child: BaseContainer(
                              text: Text(
                                'add text recording',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              paddingHorizontal: 40,
                              paddingVertical: 20,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.fromLTRB(21, 20, 21, 150),
                            shrinkWrap: true,
                            itemCount: tasks.length,
                            separatorBuilder: (_, __) => Padding(
                              padding: const EdgeInsets.all(21.0),
                              child: Divider(
                                color: Colors.black.withOpacity(0.3),
                                thickness: 2,
                                height: 2,
                              ),
                            ),
                            itemBuilder: (context, index) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color.fromARGB(30, 0, 0, 0),
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      completedTasks.contains(tasks[index])
                                          ? Icons.done
                                          : plannedTasks.contains(tasks[index])
                                              ? Icons.alarm
                                              : Icons.dangerous,
                                      color: completedTasks
                                              .contains(tasks[index])
                                          ? Colors.green
                                          : plannedTasks.contains(tasks[index])
                                              ? Colors.orange
                                              : Colors.red,
                                      size: 30,
                                    ),
                                  ),
                                ),
                                Text(
                                  tasks[index].task.name,
                                  style: const TextStyle(
                                    fontSize: 19,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        if (completedTasks
                                            .contains(tasks[index])) {}
                                        if ((plannedTasks
                                            .contains(tasks[index]))) {
                                          context.read<LifeAspectBloc>().add(
                                                MarkTaskAsCompleted(
                                                  tasks[index],
                                                ),
                                              );
                                        }
                                        if (overdueTasks
                                            .contains(tasks[index])) {
                                          context.read<LifeAspectBloc>().add(
                                                RemoveOverdueTask(
                                                  day: day,
                                                  task: tasks[index],
                                                ),
                                              );
                                        }
                                      },
                                      icon: Icon(
                                        Icons.check,
                                        color: !completedTasks
                                                .contains(tasks[index])
                                            ? Colors.green
                                            : Colors.transparent,
                                        size: 30,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        if (completedTasks
                                            .contains(tasks[index])) {
                                          context.read<LifeAspectBloc>().add(
                                                DeleteCompletedTask(
                                                  day: day,
                                                  task: tasks[index],
                                                ),
                                              );
                                        }
                                        if (plannedTasks
                                            .contains(tasks[index])) {
                                          context.read<LifeAspectBloc>().add(
                                                DeletePlannedTask(
                                                  day: day,
                                                  task: tasks[index],
                                                ),
                                              );
                                        }
                                        if (overdueTasks
                                            .contains(tasks[index])) {
                                          context.read<LifeAspectBloc>().add(
                                                RemoveOverdueTask(
                                                  day: day,
                                                  task: tasks[index],
                                                ),
                                              );
                                        }
                                        setState(() {});
                                      },
                                      icon: const Icon(
                                        CupertinoIcons.delete,
                                        color: Colors.red,
                                        size: 30,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            }
            return Container();
          },
        ),
      ],
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
          color: isSelected ? const Color(0xFFF5C660) : Colors.white,
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
              ? const TextStyle(fontSize: 24, color: Colors.white)
              : const TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
