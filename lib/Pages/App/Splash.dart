import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class Splash extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new Splash_State();
  }
}

class Splash_State extends State<Splash>{

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white54)))
    );
  }
}