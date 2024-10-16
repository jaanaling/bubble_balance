import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:bubblebalance/core/utils/init_data.dart';
import 'package:bubblebalance/feature/aspects/bloc/aspect_bloc.dart';
import 'package:bubblebalance/feature/test/bloc/test_bloc.dart';
import 'package:bubblebalance/main.dart';
import 'package:bubblebalance/routes/route_value.dart';
import 'package:bubblebalance/ui_kit/base_container/base_container.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart';
import 'package:url_launcher/url_launcher.dart';

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
        padding: const EdgeInsets.only(bottom: 125, top: 70),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 36),
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
                onChanged: (bool value) async {
                  if (notificationsEnabled) {
                    FirebaseMessaging instance = FirebaseMessaging.instance;

                    final settings = await instance.requestPermission(
                        alert: true, badge: true, sound: true);
                    if (settings.authorizationStatus ==
                        AuthorizationStatus.authorized) {
                      final prefs = await SharedPreferences.getInstance();

                      await prefs.setBool(
                          'notificationsEnabled', notificationsEnabled);
                      setState(() {
                        notificationsEnabled = value;
                      });
                    } else {
                      showNotificationPermissionDialog(context);
                    }
                  } else {
                    setState(() {
                      notificationsEnabled = value;
                    });
                    final prefs = await SharedPreferences.getInstance();

                    await prefs.setBool(
                        'notificationsEnabled', notificationsEnabled);
                  }
                },
              ),
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: () => showCupertinoDialog(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                content: Text('Are you sure you want to clear the data?'),
                actions: [
                  CupertinoDialogAction(
                      child: Text("Yes"),
                      onPressed: () async {
                        prefs.clear();
                       await loadInitialData();
                        context.read<TestBloc>().add(LoadTestsEvent());
                        context.read<LifeAspectBloc>().add(LoadAspects());

                        Navigator.pop(context);
                      }),
                  CupertinoDialogAction(
                    child: Text("No", style: TextStyle(color: Colors.red)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 56),
              child: BaseContainer(
                text: Text(
                  'Clear Data',
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
          Gap(18),
          CupertinoButton(
            onPressed: () => context
                .push('${RouteValue.settings.path}/${RouteValue.privicy.path}'),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 56),
              child: Text(
                'Pravicy policy',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: CupertinoColors.activeBlue,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

void showNotificationPermissionDialog(BuildContext context) {
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text('Enable Notifications'),
        content:
            Text('Please enable notifications in the settings to continue.'),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            child: Text('Open Settings'),
            onPressed: () async {
              const url = 'app-settings:';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                print('Could not open settings.');
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
