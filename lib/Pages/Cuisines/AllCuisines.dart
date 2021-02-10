
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatinom/DataNotifier/CuisinesData.dart';
import 'package:eatinom/Pages/App/AppConfig.dart';
import 'package:eatinom/Pages/Cuisines/CuisineRelated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

class AllCuisines extends StatefulWidget {
  AllCuisines({Key key, this.mode}) : super(key: key);
  final String mode;

  @override
  AllCuisines_State createState() => new AllCuisines_State();
}

class AllCuisines_State extends State<AllCuisines> {


  @override
  Widget build(BuildContext context) {
    AppConfig.context = context;

    ScreenUtil.init(context);
    ScreenUtil().allowFontScaling = false;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.blueGrey, //change your color here
        ),
        title: Text('All Cuisines',textScaleFactor: 1.0, style: TextStyle(fontFamily: 'Product Sans', color: Colors.blueGrey)),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ShowBody(),
    );
  }

  Widget ShowBody(){
    switch (widget.mode) {
      case 'instant': return InstantCuisinesList();
      case 'preorder': return PreCuisinesList();
    }
  }

  Widget InstantCuisinesList() {
    try{

      return ValueListenableBuilder(
          valueListenable: CuisinesData.notifier,
          builder: (context, value, child) {
            List<Widget> Cuisines = new List<Widget>();
            if(CuisinesData.instantAvailableCuisines != null && CuisinesData.instantAvailableCuisines.length > 0){

              CuisinesData.instantAvailableCuisines.forEach((dt) {
                Cuisines.add(cuisineCard(dt));
              });

              return SingleChildScrollView(
                padding: EdgeInsets.only(top: 20.0,bottom: 20.0),
                child: Column(children: Cuisines),
              );
            }
            else{
              return SizedBox(width: 0.0,height: 0.0);
            }
          }
      );
    }
    catch(err){
      print(err.toString());
    }
  }

  Widget PreCuisinesList() {
    try{

      return ValueListenableBuilder(
          valueListenable: CuisinesData.notifier,
          builder: (context, value, child) {
            List<Widget> Cuisines = new List<Widget>();
            if(CuisinesData.preAvailableCuisines != null && CuisinesData.preAvailableCuisines.length > 0){

              CuisinesData.preAvailableCuisines.forEach((dt) {
                Cuisines.add(cuisineCard(dt));
              });

              return SingleChildScrollView(
                padding: EdgeInsets.only(top: 20.0,bottom: 20.0),
                child: Column(children: Cuisines),
              );
            }
            else{
              return SizedBox(width: 0.0,height: 0.0);
            }
          }
      );
    }
    catch(err){
      print(err.toString());
    }
  }


  Widget cuisineCard(DocumentSnapshot dt){
    try{
      return InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => CuisineRelated(selectedCuisine: dt['Display_Name'],)));
          },
          child: Container(
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: HexColor('#efefef'),
                  boxShadow: [BoxShadow(
                    color: Colors.black26,
                    blurRadius: 1.0,
                  )]
              ),
              child: ListTile(
                leading: Container(padding: EdgeInsets.all(5.0),child: dt.data().containsKey('ImageStr') ? FittedBox(child: Image.memory(base64Decode(dt['ImageStr'])), fit: BoxFit.fill) : Center(child: Icon(Icons.fastfood_outlined, color: Colors.indigo,))),
                title: Text(dt['Display_Name'],textScaleFactor: 1.0, style: TextStyle(color: Colors.black87,fontSize: 17.0,fontFamily: 'Product Sans', fontWeight: FontWeight.w500)),
                trailing: Icon(Icons.arrow_forward_ios,size: 15.0,color: Colors.blueGrey.shade200,),
              )
          )
      );
    }
    catch(err){
      print(err);
    }
  }


}