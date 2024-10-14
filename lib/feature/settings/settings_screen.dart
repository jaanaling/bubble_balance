import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:plinko/core/utils/init_data.dart';
import 'package:plinko/feature/test/bloc/test_bloc.dart';
import 'package:plinko/main.dart';
import 'package:plinko/routes/route_value.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  late SharedPreferences prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadNotificationsState();
    });
  }

  Future<void> loadNotificationsState() async {
    prefs = await SharedPreferences.getInstance();
    notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 125),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              title: Text(
                'Notifications',
                style: TextStyle(fontSize: 24),
              ),
              trailing: Container(
                width: 50,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(80)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      offset: Offset(2, 3),
                    ),
                  ],
                ),
                child: CupertinoSwitch(
                  activeColor: Colors.white,
                  trackColor: Colors.white,
                  thumbColor: notificationsEnabled ? Colors.green : Colors.red,
                  value: notificationsEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      notificationsEnabled = value;
                    });
                    if (notificationsEnabled) {
                   //   scheduleDailyReset();
                      prefs.setBool('notificationsEnabled', true);
                    } else {
                      cancelNotifications();
                      prefs.setBool('notificationsEnabled', false);
                    }
                  },
                ),
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    content: Text('Are you sure you want to clear the data?'),
                    actions: [
                      CupertinoDialogAction(
                          child: Text("Yes"),
                          onPressed: () {
                            prefs.clear();
                            loadInitialData();
                            context.read<TestBloc>().add(LoadTestsEvent());
                            Navigator.pop(context);
                          }),
                      CupertinoDialogAction(
                        child: Text("No", style: TextStyle(color: Colors.red)),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                );
              }, // Очистка данных
              child: Text('Clear Data'),
            ),
            CupertinoButton(
                child: Text("Pravicy policy"),
                onPressed: () => context.push(
                    '${RouteValue.settings.path}/${RouteValue.privicy.path}'))
          ],
        ),
      ),
    );
  }
}
