import 'package:calendar_every/home_view.dart';
import 'package:calendar_every/provider/account_provider.dart';
import 'package:calendar_every/provider/article_provider.dart';
import 'package:calendar_every/provider/chart_provider.dart';
import 'package:calendar_every/provider/home_provider.dart';
import 'package:calendar_every/provider/register_provider.dart';
import 'package:calendar_every/provider/show_calendar_provider.dart';
import 'package:calendar_every/provider/write_today_work_provider.dart';
import 'package:calendar_every/register_view.dart';
import 'package:calendar_every/user_service.dart';
import 'package:calendar_every/write_today_work_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await UserService.instance.initUser();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => HomeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => WriteTodayWorkProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ShowCalendarProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChartProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => RegisterProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AccountProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ArticleProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeView(),
      routes: [
        GoRoute(
          path: 'register',
          builder: (context, state) => const RegisterView(),
        ),
        GoRoute(
          path: 'writeToday',
          builder: (context, state) => const WriteTodayWorkView(),
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationProvider: _router.routeInformationProvider,
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
      title: 'Flutter Demo',
      theme: ThemeData(
          splashColor: Colors.white,
          splashFactory: NoSplash.splashFactory,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          scaffoldBackgroundColor: Colors.white,
          //fontFamily: 'Agro',
          useMaterial3: true,
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius:
              BorderRadius.all(Radius.circular(12.0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide:
              BorderSide(color: Colors.black, width: 1.0),
              borderRadius:
              BorderRadius.all(Radius.circular(12.0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
              BorderSide(color: Colors.black, width: 2.0),
              borderRadius:
              BorderRadius.all(Radius.circular(12.0)),
            ),
          ),
          bottomSheetTheme: const BottomSheetThemeData(
            elevation: 0,
            backgroundColor: Colors.white,
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
              elevation: 1,
              backgroundColor: Colors.white,
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.blue.withOpacity(0.3),
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: true)),
    );
  }
}
