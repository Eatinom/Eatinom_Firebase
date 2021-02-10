import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatinom/DataNotifier/CartData.dart';
import 'package:eatinom/DataNotifier/ChefData.dart';
import 'package:eatinom/DataNotifier/ChefItemData.dart';
import 'package:eatinom/Pages/App/AppConfig.dart';
import 'package:eatinom/Pages/Cart/CartIcon_Widget.dart';
import 'package:eatinom/Pages/Item/Item.dart';
import 'package:eatinom/Pages/Item/ItemCard.dart';
import 'package:eatinom/Pages/Notifications/Notifications.dart';
import 'package:eatinom/Pages/TodaysSpecial/TodaysSpecial.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:responsive_grid/responsive_grid.dart';

class Offers extends StatefulWidget {
  Offers({Key key, this.selectedBanner}) : super(key: key);
  final DocumentSnapshot selectedBanner;
  @override
  OffersPage createState() => new OffersPage();
}

class OffersPage extends State<Offers>{

  GlobalKey appBarKey = GlobalKey();
  bool onlyVeg = false;

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
                color: Colors.blue.withOpacity(0.03),
                padding: EdgeInsets.only(left: 0.0,right: 0.0,top: 0.0),
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: OffersResults(),
                )
            )
        )
    );
  }

  Widget appBarWidget(){
    try{
      return AppBar(
        automaticallyImplyLeading: true,
        title: Text(widget.selectedBanner['Display_Text'],textScaleFactor: 1.0, style: TextStyle(color: Colors.blueGrey, fontSize: 20.0, fontFamily: 'Product Sans')),
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


  Widget OffersResults() {
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



            if(lst != null && lst.length > 0){

              List<DocumentSnapshot> filterList = new List<DocumentSnapshot>();
              lst.forEach((document) {
                if(document.data().containsKey('Offer_Applicable')){
                  if(document['Offer_Applicable'] == widget.selectedBanner['Offer_Code']){
                    filterList.add(document);
                  }
                }
              });

              if(filterList.length > 0){
                return Column(children: [
                  Align(alignment: Alignment.centerLeft,
                      child: Container(
                          padding: EdgeInsets.only(top: 10.0,bottom: 0.0,left: 20.0,right: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(textScaleFactor: 1.0,
                                  text: TextSpan(
                                    text: '"'+filterList.length.toString()+'"',
                                    style: TextStyle(fontSize: 18.0,color: Colors.orange, fontWeight: FontWeight.w600,fontFamily: 'Product Sans'),
                                    children: <TextSpan>[
                                      TextSpan(text: " results found", style: TextStyle(fontSize: 18.0,color: Colors.orange,fontWeight: FontWeight.w400,fontFamily: 'Product Sans')),
                                    ],
                                  )
                              ),
                              //Padding(padding: EdgeInsets.only(top: 6.0),child: Icon(Icons.search, color: Colors.blueGrey.withOpacity(0.7),size: 25.0))
                              Row(children: [
                                Text('Only Veg',textScaleFactor: 1.0, style: TextStyle(fontSize: 15.0, color: Colors.blue,fontFamily: 'Product Sans')),
                                InkWell(
                                    child: Switch(
                                      value: onlyVeg,
                                      onChanged: (value) {
                                        setState(() {
                                          onlyVeg = value;
                                        });
                                      },
                                    ),
                                    onTap: (){
                                      setState(() { onlyVeg = !onlyVeg;});
                                    }
                                )
                              ])
                            ],
                          )
                      )
                  ),


                  Container(
                      padding: EdgeInsets.only(top: 0.0,bottom: 0.0),
                      child: ResponsiveGridList(
                        desiredItemWidth: MediaQuery.of(context).size.width * 0.40,
                        scroll: false,
                        minSpacing: 15,
                        children: filterList.map((DocumentSnapshot document) {
                          return specialCard(document);
                        }).toList(),
                      )
                  )

                ]);
              }
              else{
                return SizedBox();
              }
            }
            else{
              return Column(children: [Container(
                  height: 100.0,
                  padding: EdgeInsets.only(bottom: 10.0,top: 5.0),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text('No items found for '+widget.selectedBanner['Display_Text'],textScaleFactor: 1.0, style: TextStyle(color: Colors.red,fontSize: 15.0,fontFamily: 'Product Sans'))
                  )
              )]);
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
          ShowItemDetail(dt);
        },
        child: Container(
            width: MediaQuery.of(context).size.width * 0.40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [BoxShadow(
                  color: Colors.black26,
                  blurRadius: 2.0
                )]
            ),
            child: Column(children: [
              Container(
                padding: EdgeInsets.all(5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset('assets/ChefAppBar.jpg',height: 100.0,),
                )
              ),

              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  padding: EdgeInsets.only(top: 5.0,bottom: 5.0,left: 10.0,right: 10.0),
                    child: Text(dt['Name'],textScaleFactor: 1.0, style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'Product Sans', fontWeight: FontWeight.w600))
                )
              ),

              Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                      padding: EdgeInsets.only(top: 5.0,bottom: 5.0,left: 10.0,right: 10.0),
                      child: Row(children: [
                        Padding(padding: EdgeInsets.only(right: 5.0),
                          child: Icon(Icons.person, color: Colors.deepOrange,size: 20.0)
                        ),
                        Text(dt['Chef_Name'],textScaleFactor: 1.0, style: TextStyle(color: Colors.deepOrange, fontSize: 13.0, fontFamily: 'Product Sans',fontWeight: FontWeight.w400))
                      ])
                  )
              ),

              Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                      padding: EdgeInsets.only(top: 5.0,bottom: 5.0,left: 10.0,right: 10.0),
                      child: Row(children: [
                        Padding(padding: EdgeInsets.only(right: 5.0),
                            child: Icon(Icons.timer, color: Colors.blueGrey,size: 20.0)
                        ),
                        Text(dt['Preparation_Time_Display'],textScaleFactor: 1.0, style: TextStyle(color: Colors.blueGrey, fontSize: 13.0, fontFamily: 'Product Sans',fontWeight: FontWeight.w400))
                      ])
                  )
              ),


              Align(
                alignment: Alignment.bottomCenter,
                child: Container(padding: EdgeInsets.only(top: 10.0,left: 10.0,right: 10.0,bottom: 5.0),child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\u20B9 '+dt['Price'].toString(),//dt.data().containsKey('Price') ? dt['Price'] is int ? dt['Price'].toDouble().toString() : dt['Price'].toString() : '-',
                      textScaleFactor: 1.0,
                      style: const TextStyle(
                        fontSize: 22.0,
                        color: Colors.lightGreen,
                      ),
                    ),
    
                    CartData.getItemCount(dt.id) > 0 ?
    
                    Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                            width: 100.0,
                            height: 30.0,
                            margin: EdgeInsets.only(bottom: 5.0),
                            padding: EdgeInsets.only(top: 3.0,bottom: 3.0,left: 10.0,right: 10.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: HexColor('#efefef'),
                                boxShadow: [BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 1.0,
                                )]
                            ),
    
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                              _decrementButton(dt),
    
                              Text(CartData.getItemCount(dt.id).toString(),textScaleFactor: 1.0, style: TextStyle(fontSize: 18.0,color: Colors.blueAccent.shade200)),
    
                              _incrementButton(dt),
                            ])
                        )
                    )
    
                        : Align(
                        alignment: Alignment.bottomRight,
                        child: InkWell(child: Container(
                            width: 70.0,
                            height: 27.0,
                            margin: EdgeInsets.only(bottom: 5.0),
                            padding: EdgeInsets.only(top: 3.5,bottom: 2.0,left: 5.0,right: 10.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.orangeAccent.shade100,
                                boxShadow: [BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 1.0,
                                )]
                            ),
    
                            child: Center(
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                                  Padding(padding: EdgeInsets.only(bottom: 20.0),child: Icon(Icons.add_circle, size: 20.0,color: Colors.blueGrey.withOpacity(0.3))),
                                  Text('ADD',textScaleFactor: 1.0, style: TextStyle(fontSize: 13.0,fontFamily: 'Product Sans',color: Colors.blueGrey))
                                ])
                            )
    
                        ),
                          onTap: (){
                            this.setState(() {
                              CartData.increaseItemCount(dt);
                              CartData.callNotifier();
                            });
                          } ,
                        )
                    )
                  ]
                ))
              )

            ])
        ),
      );

    }
    catch(err){
      print(err);
    }
  }



  Widget _incrementButton(DocumentSnapshot item) {
    return InkWell(
        onTap: () {
          this.setState(() {
            CartData.increaseItemCount(item);
            CartData.callNotifier();
          });

        },
        child: Icon(Icons.add, color: Colors.blueGrey)
    );
  }

  Widget _decrementButton(DocumentSnapshot item) {
    return InkWell(
      onTap: (){
        this.setState(() {
          CartData.decreaseItemCount(item);
          CartData.callNotifier();
        });

      },child: new Icon(Icons.remove, color: Colors.blueGrey),
    );
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
        builder: (context) => Container(height: MediaQuery.of(context).size.height * 0.90, child: Item(item: itm)),
      );
    }
    catch(err){
      print(err.toString());
      return SizedBox();
    }
  }

}