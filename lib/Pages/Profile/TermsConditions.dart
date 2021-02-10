
import 'package:eatinom/Pages/App/AppConfig.dart';
import 'package:flutter/material.dart';

class TermsConditions extends StatefulWidget {
  TermsConditions({Key key, this.title}) : super(key: key);
  final String title;

  @override
  TermsConditionsPage createState() => new TermsConditionsPage();
}

class TermsConditionsPage extends State<TermsConditions> {

  @override
  Widget build(BuildContext context) {
    AppConfig.context = context;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text("TermsConditions",textScaleFactor: 1.0, style: TextStyle(fontFamily: 'Product Sans')),
        backgroundColor: Colors.blueGrey,
        //centerTitle: true,
      ),
    );
  }
}