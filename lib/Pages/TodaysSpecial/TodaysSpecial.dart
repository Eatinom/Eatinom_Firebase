
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatinom/DataNotifier/ChefItemData.dart';
import 'package:eatinom/Pages/App/AppConfig.dart';
import 'package:eatinom/Pages/Item/ItemCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

class TodaySpecial extends StatefulWidget {
  TodaySpecial({Key key, this.mode}) : super(key: key);
  final String mode;

  @override
  TodaySpecialPage createState() => new TodaySpecialPage();
}

class TodaySpecialPage extends State<TodaySpecial> {

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
        title: Text("Today's Special",textScaleFactor: 1.0, style: TextStyle(fontFamily: 'Product Sans',color: Colors.blueGrey)),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: showBody(),
    );
  }


  Widget showBody() {
    switch (widget.mode) {
      case 'instant': return InstantSpecials();
      case 'preorder': return PreSpecials();
    }
  }

  Widget InstantSpecials(){
    try
    {
      return ValueListenableBuilder(
          valueListenable: ChefItemData.notifier,
          builder: (context, value, child)
          {
            if(ChefItemData.availableChefsItems_Instant != null && ChefItemData.availableChefsItems_Instant.length > 0){

              List<Widget> AllItems = new List<Widget>();

              ChefItemData.availableChefsItems_Instant.forEach((dt) {
                if(dt['Todays_Special'] == true){
                  AllItems.add(ItemCard(item: dt));
                }
              });

              return Container(
                color: Colors.blueGrey.withOpacity(0.05),
                child: Column(
                    children: [

                      Container(
                          padding: EdgeInsets.only(top: 15.0,bottom: 30.0,left: 15.0,right: 15.0),
                          //color: Colors.blueGrey.withOpacity(0.05),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: AllItems,
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

  Widget PreSpecials(){
    try
    {
      return ValueListenableBuilder(
          valueListenable: ChefItemData.notifier,
          builder: (context, value, child)
          {
            if(ChefItemData.availableChefsItems_Pre != null && ChefItemData.availableChefsItems_Pre.length > 0){

              List<Widget> AllItems = new List<Widget>();

              ChefItemData.availableChefsItems_Pre.forEach((dt) {
                if(dt['Todays_Special'] == true){
                  AllItems.add(ItemCard(item: dt));
                }
              });

              return Container(
                color: Colors.blueGrey.withOpacity(0.05),
                child: Column(
                    children: [

                      Container(
                          padding: EdgeInsets.only(top: 15.0,bottom: 30.0,left: 15.0,right: 15.0),
                          //color: Colors.blueGrey.withOpacity(0.05),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: AllItems,
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