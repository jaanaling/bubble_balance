import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:plinko/feature/aspects/bloc/aspect_bloc.dart';
import 'package:plinko/feature/test/bloc/test_bloc.dart';

import '../../../routes/go_router_config.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LifeAspectBloc()..add(LoadAspects()),
        ),
        BlocProvider(
          create: (context) => TestBloc()..add(LoadTestsEvent()),
        ),
      ],
      child: CupertinoApp.router(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: const CupertinoThemeData(
          textTheme: CupertinoTextThemeData(
              textStyle: TextStyle(
            fontFamily: "Mon",
            fontWeight: FontWeight.w500,
          )),
        ),
        routerConfig: globalRouter,
        color: Colors.white,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
