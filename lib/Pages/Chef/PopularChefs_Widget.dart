

import 'dart:collection';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatinom/DataNotifier/ChefData.dart';
import 'package:eatinom/DataNotifier/ChefItemData.dart';
import 'package:eatinom/Pages/App/AppConfig.dart';
import 'package:eatinom/Pages/Chef/Chef.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

class PopularChefs_Widget extends StatefulWidget {

  PopularChefs_Widget({Key key, this.mode}) : super(key: key);
  final String mode;

  @override
  PopularChefs_Widget_State createState() => new PopularChefs_Widget_State();
}

class PopularChefs_Widget_State extends State<PopularChefs_Widget> {


  @override
  Widget build(BuildContext context) {

    ScreenUtil.init(context);
    ScreenUtil().allowFontScaling = false;

    switch (widget.mode) {
      case 'instant': return InstantAvailableChefs();
      case 'preorder': return PreAvailableChefs();
    }
  }


  // ignore: non_constant_identifier_names
  Widget InstantAvailableChefs() {
    try {
      return ValueListenableBuilder(
          valueListenable: ChefData.notifier,
          builder: (context, value, child)
          {
            if(ChefData.topChefs_Instant != null && ChefData.topChefs_Instant.length > 0)
            {
              List<Widget> lst = new List<Widget>();
              for(int i=0;i<ChefData.topChefs_Instant.length;i++){
                print('rating --- '+ChefData.topChefs_Instant[i]['Rating'].toString());
                if(i >= 1){
                  break;
                }else{
                  lst.add(chefCard(ChefData.topChefs_Instant[i]));
                }
              }

              return Container(
                padding: EdgeInsets.only(top: 15.0,bottom: 15.0,left: 0.0,right: 0.0),
                child: Column(children: [
                  Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        padding: EdgeInsets.only(left: 15.0,right: 0.0),
                        child: Text('Popular Chefs',textScaleFactor: 1.0, style: TextStyle(fontSize: 16.0,
                          height: 1.3,
                          color: HexColor('#55A47E'),
                          fontFamily: 'Product Sans',
                          fontWeight: FontWeight.w500))
                  )),
                  Container(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,padding: EdgeInsets.only(right: 140),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: lst,
                        ),
                      )
                  )
                ]),
              );
          }
            else{
              return Container(
                child: new Center(
                  child: new Image.asset("assets/2.png",height: 424),
                  /*Text('Coming Soon...',textScaleFactor: 1.0, style: TextStyle(fontSize: 22.0,
                          height: 1.3,
                          color: HexColor('#55A47E'),
                          fontFamily: 'Product Sans',
                          fontWeight: FontWeight.w500))*/
                ),
              );
            }
          }
      );
  }
  catch (err){
    print(err.toString());
    return SizedBox(width: 0.0, height: 0.0);
  }
}

  Widget PreAvailableChefs() {
    try {
      return ValueListenableBuilder(
          valueListenable: ChefData.notifier,
          builder: (context, value, child)
          {
            if(ChefData.topChefs_Pre != null && ChefData.topChefs_Pre.isNotEmpty)
            {
              List<Widget> lst = new List<Widget>();
              for(int i=0;i<ChefData.topChefs_Pre.length;i++){
                if(i >= 5){
                  break;
                }else{
                  lst.add(chefCard(ChefData.topChefs_Pre[i]));
                }
              }

              if(lst != null && lst.length > 0){
                return Container(
                  padding: EdgeInsets.only(top: 15.0,bottom: 15.0,left: 15.0,right: 0.0),
                  child: Column(children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Popular Chefs',textScaleFactor: 1.0, style: TextStyle(fontSize: 16.0,
                            height: 1.3,
                            color: HexColor('#55A47E'),
                            fontFamily: 'Product Sans',
                            fontWeight: FontWeight.w500))
                    ),
                    Container(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,padding: EdgeInsets.only(right: 140),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: lst,
                          ),
                        )
                    )
                  ]),
                );
              }
              else{
                return SizedBox();
              }

            }
            else{
              return Container(
                child: new Center(
                  child: new Image.asset("assets/2.png",height: 424,),
                  /*Text('Coming Soon...',textScaleFactor: 1.0, style: TextStyle(fontSize: 22.0,
                          height: 1.3,
                          color: HexColor('#55A47E'),
                          fontFamily: 'Product Sans',
                          fontWeight: FontWeight.w500))*/
                ),
              );
            }
          }
      );
    }
    catch (err){
      print(err.toString());
      return SizedBox(width: 0.0, height: 0.0);
    }
  }

Widget chefCard(DocumentSnapshot dt) {
  try {
    return InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              Chef(chef: dt)));
        },
        child: Container(
            width: 190.0,
            padding: EdgeInsets.only(top: 15.0, right: 15.0, bottom: 15.0),
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: HexColor('#efefef'),
                    boxShadow: [BoxShadow(
                      color: Colors.black26,
                      blurRadius: 2.0,
                    )
                    ]
                ),
                child: Row(children: [
                  //Padding(padding: EdgeInsets.only(right: 15.0)),
                  Align(
                   alignment: Alignment.centerRight,
                    child :ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.memory(
                        base64Decode(dt['ImageStr']),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    )
                  ),
                  Container(
                    width: 110.0,
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    //child: Center(
                      child: RichText(
                          overflow: TextOverflow.ellipsis,
                          textScaleFactor: 1.0,
                          text: TextSpan(
                            text: dt['Display_Name'],
                            style: TextStyle(fontSize: 12.9, fontFamily: 'Product Sans',color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(text: '\n'+dt['Style'], style: TextStyle(fontSize: 9.0,color: Colors.blueGrey,fontWeight: FontWeight.w300)),
                            ],
                          )
                      )
                    //)
                  )
                ])
            )
        )
    );
  }
  catch (err) {
    print(err);
  }
}}
