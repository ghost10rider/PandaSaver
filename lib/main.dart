import 'dart:core';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pandasaver/functions/admobService.dart';
import 'package:pandasaver/functions/checkConnection.dart';
import 'package:pandasaver/functions/recieveSharingIntent.dart';
import 'package:pandasaver/screens/navigation.dart';
import 'package:pandasaver/shared/consts.dart';
import 'package:pandasaver/shared/scrollBehavior.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FlutterDownloader.initialize(debug: true);
  HttpOverrides.global = MyHttpOverrides();
  AdmobService.Initialize();
  checkConnection();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: bgColor, systemNavigationBarColor: bgColor));
  runApp(const MyApp());
}

Locale getDeviceLocale() {
  if (Platform.localeName.contains('ar')) {
    return const Locale('ar');
  } else {
    return const Locale('en');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

bool isEnglish = _locale == const Locale('en');
Locale _locale = getDeviceLocale();

class _MyAppState extends State<MyApp> {
  void setLocale(Locale value) {
    setState(() {
      _locale = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: _locale,
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: NoGlowBehavior(),
          child: child!,
        );
      },
      theme: ThemeData(primarySwatch: MaterialColor(0xffeb4b8a, color)),
      home: const Navigation(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
