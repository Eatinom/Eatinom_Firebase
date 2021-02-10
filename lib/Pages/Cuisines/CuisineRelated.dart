import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatinom/DataNotifier/ChefData.dart';
import 'package:eatinom/DataNotifier/ChefItemData.dart';
import 'package:eatinom/Pages/App/AppConfig.dart';
import 'package:eatinom/Pages/Cart/CartIcon_Widget.dart';
import 'package:eatinom/Pages/Chef/Chef.dart';
import 'package:eatinom/Pages/Item/ItemCard.dart';
import 'package:eatinom/Pages/Notifications/Notifications.dart';
import 'package:eatinom/Pages/TodaysSpecial/TodaysSpecial.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

class CuisineRelated extends StatefulWidget {
  CuisineRelated({Key key, this.selectedCuisine}) : super(key: key);
  final String selectedCuisine;
  @override
  CuisineRelatedPage createState() => new CuisineRelatedPage();
}

class CuisineRelatedPage extends State<CuisineRelated>{

  GlobalKey appBarKey = GlobalKey();


  @override
  Widget build(BuildContext context) {
    AppConfig.context = context;

    ScreenUtil.init(context);
    ScreenUtil().allowFontScaling = false;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBarWidget(),
      body:Container(
        height: MediaQuery.of(context).size.height - AppBar().preferredSize.height,
        child: Container(
              padding: EdgeInsets.only(left: 0.0,right: 0.0,top: 0.0),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 20.0),
                child: CuisineRelatedResults(),
              )
        )
      )
    );
  }

  Widget appBarWidget(){
    try{
      return AppBar(
        automaticallyImplyLeading: true,
        title: Text(widget.selectedCuisine,textScaleFactor: 1.0, style: TextStyle(color: Colors.blueGrey, fontSize: 20.0, fontFamily: 'Product Sans')),
        backgroundColor: Colors.white,
        elevation: 3.0,
        iconTheme: IconThemeData(
          color: Colors.blueGrey, //change your color here
        ),
        actions: [
          Container(
              child: IconButton(icon: Image.asset('assets/Notification.png', height: 20.0,width: 20.0), onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => Notifications())); })
          ),
          CartIcon_Widget(colorkey: Colors.white,)
        ],
      );
    }
    catch(err){
      print(err);
      return SizedBox();
    }
  }


  Widget CuisineRelatedResults() {
    try{

      return ValueListenableBuilder(
          valueListenable: ChefItemData.notifier,
          builder: (context, value, child) {
            List<DocumentSnapshot> lst = new List<DocumentSnapshot>();
            if(ChefItemData.availableChefsItems_Instant != null && ChefItemData.availableChefsItems_Instant.length > 0){
              lst.addAll(ChefItemData.availableChefsItems_Instant);
            }
            if(ChefItemData.availableChefsItems_Pre != null && ChefItemData.availableChefsItems_Pre.length > 0){
              lst.addAll(ChefItemData.availableChefsItems_Pre);
            }

            List<Widget> lstWidgets = new List<Widget>();
            lstWidgets.add(Align(
                alignment: Alignment.topLeft,
                child: Container(
                    padding: EdgeInsets.only(top: 20.0, bottom: 5.0,left: 20.0),
                    child: RichText(textScaleFactor: 1.0,
                        text: TextSpan(
                          text: 'Results for ',
                          style: TextStyle(fontSize: 15.0,color: Colors.blueGrey, fontWeight: FontWeight.w400),
                          children: <TextSpan>[
                            TextSpan(text: '"'+widget.selectedCuisine+'"', style: TextStyle(fontSize: 18.0,color: Colors.blueGrey,fontWeight: FontWeight.w600)),
                          ],
                        )
                    )
                )
            ));
            lstWidgets.add(CuisineRelatedResults_Chefs());

            if(lst != null && lst.length > 0){
              bool firstRec = true;
              lst.forEach((itm) {
                if(itm.data().containsKey('Cuisine')){
                  if(itm['Cuisine'] != null && itm['Cuisine'] != ''){
                    if(itm['Cuisine'].contains(widget.selectedCuisine)) {
                      if(firstRec){
                        lstWidgets.add(Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                                padding: EdgeInsets.only(top: 20.0, bottom: 5.0,left: 20.0),
                                child: RichText(textScaleFactor: 1.0,
                                    text: TextSpan(
                                      text: 'Items',
                                      style: TextStyle(fontSize: 15.0,color: Colors.blue.withOpacity(0.6), fontWeight: FontWeight.w400),
                                    )
                                )
                            )
                        ));
                        firstRec = false;
                      }
                      lstWidgets.add(Container(padding: EdgeInsets.only(left:20.0,right: 20.0),child: ItemCard(item: itm)));
                    }
                  }
                }
              });
              return Column(children: lstWidgets);
            }
            else{
              lstWidgets.add(Container(
                  height: 100.0,
                  padding: EdgeInsets.only(bottom: 10.0,top: 5.0),
                  child: Align(
                      alignment: Alignment.topCenter,
                    child: new Center(
                      child: new Image.asset("assets/1.png"),
                    ),
                     // child: Text('We will be serving in Your Location Very Soon ... or Search any Other Location',textScaleFactor: 2.0, style: TextStyle(color: Colors.green,fontSize: 10.0,fontFamily: 'Product Sans'))
                  )
              ));
              return Column(children: lstWidgets);
            }

          }
        );


    }
    catch(err){
      print(err.toString());
      return SizedBox();
    }
  }

  Widget specialCard(DocumentSnapshot dt){
    try{
      return InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              Chef(chef: dt)));
        },
        child: Container(
            width: 130.0,
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
                        child: Text(dt['Display_Name'],textScaleFactor: 1.0, textAlign: TextAlign.center,style: TextStyle(fontFamily: 'Product Sans',fontSize: 15.0,color: Colors.black))
                    )),
                    Align(alignment: Alignment.bottomCenter,
                        child: Padding(
                            padding: EdgeInsets.only(bottom: 25.0,top: 10.0,right: 10.0,left: 35.0),
                            child: Row(children: [
                              Padding(padding: EdgeInsets.only(right: 2.0,bottom: 1.0),child: Icon(Icons.star_rate, size: 13.0,color: Colors.deepOrange)),
                              Text(dt['Rating'] != null ? dt['Rating'].toString().length == 1 ? dt['Rating'].toString() + '.0' : dt['Rating'].toString() : SizedBox(width: 0.0,height: 0.0),textScaleFactor: 1.0, style: TextStyle(color: Colors.deepOrange))
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
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),

              ),
           /*   Align(alignment: Alignment.topCenter,child: Container(
                  width: 75.0,
                  height: 75.0,
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: HexColor('#efefef'),
                  ),
                  child: FittedBox(child: Image.memory(base64Decode(dt['ImageStr'])), fit: BoxFit.cover)
              )),*/
            ])
        ),
      );

    }
    catch(err){
      print(err);
    }
  }


  Widget CuisineRelatedResults_Chefs() {
    try{
      return ValueListenableBuilder(
        valueListenable: ChefData.notifier,
        builder: (context, value, child) {
          List<DocumentSnapshot> cheflst = new List<DocumentSnapshot>();
          Map<String, Widget> lstChefWidgets = new Map<String, Widget>();
          if (ChefData.availableChefs_Instant != null &&
              ChefData.availableChefs_Instant.length > 0) {
            cheflst.addAll(ChefData.availableChefs_Instant.values);
          }
          if (ChefData.availableChefs_Pre != null &&
              ChefData.availableChefs_Pre.length > 0) {
            cheflst.addAll(ChefData.availableChefs_Pre.values);
          }
          if (cheflst != null && cheflst.length > 0) {

            List<Widget> filteredChefs = new List<Widget>();
            cheflst.forEach((chef) {
              bool isAdded = false;
              if(chef.data().containsKey('Search_Tags')){
                if(chef['Search_Tags'].toString().toLowerCase().contains(widget.selectedCuisine.toLowerCase())){
                  filteredChefs.add(specialCard(chef));
                  isAdded = true;
                }
              }

              if(!isAdded && chef['Cuisines'].toString().toLowerCase().contains(widget.selectedCuisine.toLowerCase())){
                filteredChefs.add(specialCard(chef));
              }
            });



            return filteredChefs.length > 0 ? Container(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Column(
                  children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                            padding: EdgeInsets.only(top: 20.0, bottom: 5.0, left: 20.0),
                            child: RichText(textScaleFactor: 1.0,
                                text: TextSpan(
                                  text: 'Chefs',
                                  style: TextStyle(fontSize: 15.0,color: Colors.blue.withOpacity(0.6), fontWeight: FontWeight.w400),
                                )
                            )
                        )
                    ),
                    Container(
                        padding: EdgeInsets.only(top: 0.0),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.only(left: 10.0),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: filteredChefs,
                          ),
                        )
                    )
                  ]),
            ) :  SizedBox();
          }
          else {
            return SizedBox(width: 0.0, height: 0.0);
          }
        }
    );


    }
    catch(err){
      print(err.toString());
    }
  }

}