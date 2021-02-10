

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatinom/DataNotifier/ChefItemData.dart';
import 'package:eatinom/Pages/Item/Item.dart';
import 'package:eatinom/Pages/TodaysSpecial/TodaysSpecial.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

class TodaySpecial_Widget extends StatefulWidget {

  TodaySpecial_Widget({Key key, this.mode}) : super(key: key);
  final String mode;

  @override
  TodaySpecial_Widget_State createState() => new TodaySpecial_Widget_State();
}

class TodaySpecial_Widget_State extends State<TodaySpecial_Widget> {


  @override
  Widget build(BuildContext context) {

    ScreenUtil.init(context);
    ScreenUtil().allowFontScaling = false;

    switch (widget.mode) {
      case 'instant': return InstantTodaysSpecial();
      case 'preorder': return PreTodaysSpecial();
    }
  }



  Widget InstantTodaysSpecial() {
    try{

      return ValueListenableBuilder(
          valueListenable: ChefItemData.notifier,
          builder: (context, value, child) {
            if(ChefItemData.availableChefsItems_Instant != null && ChefItemData.availableChefsItems_Instant.length > 0){

              List<DocumentSnapshot> limitedItems = new List<DocumentSnapshot>();
              int count = 1;
              for(int i=0;i<ChefItemData.availableChefsItems_Instant.length;i++){
                if(count > 10){
                  break;
                }
                DocumentSnapshot dt = ChefItemData.availableChefsItems_Instant[i];
                if(dt.data().containsKey('Todays_Special')){
                  if(dt['Order_Type'] == 'Instant' && dt['Todays_Special'] == true){
                    limitedItems.add(dt);
                    count++;
                  }
                }
              }

              return Container(
                padding: EdgeInsets.only(bottom:10.0),
                child: Column(
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                              padding: EdgeInsets.only(top: 7.0,bottom: 7.0,left: 15.0,right: 15.0),
                              color: Colors.blueGrey.withOpacity(0.1),
                              width: double.infinity,
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                                Text("Today\'s Special",textScaleFactor: 1.0, style: TextStyle(fontSize: 17.0, height: 1.3, color: HexColor('#55A47E'), fontFamily: 'Product Sans', fontWeight: FontWeight.w500)),
                                InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => TodaySpecial(mode: 'instant')));
                                    },
                                    child: Container(child: Text('View All',textScaleFactor: 1.0, style: TextStyle(color: Colors.blueGrey)))
                                )
                              ])
                          )
                      ),
                      Container(
                          padding: EdgeInsets.all(20.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: limitedItems.map((DocumentSnapshot document) {
                                return specialCard(document);
                              }).toList(),
                            ),
                          )
                      )
                    ]),
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

  Widget PreTodaysSpecial() {
    try{

      return ValueListenableBuilder(
          valueListenable: ChefItemData.notifier,
          builder: (context, value, child) {
            if(ChefItemData.availableChefsItems_Pre != null && ChefItemData.availableChefsItems_Pre.length > 0){

              List<DocumentSnapshot> limitedItems = new List<DocumentSnapshot>();
              int count = 1;
              for(int i=0;i<ChefItemData.availableChefsItems_Pre.length;i++){
                if(count > 10){
                  break;
                }
                DocumentSnapshot dt = ChefItemData.availableChefsItems_Pre[i];
                if(dt.data().containsKey('Todays_Special')){
                  if(dt['Order_Type'] == 'Pre' && dt['Todays_Special'] == true){
                    limitedItems.add(dt);
                    count++;
                  }
                }
              }

              return limitedItems.length > 0 ? Container(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Column(
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                              padding: EdgeInsets.only(top: 7.0,bottom: 8.0,left: 15.0,right: 15.0),
                              color: Colors.blueGrey.withOpacity(0.1),
                              width: double.infinity,
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                                Text("Todays Special",textScaleFactor: 1.0, style: TextStyle(fontSize: 17.0, height: 1.3, color: HexColor('#55A47E'), fontFamily: 'Product Sans', fontWeight: FontWeight.w500)),
                                InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => TodaySpecial(mode: 'preorder')));
                                    },
                                    child: Container(child: Text('View All',textScaleFactor: 1.0, style: TextStyle(color: Colors.blueGrey)))
                                )
                              ])
                          )
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: SingleChildScrollView(
                            padding: EdgeInsets.only(left: 20.0),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: limitedItems.map((DocumentSnapshot document) {
                                return specialCard(document);
                              }).toList(),
                            ),
                          )
                      )
                    ]),
              ) : SizedBox();
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

  Widget specialCard(DocumentSnapshot dt){
    try{
      return InkWell(
        onTap: (){
          ShowItemDetail(dt);
        },
        child: Container(
            width: 150.0,
            height: 190.0,
            padding: EdgeInsets.only(top: 15.0,right: 15.0,bottom: 15.0,left: 10.0),
            child: Stack(children: [
              Align(alignment: Alignment.bottomCenter,child: Container(
                  width: 130.0,
                  height: 120.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [BoxShadow(
                        color: Colors.black26,
                        blurRadius: 2.0,
                      )]
                  ),
                  child: Stack(children: [
                    Align(alignment: Alignment.bottomCenter,child: Container(
                        padding: EdgeInsets.only(bottom: 50.0,top: 10.0,right: 10.0,left: 10.0),
                        child: Text(dt['Name'],textScaleFactor: 1.0, textAlign: TextAlign.center,style: TextStyle(fontFamily: 'Product Sans',fontSize: 12.0))
                    )),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                            padding: EdgeInsets.only(bottom: 30.0,top: 10.0,right: 10.0, left: 10.0),
                            child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                              Padding(padding: EdgeInsets.only(right: 2.0),child: Icon(Icons.timer, size: 10.0)),
                              Text(dt['Preparation_Time_Display'],textScaleFactor: 1.0, textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,style: TextStyle(fontFamily: 'Product Sans',fontSize: 12.0,color: Colors.black54))
                            ])

                        )
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                            padding: EdgeInsets.all(10.0),
                            child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                              Padding(padding: EdgeInsets.only(right: 2.0),child: Icon(Icons.person, size: 15.0,color: Colors.orange,)),
                              Text(dt['Chef_Name'],textScaleFactor: 1.0, textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,style: TextStyle(fontFamily: 'Product Sans',fontSize: 12.0,color: Colors.deepOrangeAccent.shade200))
                            ])
                        )
                    ),
                  ])
              )),

              Align(
                  alignment: Alignment.topCenter,
                child : ClipOval(
                  child: Image.memory(
                    base64Decode(dt['ImageStr']),
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),

              ),


         /*     Align(alignment: Alignment.topCenter,child: Container(
                  width: 75.0,
                  height: 75.0,
                  padding: EdgeInsets.all(0.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: HexColor('#efefef'),
                  ),
                  child: FittedBox(child: dt.data().containsKey('ImageStr') ? Image.memory(base64Decode(dt['ImageStr']), fit: BoxFit.fill) : Icon(Icons.add), fit: BoxFit.fill)
              )
              ),*/
            ])
        ),
      );

    }
    catch(err){
      print(err);
    }
  }


  Widget ShowItemDetail(DocumentSnapshot itm){
    try{
      showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(50.0), topRight: Radius.circular(50.0)),
        ),
        isScrollControlled: true,
        isDismissible: true,
        backgroundColor: Colors.white.withOpacity(0.0),
        context: context,
        builder: (context) => Container(height: MediaQuery.of(context).size.height * 0.90,child: Item(item: itm)),
      );
    }
    catch(err){
      print(err.toString());
      return SizedBox();
    }
  }
}
