
import 'package:eatinom/Pages/App/AppConfig.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  Notifications({Key key, this.title}) : super(key: key);
  final String title;

  @override
  NotificationsPage createState() => new NotificationsPage();
}

class NotificationsPage extends State<Notifications> {

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    AppConfig.context = context;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.blueGrey, //change your color here
        ),
        title: Text("Notifications",textScaleFactor: 1.0, style: TextStyle(fontFamily: 'Product Sans', color: Colors.blueGrey)),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
    );
  }
}