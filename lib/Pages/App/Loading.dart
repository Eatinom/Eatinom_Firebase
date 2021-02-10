import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class loading_screen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new loadingscreenstate();
  }
}

class loadingscreenstate extends State<loading_screen>{
  @override
  Widget build(BuildContext context) {
    return Container(child: Center(child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
    )));
  }
}