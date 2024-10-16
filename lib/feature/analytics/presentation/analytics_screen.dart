import 'package:bubblebalance/core/dependency_injection.dart';
import 'package:bubblebalance/core/utils/log.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:bubblebalance/feature/analytics/bloc/analytics_bloc.dart';
import 'package:bubblebalance/feature/analytics/models/user_analytics.dart';
import 'package:bubblebalance/feature/aspects/models/user.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});
  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  DateTime selectedDate = DateTime.now();

  int pageIndex = 0;
  final PageController _pageController = PageController();

  UserAnalytics _getAnalyticsForDate(
      DateTime date, List<UserAnalytics> analyticsData) {
    return analyticsData.firstWhere(
      (data) => data.date == getFormattedDate(date),
      orElse: () => UserAnalytics(
          user: User(
              name: '',
              completedTasksWeek: {},
              plannedTasksForWeek: {},
              expectedScores: {},
              overdueTasks: {}),
          date: getFormattedDate(date)),
    );
  }

  String getFormattedDate(DateTime date) {
    String monthName =
        DateFormat('MMMM').format(date); // Получение названия месяца
    DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);

    // Узнаем день недели для первого дня месяца
    int firstWeekday = firstDayOfMonth.weekday;

    // Считаем, сколько дней с начала недели до текущей даты
    int daysOffset = date.day + firstWeekday - 1;

    // Считаем номер недели

    int monthWeek = (daysOffset / 7).ceil();
    logger.d(monthWeek);
    return '$monthName $monthWeek';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider(
        create: (context) =>
            locator<AnalyticsBloc>()..add(LoadAnalyticsEvent()),
        child: BlocBuilder<AnalyticsBloc, AnalyticsState>(
          builder: (context, state) {
            if (state is AnalyticsLoadedState) {
              final Set<String> aspects = {};
              final Map<String, double> aspectScores = {};
              final Map<String, double> waitingScore = {};

              final selectedAnalytics =
                  _getAnalyticsForDate(selectedDate, state.analytics);
              final completedTasks = selectedAnalytics.user
                      .completedTasksWeek[selectedDate.weekday.toString()] ??
                  [];
              logger.d(selectedAnalytics);
              logger.d(completedTasks);

              for (final asp in completedTasks) {
                aspects.addAll(asp.task.aspectScores.keys);
              }

              for (final task in completedTasks) {
                for (final aspect in task.task.aspectScores.keys) {
                  aspectScores.update(
                    aspect,
                    (existingScore) =>
                        existingScore + task.task.aspectScores[aspect]!,
                    ifAbsent: () => task.task.aspectScores[aspect]!,
                  );
                }
              }

              for (final asp in state.aspects) {
                if (aspectScores.containsKey(asp.name)) {
                  waitingScore[asp.name] = asp.optimalScore;
                }
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: CupertinoButton(
                      onPressed: () {
                        showCupertinoModalPopup(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: 250,
                              color: CupertinoColors.systemBackground
                                  .resolveFrom(context),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      CupertinoButton(
                                        child: const Text('Done'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 197,
                                    child: CupertinoDatePicker(
                                      initialDateTime: selectedDate,
                                      mode: CupertinoDatePickerMode.date,
                                      onDateTimeChanged: (DateTime date) {
                                        setState(() {
                                          selectedDate = date;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      color: Color(0xFFEFEFEF),
                      padding: EdgeInsets.zero,
                      borderRadius: BorderRadius.circular(15),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              DateFormat('yyyy-MM-dd').format(selectedDate),
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
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          pageIndex = index;
                        });
                      },
                      itemCount: aspects.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding:
                              const EdgeInsets.only(top: 32.0, bottom: 130),
                          child: Column(
                            children: [
                              Gap(16),
                              Text(
                                aspects.elementAt(index),
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w500),
                              ),
                              Gap(16),
                              Expanded(
                                child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: SfCircularChart(
                                          legend: Legend(
                                            isVisible: true,
                                            position: LegendPosition.bottom,
                                          ),
                                          series: <CircularSeries>[
                                            PieSeries<_TaskData, String>(
                                              dataSource: [
                                                _TaskData(
                                                  'Completed',
                                                  aspectScores[aspects
                                                          .elementAt(index)] ??
                                                      0,
                                                ),
                                                _TaskData(
                                                  'To optimal',
                                                  waitingScore[
                                                              aspects.elementAt(
                                                                  index)] !=
                                                          null
                                                      ? waitingScore[
                                                              aspects.elementAt(
                                                                  index)]! -
                                                          (aspectScores[aspects
                                                                  .elementAt(
                                                                      index)] ??
                                                              0)
                                                      : 0,
                                                ),
                                              ],
                                              xValueMapper:
                                                  (_TaskData data, _) =>
                                                      data.taskType,
                                              yValueMapper:
                                                  (_TaskData data, _) =>
                                                      data.taskCount,
                                              dataLabelSettings:
                                                  DataLabelSettings(
                                                      isVisible: true),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (pageIndex > 0)
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: IconButton(
                                            onPressed: () => setState(() {
                                              logger.d(pageIndex);
                                              pageIndex--;

                                              _pageController
                                                  .jumpToPage(pageIndex);
                                            }),
                                            icon: const Icon(
                                              CupertinoIcons.left_chevron,
                                              color: Color(0xFFB5B5B5),
                                            ),
                                            iconSize: 55,
                                          ),
                                        ),
                                      if (aspects.length > pageIndex + 1)
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: IconButton(
                                            onPressed: () => setState(() {
                                              logger.d(pageIndex);
                                              pageIndex++;

                                              _pageController
                                                  .jumpToPage(pageIndex);
                                            }),
                                            icon: const Icon(
                                              CupertinoIcons.right_chevron,
                                              color: Color(0xFFB5B5B5),
                                            ),
                                            iconSize: 55,
                                          ),
                                        ),
                                    ]),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            } else if (state is AnalyticsErrorState) {
              return const Center(
                child: Text(
                  'No data found',
                  style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontFamily: 'Mon',
                  ),
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}

class _TaskData {
  final String taskType;
  final double taskCount;

  _TaskData(this.taskType, this.taskCount);
}
