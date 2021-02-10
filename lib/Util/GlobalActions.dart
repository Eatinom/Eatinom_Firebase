import 'dart:math';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wakelock/wakelock.dart';

class GlobalActions {

  static void onReady(){
    /*SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: HexColor('#F9FAF9'), // navigation bar color
      statusBarColor: HexColor('#F9FAF9'),
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness:Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));*/
    Wakelock.enable();
  }



  static void showToast_Error(String title , String message , BuildContext context){
    Flushbar(
      duration: Duration(seconds: 2),
      titleText: Text(title, textScaleFactor: 1.0, style: TextStyle(color: Colors.black87, fontSize: 18.0, fontFamily: 'Product Sans', fontWeight: FontWeight.w600)),
      messageText: Text(message, textScaleFactor: 1.0, style: TextStyle(color: Colors.black45, fontSize: 14.0, fontFamily: 'Product Sans', fontWeight: FontWeight.w400)),
      backgroundColor: Colors.red,
      boxShadows: [BoxShadow(color: Colors.red[800], offset: Offset(0.0, 2.0), blurRadius: 3.0,)],
    )..show(context);
  }

  static void showToast_Sucess(String title , String message , BuildContext context){
    Flushbar(
      titleText: Text(title, textScaleFactor: 1.0, style: TextStyle(color: Colors.black87, fontSize: 18.0, fontFamily: 'Product Sans', fontWeight: FontWeight.w600)),
      messageText: Text(message, textScaleFactor: 1.0, style: TextStyle(color: Colors.black45, fontSize: 14.0, fontFamily: 'Product Sans', fontWeight: FontWeight.w400)),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.green.shade300,
      boxShadows: [BoxShadow(color: Colors.black26, offset: Offset(0.0, 2.0), blurRadius: 3.0,)],
    )..show(context);
  }

  static void showToast_Notification(String title , String message , BuildContext context){
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      duration: Duration(seconds: 2),
      backgroundColor: Colors.blueGrey.shade50,
      titleText: Text(title, textScaleFactor: 1.0, style: TextStyle(color: Colors.black87, fontSize: 18.0, fontFamily: 'Product Sans', fontWeight: FontWeight.w600)),
      messageText: Text(message, textScaleFactor: 1.0, style: TextStyle(color: Colors.black45, fontSize: 14.0, fontFamily: 'Product Sans', fontWeight: FontWeight.w400)),
    )..show(context);
  }

  static double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }
}