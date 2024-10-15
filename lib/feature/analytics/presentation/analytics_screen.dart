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

  UserAnalytics _getAnalyticsForDate(
      DateTime date, List<UserAnalytics> analyticsData) {
    return analyticsData.firstWhere(
      (data) =>
          data.date ==
          DateFormat('yyyy-MM-dd').format(date),
      orElse: () => UserAnalytics(
          user: User(
              name: '',
              completedTasksToday: [],
              plannedTasksForWeek: {},
              expectedScores: {},
              overdueTasks: {}),
          date:  DateFormat('yyyy-MM-dd').format(date)),
    );
  }

  String getFormattedDate(DateTime date) {
    return DateFormat('d MMMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider(
        create: (context) => AnalyticsBloc()..add(LoadAnalyticsEvent()),
        child: BlocBuilder<AnalyticsBloc, AnalyticsState>(
          builder: (context, state) {
            if (state is AnalyticsLoadedState) {
              Set<String> aspects = {};
              Map<String, double> aspectScores = {};
              Map<String, double> overdueAspectScores = {};
              final selectedAnalytics =
                  _getAnalyticsForDate(selectedDate, state.analytics);
              final completedTasks =
                  selectedAnalytics.user.completedTasksToday;
              final overdueTasks = selectedAnalytics
                      .user
                      .overdueTasks['${selectedDate.weekday}'] ?? []
                      ;
      
              for(final asp in completedTasks){
                aspects.addAll(asp.task.aspectScores.keys);
              }
              for (final task in completedTasks) {
                for (final aspect in task.task.aspectScores.keys) {
                  aspectScores.update(
                    aspect,
                        (existingScore) => existingScore + task.task.aspectScores[aspect]!,
                    ifAbsent: () => task.task.aspectScores[aspect]!,
                  );
                }
              }
      
              for (final task in overdueTasks) {
                for (final aspect in task.task.aspectScores.keys) {
                  overdueAspectScores.update(
                    aspect,
                        (existingScore) => existingScore + task.task.aspectScores[aspect]!,
                    ifAbsent: () => task.task.aspectScores[aspect]!,
                  );
                }
              }
              return Column(
                children: [ Padding(
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
                            getFormattedDate(selectedDate),
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
                      itemCount: aspects.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 32.0, bottom: 80.0),
                          child: Column(
                            children: [
                    
                    
                              Gap(16),
                              Text(aspects.elementAt(index), style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),),
                              Gap(16),
                              Expanded(
                                child: SfCircularChart(
                                  series: <CircularSeries>[
                                    PieSeries<_TaskData, String>(
                                      dataSource: [
                                        _TaskData('Выполнено', aspectScores[aspects.elementAt(index)] ?? 0),
                                        _TaskData('Просрочено', overdueAspectScores[aspects.elementAt(index)] ?? 0),
                                      ],
                                      xValueMapper: (_TaskData data, _) => data.taskType,
                                      yValueMapper: (_TaskData data, _) => data.taskCount,
                                      dataLabelSettings: DataLabelSettings(isVisible: true),
                                    ),
                                  ],
                                ),
                              ),
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
