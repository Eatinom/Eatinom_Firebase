import 'package:eatinom/Pages/App/AppConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class TermsConditions extends StatefulWidget {
  TermsConditions({Key key, this.title}) : super(key: key);
  final String title;

  @override
  TermsConditionsPage createState() => new TermsConditionsPage();
}

class TermsConditionsPage extends State<TermsConditions> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<String> loadAsset(BuildContext context) async {
    return await DefaultAssetBundle.of(context)
        .loadString('assets/termsconnditio.txt');
  }

  @override
  Widget build(BuildContext context) {
    AppConfig.context = context;
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          title: Text("Terms Conditions",
              textScaleFactor: 1.0,
              style: TextStyle(fontFamily: 'Product Sans')),
          backgroundColor: Colors.blueGrey,
          //centerTitle: true,
        ),
        body: FutureBuilder<String>(
            future: loadAsset(context),
            initialData: "Loading text..",
            builder: (BuildContext context, AsyncSnapshot<String> text) {
              return new SingleChildScrollView(
                  padding: new EdgeInsets.all(8.0),
                  child: Text(text.data,
                      textScaleFactor: 1.0,
                      style: TextStyle(fontFamily: 'Product Sans')));
            }));
  }
}
