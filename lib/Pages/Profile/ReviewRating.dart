
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatinom/DataNotifier/CuisinesData.dart';
import 'package:eatinom/Pages/App/AppConfig.dart';
import 'package:eatinom/Pages/Cuisines/CuisineRelated.dart';
import 'package:eatinom/Pages/Profile/AddEditAddress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

class ReviewRating extends StatefulWidget {
  ReviewRating({Key key}) : super(key: key);


  @override
  ReviewRating_State createState() => new ReviewRating_State();
}

class ReviewRating_State extends State<ReviewRating> {


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
        title: Text('Review & Ratings',textScaleFactor: 1.0, style: TextStyle(fontFamily: 'Product Sans', color: Colors.blueGrey)),
        backgroundColor: Colors.white,
        //centerTitle: true,
      ),
      body: ShowBody(),
    );
  }

  Widget ShowBody(){
    try{

      return Container(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('Customer/'+AppConfig.userID+'/Reviews').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if(snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                        height: 300.0,
                        child: Center(child: CircularProgressIndicator())
                    );
                  }

                  if(snapshot.hasData && snapshot.data.docs.length > 0){
                    List<Widget> lst = new List<Widget>();
                    lst.add(Container(
                      padding: EdgeInsets.only(left: 10.0,top: 20.0,bottom: 10.0),
                      child: Align(alignment: Alignment.topLeft,child: Text('Your previously submitted reviews',textScaleFactor: 1.0, style: TextStyle(color: Colors.blueGrey.shade200, fontSize: 15.0,fontFamily: 'Product Sans'))),
                    ));
                    snapshot.data.docs.forEach((dt) {
                      lst.add(reviewCard(dt));
                    });
                    return SingleChildScrollView(
                      child: Column(children: lst),
                    );
                  }
                  else{
                    return Container(
                        height: 200.0,
                        child: Center(
                            child: Text('No reviews were found.',textScaleFactor: 1.0, style: TextStyle(color: Colors.red, fontFamily: 'Product Sans', fontSize: 15.0))
                        )
                    );
                  }

                }
            )
        );
    }
    catch(err){
      print(err);
      return Container(
        height: 100.0,
        child: Center(
            child: Text('Error while loading data.', style: TextStyle(color: Colors.red , fontSize: 16.0, fontFamily: 'Product Sans'))
        ),
      );
    }
  }




  Widget reviewCard(DocumentSnapshot dt){
    try{
      return Container(
          margin: EdgeInsets.all(10.0),
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: HexColor('#f1f1f1'),
              boxShadow: [BoxShadow(
                color: Colors.black26,
                blurRadius: 2.0,
              )]
          ),
          child: Column(children: [


            Container(
              width: double.infinity,
              margin: EdgeInsets.all(5.0),
              padding: EdgeInsets.all(10.0),
              color: Colors.black.withOpacity(0.04),
              child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                  Text('Order ID : '+(dt['Order_Id'].toString().substring(dt['Order_Id'].toString().length - 10, dt['Order_Id'].toString().length)).toUpperCase(),textScaleFactor: 1.0, style: TextStyle(color: Colors.indigo.shade300, fontSize: 15.0, fontFamily: 'Product Sans', fontWeight: FontWeight.w600)),

                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green.withOpacity(0.1),
                      ),
                      child: Padding(padding: EdgeInsets.only(left: 10.0, right: 10.0,top: 5.0, bottom: 5.0),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                            Padding(padding: EdgeInsets.only(bottom: 2.0,right: 3.0),child: Icon(Icons.star_rate, size: 16.0,color: Colors.green)),
                            Text(dt['Rating'] != null ? dt['Rating'].toString().length == 1 ? dt['Rating'].toString() + '.0' : dt['Rating'].toString() : SizedBox(width: 0.0,height: 0.0),textScaleFactor: 1.0, style: TextStyle(color: Colors.blueGrey))
                          ])
                      )
                  )
                ])
              ]),
            ),
            ListTile(
              leading: Container(padding: EdgeInsets.only(top: 5.0,left: 5.0),child: Icon(Icons.rate_review_sharp, color: Colors.orange.shade200,)),
              title: Text(dt['Type'] == 'Chef' ? dt['Chef_Name'] : dt['Delivery_Person'],textScaleFactor: 1.0, overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black87,fontSize: 16.0,fontFamily: 'Product Sans', fontWeight: FontWeight.w600)),
              subtitle: Text(dt['Message'],overflow: TextOverflow.ellipsis,maxLines: 3,textScaleFactor: 1.0, style: TextStyle(color: Colors.black87,fontSize: 13.0,fontFamily: 'Product Sans', fontWeight: FontWeight.w300)),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.blueGrey.shade200,size: 20.0),
                onPressed: (){
                  FirebaseFirestore.instance.collection("Customer/"+AppConfig.userID+'/Reviews').doc(dt.id).delete();
                  setState(() {});
                },
              ),
            ),
          ])
          
          
          




      );
    }
    catch(err){
      print(err);
    }
  }




}