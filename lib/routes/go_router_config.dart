import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plinko/core/utils/icon_provider.dart';
import 'package:plinko/feature/aspects/models/task.dart';
import 'package:plinko/feature/test/models/psychological_test.dart';
import 'package:plinko/feature/analytics/presentation/analytics_screen.dart';
import 'package:plinko/feature/aspects/presentation/screens/menu_screen.dart';
import 'package:plinko/feature/test/presentation/screens/test_result_screen.dart';
import 'package:plinko/feature/test/presentation/screens/test_screen.dart';
import 'package:plinko/feature/test/presentation/screens/tests_screen.dart';
import 'package:plinko/feature/settings/settings_screen.dart';
import 'package:plinko/feature/aspects/presentation/screens/tasks_screen.dart';
import 'package:plinko/feature/aspects/presentation/screens/tips_screen.dart';
import 'package:plinko/feature/settings/privicy_screen.dart';

import '../feature/splash/presentation/screens/splash_screen.dart';
import 'root_navigation_screen.dart';
import 'route_value.dart' show RouteValue;

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();
final _menuNavigatorKey = GlobalKey<NavigatorState>();
final _tipsNavigatorKey = GlobalKey<NavigatorState>();
final _settingsNavigatorKey = GlobalKey<NavigatorState>();
final _quizNavigatorKey = GlobalKey<NavigatorState>();
final _analyticsNavigatorKey = GlobalKey<NavigatorState>();

GoRouter globalRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: RouteValue.splash.path,
  routes: <RouteBase>[
    StatefulShellRoute.indexedStack(
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state, navigationShell) {
        return slideTransition(
          state: state,
          child: RootNavigationScreen(
            navigationShell: navigationShell,
          ),
        );
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _menuNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              path: RouteValue.menu.path,
              pageBuilder: (context, state) =>
                  slideTransition(state: state, child: const MenuScreen()),
              routes: <RouteBase>[
                GoRoute(
                    parentNavigatorKey: _menuNavigatorKey,
                    path: RouteValue.tasks.path,
                    pageBuilder: (context, state) {
                      final extra = state.extra as Map<String, dynamic>;
                      final tasks = extra['tasks'] as List<Task>;
                      final day = extra['day'] as String?;
                      final isPlaning = day != null;

                      return slideTransition(
                        state: state,
                        child: TasksScreen(
                          tasks: tasks,
                          isPlaning: isPlaning,
                          day: day,
                        ),
                      );
                    }),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _analyticsNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              path: RouteValue.analytics.path,
              pageBuilder: (context, state) =>
                  slideTransition(state: state, child: const AnalyticsScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _tipsNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              path: RouteValue.tips.path,
              pageBuilder: (context, state) =>
                  slideTransition(state: state, child: const TipsScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _settingsNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
                path: RouteValue.settings.path,
                pageBuilder: (context, state) => slideTransition(
                    state: state, child: const SettingsScreen()),
                routes: [
                  GoRoute(
                    parentNavigatorKey: _rootNavigatorKey,
                    path: RouteValue.privicy.path,
                    pageBuilder: (context, state) {
                      return NoTransitionPage(
                        child: PrivicyScreen(
                          key: UniqueKey(),
                        ),
                      );
                    },
                  ),
                ]),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _quizNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
                path: RouteValue.tests.path,
                pageBuilder: (context, state) =>
                    slideTransition(state: state, child: const TestsScreen()),
                routes: [
                  GoRoute(
                    parentNavigatorKey: _quizNavigatorKey,
                    path: RouteValue.test.path,
                    pageBuilder: (context, state) {
                      return slideTransition(
                        state: state,
                        child: TestScreen(
                          key: UniqueKey(),
                        ),
                      );
                    },
                  ),
                  GoRoute(
                    parentNavigatorKey: _quizNavigatorKey,
                    path: RouteValue.testResult.path,
                    pageBuilder: (context, state) {
                      return slideTransition(
                        state: state,
                        child: TestResultScreen(
                          test: state.extra as PsychologicalTest,
                          key: UniqueKey(),
                        ),
                      );
                    },
                  ),
                ]),
          ],
        ),
      ],
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      pageBuilder: (context, state, child) {
        return NoTransitionPage(
          child: CupertinoPageScaffold(
            backgroundColor: Colors.white,
            child: child,
          ),
        );
      },
      routes: <RouteBase>[
        GoRoute(
          path: RouteValue.splash.path,
          builder: (BuildContext context, GoRouterState state) {
            return SplashScreen(key: UniqueKey());
          },
        ),
      ],
    ),
  ],
);

Page slideTransition({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage(
    child: child,
    key: state.pageKey,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final offsetAnimation = Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        ),
      );

      return SlideTransition(
        position: offsetAnimation,
        child: Stack(
          children: [
            child,
          ],
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 1),
  );
}
