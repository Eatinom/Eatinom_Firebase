import 'dart:async';
import 'package:eatinom/Pages/MyApp.dart';
import 'package:eatinom/Pages/test.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


void main() {
  runZoned(() {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    runApp(MyApp());
  }, onError: (dynamic error, dynamic stack) {
    print(error);
    print(stack);
    FirebaseCrashlytics.instance.recordFlutterError(error);

  });
}





