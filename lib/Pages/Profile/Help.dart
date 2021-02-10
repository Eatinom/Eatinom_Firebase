
import 'package:eatinom/Pages/App/AppConfig.dart';
import 'package:flutter/material.dart';

class Help extends StatefulWidget {
  Help({Key key, this.title}) : super(key: key);
  final String title;

  @override
  HelpPage createState() => new HelpPage();
}

class HelpPage extends State<Help> {

  @override
  Widget build(BuildContext context) {
    AppConfig.context = context;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text("Help",textScaleFactor: 1.0, style: TextStyle(fontFamily: 'Product Sans')),
        backgroundColor: Colors.blueGrey,
       // centerTitle: true,
      ),
    );
  }
}