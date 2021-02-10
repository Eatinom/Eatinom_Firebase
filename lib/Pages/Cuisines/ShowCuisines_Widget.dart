

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatinom/DataNotifier/CuisinesData.dart';
import 'package:eatinom/Pages/Cuisines/AllCuisines.dart';
import 'package:eatinom/Pages/Cuisines/CuisineRelated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:responsive_grid/responsive_grid.dart';

class ShowCuisines_Widget extends StatefulWidget {
  ShowCuisines_Widget({Key key, this.mode}) : super(key: key);
  final String mode;

  @override
  ShowCuisines_Widget_State createState() => new ShowCuisines_Widget_State();
}

class ShowCuisines_Widget_State extends State<ShowCuisines_Widget> {


  @override
  Widget build(BuildContext context) {

    ScreenUtil.init(context);
    ScreenUtil().allowFontScaling = false;

    switch (widget.mode) {
      case 'instant': return InstantCuisines();
      case 'preorder': return PreCuisines();
    }
  }



  Widget InstantCuisines() {
    try{

      return ValueListenableBuilder(
          valueListenable: CuisinesData.notifier,
          builder: (context, value, child) {
            List<DocumentSnapshot> limitedCuisines = new List<DocumentSnapshot>();
            if(CuisinesData.instantAvailableCuisines != null && CuisinesData.instantAvailableCuisines.length > 0){
              int count = 1;
              for(int i=0;i<CuisinesData.instantAvailableCuisines.length;i++){
                if(count > 9){
                  break;
                }
                DocumentSnapshot dt = CuisinesData.instantAvailableCuisines[i];
                limitedCuisines.add(dt);
                count++;
              }



              return Container(
                  child: Column(
                      children: [
                        Align(alignment: Alignment.centerLeft,
                            child: Container(
                                padding: EdgeInsets.only(top:7.0,bottom: 8.0,left: 15.0,right: 15.0),
                                color: Colors.blueGrey.withOpacity(0.1),
                                width: double.infinity,
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                                  Text('Different Cuisines',textScaleFactor: 1.0, style: TextStyle(fontSize: 16.0,height: 1.3,color: HexColor('#55A47E'),fontFamily: 'Product Sans',fontWeight: FontWeight.w500)),
                                  InkWell(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => AllCuisines(mode: 'instant')));
                                      },
                                      child: Container(child: Text('View All',textScaleFactor: 1.0, style: TextStyle(color: Colors.blueGrey)))
                                  )
                                ])


                            )),
                        Container(
                            padding: EdgeInsets.only(top: 15.0,bottom: 10.0),
                            child: ResponsiveGridList(
                              desiredItemWidth: 60,
                              scroll: false,
                              minSpacing: 11,
                              children: limitedCuisines.map((DocumentSnapshot document) {
                                return cuisineCard(document);
                              }).toList(),
                            )
                        )
                      ])
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

  Widget PreCuisines() {
    try{
      return ValueListenableBuilder(
          valueListenable: CuisinesData.notifier,
          builder: (context, value, child) {
            if(CuisinesData.preAvailableCuisines != null && CuisinesData.preAvailableCuisines.length > 0){

              List<DocumentSnapshot> limitedCuisines = new List<DocumentSnapshot>();
              int count = 1;
              for(int i=0;i<CuisinesData.preAvailableCuisines.length;i++){
                if(count > 9){
                  break;
                }
                DocumentSnapshot dt = CuisinesData.preAvailableCuisines[i];
                limitedCuisines.add(dt);
                count++;
              }


              return Container(
                  child: Column(
                      children: [
                        Align(alignment: Alignment.centerLeft,
                            child: Container(
                                padding: EdgeInsets.only(top:10.0,bottom: 10.0,left: 15.0,right: 15.0),
                                color: Colors.blueGrey.withOpacity(0.1),
                                width: double.infinity,
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                                  Text('Different Cuisines',textScaleFactor: 1.0, style: TextStyle(fontSize: 17.0,height: 1.3,color: HexColor('#55A47E'),fontFamily: 'Product Sans',fontWeight: FontWeight.w500)),
                                  InkWell(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => AllCuisines(mode: 'preorder')));
                                      },
                                      child: Container(child: Text('View All',textScaleFactor: 1.0, style: TextStyle(color: Colors.blueGrey)))
                                  )
                                ])


                            )),
                        Container(
                            padding: EdgeInsets.only(top: 15.0,bottom: 10.0),
                            child: ResponsiveGridList(
                              desiredItemWidth: 60,
                              scroll: false,
                              minSpacing: 11,
                              children: limitedCuisines.map((DocumentSnapshot document) {
                                return cuisineCard(document);
                              }).toList(),
                            )
                        )
                      ])
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
            child: Column(children: [
              Container(
                width: 55.0,
                height: 55.0,
                padding: EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: HexColor('#efefef'),
                    boxShadow: [BoxShadow(
                      color: Colors.black26,
                      blurRadius: 2.0,
                    )]
                ),
                child: dt.data().containsKey('ImageStr') ? FittedBox(child: Image.memory(base64Decode(dt['ImageStr'])), fit: BoxFit.fill) : Center(child: Icon(Icons.fastfood_outlined, color: Colors.indigo,))
              ),
              Container(
                padding: EdgeInsets.only(top:10.0,bottom: 10.0),
                child: Center(child: Text(dt['Display_Name'],textScaleFactor: 1.0, style: TextStyle(fontFamily: 'Product Sans',color: Colors.blueGrey, fontSize: 13.0)))
              )
            ])
          )
      );
    }
    catch(err){
      print(err);
    }
  }







}
