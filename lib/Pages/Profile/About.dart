
import 'package:eatinom/Pages/App/AppConfig.dart';
import 'package:flutter/material.dart';

class About extends StatefulWidget {
  About({Key key, this.title}) : super(key: key);
  final String title;

  @override
  AboutPage createState() => new AboutPage();
}

class AboutPage extends State<About> {
  
  @override
  Widget build(BuildContext context) {
    AppConfig.context = context;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text("About",textScaleFactor: 1.0, style: TextStyle(fontFamily: 'Product Sans')),
        backgroundColor: Colors.blueGrey,
        //centerTitle: true,
      ),
      body: Center(
        child: Container(
          height: 200.0,
          child: Column(children: [
            Image.asset('assets/eatinom_logo.png', height: 100.0,width: 200.0),
            Text('Version - '+ AppConfig.version)
          ]),
        )
      ),
    );
  }
}