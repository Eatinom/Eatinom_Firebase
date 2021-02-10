
import 'package:eatinom/Pages/App/AppConfig.dart';
import 'package:flutter/material.dart';

class FAQ extends StatefulWidget {
  FAQ({Key key, this.title}) : super(key: key);
  final String title;

  @override
  FAQPage createState() => new FAQPage();
}

class FAQPage extends State<FAQ> {

  @override
  Widget build(BuildContext context) {
    AppConfig.context = context;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text("FAQ",textScaleFactor: 1.0, style: TextStyle(fontFamily: 'Product Sans')),
        backgroundColor: Colors.blueGrey,
        //centerTitle: true,
      ),
    );
  }
}