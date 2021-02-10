

import 'package:flutter/material.dart';

class test extends StatefulWidget {
  test({Key key, this.title}) : super(key: key);
  final String title;

  @override
  testPage createState() => new testPage();
}

class testPage extends State<test>{

  static final _formKey = new GlobalKey<FormState>();
  Key _k1 = new GlobalKey();
  TextEditingController ctrlFirstName = new TextEditingController();
  Key _k2 = new GlobalKey();
  TextEditingController ctrlFirstName2 = new TextEditingController();


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Container(
              color: Colors.green,
              child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(children: [
                      inputBox('', '', '', ctrlFirstName , _k1),
                      inputBox('', '', '', ctrlFirstName2 , _k2),
                    ])
                  )
    ))));
  }



  Widget inputBox(String label , String value , String hint, TextEditingController ctrl , Key ky){
    ctrl.text = value;
    return Container(
      padding: EdgeInsets.only(top: 5.0,bottom: .0, left: 20.0, right: 20.0),
      child: TextFormField(
        key: ky,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          labelText: label,
          errorText: '',
          hintText: hint,
          filled: true,
          fillColor: Colors.black.withOpacity(0.02),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            borderSide: BorderSide(width: 1,color: Colors.blueGrey.shade100),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            borderSide: BorderSide(width: 1,color: Colors.blueGrey.shade100),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            borderSide: BorderSide(width: 1,color: Colors.blueGrey.shade100),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(width: 1,)
          ),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(width: 1,color: Colors.blueGrey.shade100)
          ),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(width: 1,color: Colors.blueGrey.shade100)
          ),
        ),
        controller: ctrl,
      ),
    );
  }


}