import 'package:eatinom/Pages/App/AppConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class PrivacyPolicy extends StatefulWidget {
  PrivacyPolicy({Key key, this.title}) : super(key: key);
  final String title;

  @override
  PrivacyPolicyPage createState() => new PrivacyPolicyPage();
}

class PrivacyPolicyPage extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    AppConfig.context = context;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text("Privacy Policy",
            textScaleFactor: 1.0, style: TextStyle(fontFamily: 'Product Sans')),
        backgroundColor: Colors.blueGrey,
        //centerTitle: true,
      ),
      body: WebviewScaffold(
        hidden: true,
        //initialChild: Text("loading"),
        url: "https://www.eatinom.com/privacy-policy/",
      ),
    );
  }
}
