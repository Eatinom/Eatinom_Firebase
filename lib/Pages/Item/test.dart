

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatinom/DataNotifier/ChefItemData.dart';
import 'package:eatinom/Pages/Item/AvailableItems.dart';
import 'package:eatinom/Pages/Item/ItemCard.dart';
import 'package:eatinom/Pages/PinLocation/PinLocation2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

class Test extends StatefulWidget {
  Test({Key key, this.mode}) : super(key: key);
  final String mode;


  @override
  AvailableItems_WidgetPage createState() => new AvailableItems_WidgetPage();
}

class AvailableItems_WidgetPage extends State<Test> {

  @override
  Widget build(BuildContext context) {

    ScreenUtil.init(context);
    ScreenUtil().allowFontScaling = false;

    switch (widget.mode) {
      case 'instant': return InstantOrders();
      case 'preorder': return PreOrders();
    }
  }



  Widget InstantOrders(){
    try
    {
      return ValueListenableBuilder(
          valueListenable: ChefItemData.notifier,
          builder: (context, value, child) {
            print('ChefItemData.notifier called');
            if(ChefItemData.availableChefsItems_Instant != null && ChefItemData.availableChefsItems_Instant.length > 0){

              List<DocumentSnapshot> limitedItems = new List<DocumentSnapshot>();
              int count = 1;
              for(int i=0;i<ChefItemData.availableChefsItems_Instant.length;i++){
                if(count > 30){
                  break;
                }
                DocumentSnapshot dt = ChefItemData.availableChefsItems_Instant[i];
                if(dt.data().containsKey('Order_Type')){
                  if(dt['Order_Type'] == 'Instant'){
                    limitedItems.add(dt);
                    count++;
                  }
                }
              }

              return Container(
                child: Column(
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                              padding: EdgeInsets.only(top: 7.0,bottom: 8.0,left: 15.0,right: 15.0),
                              color: Colors.blueGrey.withOpacity(0.1),
                              width: double.infinity,
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                                Text("Available Itms",textScaleFactor: 1.0, style: TextStyle(fontSize: 17.0, height: 1.3, color: HexColor('#55A47E'), fontFamily: 'Product Sans', fontWeight: FontWeight.w500)),
                                InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => AvailableItems(mode: 'instant',)));
                                    },
                                    child: Container(child: Text('View All',textScaleFactor: 1.0, style: TextStyle(color: Colors.blueGrey)))
                                )
                              ])
                          )
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 10.0,bottom: 30.0,left: 15.0,right: 15.0),
                          color: Colors.blueGrey.withOpacity(0.05),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: limitedItems.map((DocumentSnapshot document) {
                                return ItemCard(item: document);
                              }).toList(),
                            ),
                          )
                      )
                    ]),
              );
            }
            else{
              return AlertDialog(
                title: Text('No Chef Spotted in your location'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Image.asset("assets/No.jpeg"),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('Change Location',textScaleFactor: 1.0, style: TextStyle(fontSize: 17.0, height: 1.3, color: HexColor('#55A47E'), fontFamily: 'Product Sans', fontWeight: FontWeight.w500)),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PinLocation2()));
                    },
                  ),
                ],
              );
              //return Center(child: Text('No Chefs Spotted in Your Location , switch Location', style: TextStyle(fontSize: 14.0,color: Colors.redAccent)));
              //return SizedBox();
            }
          }
      );
    }
    catch(err){
      print(err.toString());
      return Container(width: 0.0,height: 0.0);
    }
  }

  Widget PreOrders(){
    try
    {
      return ValueListenableBuilder(
          valueListenable: ChefItemData.notifier,
          builder: (context, value, child) {
            if(ChefItemData.availableChefsItems_Pre != null && ChefItemData.availableChefsItems_Pre.length > 0){
              List<DocumentSnapshot> limitedItems = new List<DocumentSnapshot>();
              int count = 1;
              for(int i=0;i<ChefItemData.availableChefsItems_Pre.length;i++){
                if(count > 130){
                  break;
                }
                DocumentSnapshot dt = ChefItemData.availableChefsItems_Pre[i];
                if(dt.data().containsKey('Order_Type')){
                  if(dt['Order_Type'] == 'Pre'){
                    limitedItems.add(dt);
                    count++;
                  }
                }
              }


              return Container(

                child: Column(
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                              padding: EdgeInsets.only(top: 7.0,bottom: 8.0,left: 15.0,right: 15.0),
                              color: Colors.blueGrey.withOpacity(0.1),
                              width: double.infinity,
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                                Text("Available Items",textScaleFactor: 1.0, style: TextStyle(fontSize: 17.0, height: 1.3, color: HexColor('#55A47E'), fontFamily: 'Product Sans', fontWeight: FontWeight.w500)),
                                InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => AvailableItems(mode: 'preorder',)));
                                    },
                                    child: Container(child: Text('View All',textScaleFactor: 1.0, style: TextStyle(color: Colors.blueGrey)))
                                )
                              ])
                          )
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 15.0,bottom: 30.0,left: 15.0,right: 15.0),
                          color: Colors.blueGrey.withOpacity(0.05),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: limitedItems.map((DocumentSnapshot document) {
                                return ItemCard(item: document);
                              }).toList(),
                            ),
                          )
                      )
                    ]),
              );
            }
            else{
              //return Center(child: Text('We are sorry. Currently, No items are available.', style: TextStyle(fontSize: 14.0,color: Colors.redAccent)));
              return SizedBox();
            }
          }
      );
    }
    catch(err){
      print(err.toString());
      return Container(width: 0.0,height: 0.0);
    }
  }

}