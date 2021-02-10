import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatinom/DataNotifier/ChefData.dart';
import 'package:eatinom/DataNotifier/ChefItemData.dart';
import 'package:eatinom/Pages/App/AppConfig.dart';
import 'package:eatinom/Pages/Cart/CartIcon_Widget.dart';
import 'package:eatinom/Pages/Chef/Chef.dart';
import 'package:eatinom/Pages/Item/Item.dart';
import 'package:eatinom/Pages/Item/ItemCard.dart';
import 'package:eatinom/Pages/Notifications/Notifications.dart';
import 'package:eatinom/Pages/TodaysSpecial/TodaysSpecial.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

class Search extends StatefulWidget {
  Search({Key key}) : super(key: key);

  @override
  SearchPage createState() => new SearchPage();
}

class SearchPage extends State<Search> with AutomaticKeepAliveClientMixin<Search>{

  GlobalKey appBarKey = GlobalKey();
  TextEditingController editController = TextEditingController();


  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    AppConfig.context = context;

    ScreenUtil.init(context);
    ScreenUtil().allowFontScaling = false;

    return GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          height: MediaQuery.of(context).size.height - AppBar().preferredSize.height,
          child: Stack(children: [

            Container(
              padding: EdgeInsets.only(left: 0.0,right: 0.0,top: 60.0),
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: editController.text.isNotEmpty ? searchResults() : initialScreen(),
                )
            ),

            Align(
                alignment: Alignment.topCenter,
                child: Container(
                    margin: EdgeInsets.all(15.0),
                    child: searchBoxWidget()
                )
            ),
          ])
        )
    );
  }

  Widget appBarWidget(){
    try{
      return AppBar(
        automaticallyImplyLeading: false,
        title: Text('Search',textScaleFactor: 1.0, style: TextStyle(color: Colors.white, fontSize: 20.0, fontFamily: 'Product Sans')),
        backgroundColor: Colors.blueGrey,
        elevation: 3.0,
        actions: [
          Container(
              child: IconButton(icon: Icon(Icons.notifications, color: Colors.blueGrey), onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => Notifications())); })
          ),
          CartIcon_Widget()
        ],
      );
    }
    catch(err){
      print(err);
      return SizedBox();
    }
  }

  Widget searchBoxWidget(){
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.2),
        borderRadius: const BorderRadius.all(Radius.circular(10))
      ),
      height: 40,
      width: MediaQuery.of(context).size.width,
      constraints: const BoxConstraints(
          maxWidth: 500
      ),
      margin: const EdgeInsets.only(left: 0,right: 0),
      child: CupertinoTextField(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10))
        ),
        controller: editController,
        clearButtonMode: OverlayVisibilityMode.editing,
        keyboardType: TextInputType.text,
        maxLines: 1,
        placeholder: 'Search',
        placeholderStyle: TextStyle(color: Colors.black45),
        onEditingComplete: (){
          setState(() {

          });
        },
        onChanged: (value){
          if(value != null && value != '' && value.length > 3){
            setState(() {});
          }
          if(value == null || value == '' || value.length == 0){
            setState(() {});
          }
        },
      ),
    );
  }

  Widget initialScreen(){
    return Container(
        height: 500.0,child: Center(
        child: Icon(Icons.search_sharp, size: 100.0,color: Colors.blueGrey.shade50,)
      )
    );
  }


  Widget searchResults() {
    try{

      if(editController.text.isNotEmpty){
        String searchKey = editController.text;
        print('searchKey --- '+searchKey);

        return ValueListenableBuilder(
            valueListenable: ChefItemData.notifier,
            builder: (context, value, child) {
              print('ChefItemData.notifier called');
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
                            style: TextStyle(fontSize: 15.0,color: Colors.blueGrey, fontWeight: FontWeight.w400, fontFamily: 'Product Sans'),
                            children: <TextSpan>[
                              TextSpan(text: '"'+editController.text+'"', style: TextStyle(fontSize: 18.0,color: Colors.blueGrey,fontWeight: FontWeight.w600,fontFamily: 'Product Sans')),
                            ],
                          )
                      )
                  )
              ));
              lstWidgets.add(searchResults_Chefs());

              if(lst != null && lst.length > 0){

                bool firstRec = true;
                lst.forEach((itm) {
                  bool isAdded = false;
                  if(itm['Name'] != null && itm['Name'] != ''){
                    if(itm['Name'].toString().toLowerCase().contains(searchKey)) {
                      if(firstRec){
                        lstWidgets.add(itemsHeading());
                        firstRec = false;
                      }
                      lstWidgets.add(Container(padding: EdgeInsets.only(left:20.0,right: 20.0),child: ItemCard(item: itm)));
                      isAdded = true;
                    }
                  }
                  if(!isAdded && itm.data().containsKey('Search_Tags')){
                    if(itm['Search_Tags'] != null && itm['Search_Tags'] != ''){
                      if(itm['Search_Tags'].toString().toLowerCase().contains(searchKey)) {
                        if(firstRec){
                          lstWidgets.add(itemsHeading());
                          firstRec = false;
                        }
                        lstWidgets.add(Container(padding: EdgeInsets.only(left:20.0,right: 20.0),child: ItemCard(item: itm)));
                      }
                    }
                  }
                });
              }
              else{
                lstWidgets.add(Container(
                    height: 100.0,
                    padding: EdgeInsets.only(bottom: 10.0,top: 5.0),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text('No items found for given search key',textScaleFactor: 1.0, style: TextStyle(color: Colors.red,fontSize: 15.0,fontFamily: 'Product Sans'))
                    )
                ));
              }
              return Column(children: lstWidgets);
            }
        );

      }
    }
    catch(err){
      print(err.toString());
      return SizedBox();
    }
  }

  Widget itemsHeading(){
    return Align(
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
    );
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
              Align(alignment: Alignment.topCenter,child: Container(
                  width: 75.0,
                  height: 75.0,
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: HexColor('#efefef'),
                  ),
                  child: dt.data().containsKey('ImageStr') ? FittedBox(child: Image.memory(base64Decode(dt['ImageStr'])), fit: BoxFit.fill) : Center(child: Icon(Icons.fastfood_outlined, color: Colors.blueGrey,))
              )),
            ])
        ),
      );

    }
    catch(err){
      print(err);
    }
  }


  Widget searchResults_Chefs() {
    try{
      if(editController.text.isNotEmpty) {
        String searchKey = editController.text;
        print('searchKey --- ' + searchKey);
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
                List<String> cheflstIds = new List<String>();
                List<Widget> filteredChefs = new List<Widget>();
                cheflst.forEach((chef) {
                  bool isAdded = false;
                  if(chef.data().containsKey('Search_Tags')){
                    if(chef['Search_Tags'].toString().toLowerCase().contains(searchKey.toLowerCase())){
                      if(!cheflstIds.contains(chef.id)){
                        filteredChefs.add(specialCard(chef));
                        isAdded = true;
                        cheflstIds.add(chef.id);
                      }
                    }
                  }

                  if(!isAdded && chef['Display_Name'].toString().toLowerCase().contains(searchKey.toLowerCase())){
                    if(!cheflstIds.contains(chef.id)){
                      filteredChefs.add(specialCard(chef));
                      cheflstIds.add(chef.id);
                    }
                  }
                });



                return filteredChefs.length > 0 ? Container(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                                padding: EdgeInsets.only(top: 20.0, bottom: 5.0, left: 20.0),
                                child: RichText(textScaleFactor: 1.0,
                                    text: TextSpan(
                                      text: 'Chefs who prepare ',
                                      style: TextStyle(fontSize: 12.0,color: Colors.blue.shade200, fontWeight: FontWeight.w400),
                                      children: <TextSpan>[
                                        TextSpan(text: '"'+editController.text+'"', style: TextStyle(fontSize: 13.0,color: Colors.blue.shade200,fontWeight: FontWeight.w600)),
                                      ],
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
                ) : SizedBox();
              }
              else {
                return SizedBox(width: 0.0, height: 0.0);
              }
            }
        );
      }
      else{
        return SizedBox();
      }

    }
    catch(err){
      print(err.toString());
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
        builder: (context) => Container(height: MediaQuery.of(context).size.height * 0.75,child: Item(item: itm)),
      );
    }
    catch(err){
      print(err.toString());
      return SizedBox();
    }
  }

}