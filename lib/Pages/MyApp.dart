
import 'package:eatinom/Pages/App/AppStart.dart';
import 'package:eatinom/Pages/App/OnBoarding.dart';
import 'package:eatinom/Pages/Error/AppError.dart';
import 'package:eatinom/Pages/Error/NoInternet.dart';
import 'package:eatinom/Pages/Error/NoLocation.dart';
import 'package:eatinom/Pages/Home/Home.dart';
import 'package:eatinom/Pages/Index/Index.dart';
import 'package:eatinom/Pages/Login/Login.dart';
import 'package:eatinom/Pages/Cart/Cart.dart';
import 'package:eatinom/Pages/Orders/OrderSuccess.dart';
import 'package:eatinom/Pages/test.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';




var routes = <String, WidgetBuilder>{
  "/myapp": (BuildContext context) => MyApp(),
  "/apperror": (BuildContext context) => AppError(),
  "/onboarding": (BuildContext context) => OnBoarding(),
  "/index": (BuildContext context) => Index(),
  "/nointernet": (BuildContext context) => NoInternet(),
  "/nolocation": (BuildContext context) => NoLocation(),
  "/home": (BuildContext context) => Home(),
  "/login": (BuildContext context) => Login(),
  "/cart": (BuildContext context) => Cart(),
  "/ordersuccess": (BuildContext context) => OrderSuccess(),
};

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black, // navigation bar color
      statusBarColor: Colors.black,
    ));

    FlutterError.onError = (details){
      FirebaseCrashlytics.instance.recordFlutterError(details);
    };
    FocusScope.of(context).requestFocus(new FocusNode());

    return MaterialApp(
      title: 'Eatinom',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Product Sans',
        appBarTheme: AppBarTheme(color: Colors.blueGrey),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.black.withOpacity(0.2)
        )
      ),
      home:
      AppStart(),
      routes: routes,
    );
  }
}