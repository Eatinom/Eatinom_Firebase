
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatinom/DataNotifier/CuisinesData.dart';
import 'package:eatinom/Pages/App/AppConfig.dart';
import 'package:eatinom/Pages/Cart/Cart.dart';
import 'package:eatinom/Pages/Cuisines/CuisineRelated.dart';
import 'package:eatinom/Pages/Profile/AddEditAddress.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

class CPlist extends StatefulWidget {
  CPlist({Key key}) : super(key: key);


  @override
  CPlist_State createState() => new CPlist_State();
}

class CPlist_State extends State<CPlist> {


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
        title: Text('Promo Codes',textScaleFactor: 1.0, style: TextStyle(fontFamily: 'Product Sans', color: Colors.blueGrey)),
        backgroundColor: Colors.white,
        //centerTitle: true,
      ),
      body: ShowBody(),
    );
  }

  Widget ShowBody(){
    try{
      return Stack(children: [
        Container(
            child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('Coupon').snapshots(),
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
                      child: Align(alignment: Alignment.topLeft,
                          child: Text('offers',textScaleFactor: 1.0, style: TextStyle(color: Colors.blueGrey.shade200, fontSize: 15.0,fontFamily: 'Product Sans'))),
                    ));
                    snapshot.data.docs.forEach((document) {
                      lst.add(addressCard(document));
                    });
                    return SingleChildScrollView(
                      child: Column(children: lst),
                    );
                  }
                  else{
                    return Container(
                        height: 200.0,
                        child: Center(
                            child: Text('No addresses were found.',textScaleFactor: 1.0, style: TextStyle(color: Colors.red, fontFamily: 'Product Sans', fontSize: 15.0))
                        )
                    );
                  }

                }
            )
        ),
     /*   Align(
          alignment: Alignment.bottomCenter,
         // child: AddNewButton(),
        )*/

      ]);
    }
    catch(err){
      print(err);
      return Container(
        height: 100.0,
        child: Center(
            child: Text('Error while loading data.',textScaleFactor: 1.0, style: TextStyle(color: Colors.red , fontSize: 16.0, fontFamily: 'Product Sans'))
        ),
      );
    }
  }

  Widget addressCard(DocumentSnapshot document){
    try{
      return InkWell(
       /*   onTap: (){
            //text = document.id;
           // Cart.applyCouponCode();
            Navigator.push(context, MaterialPageRoute(builder: (context) => Cart(document: document)));

          },*/
          onTap: () {
            SnackBar(
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () => print('Pressed'),
                disabledTextColor: Colors.yellow,
                textColor: Colors.green,
              ),
              content: Text('Sample snackbar'),
            );
            Clipboard.setData(new ClipboardData(
                text: document['Coupon_Code']));
            },


          child: Container(
              margin: EdgeInsets.all(10.0),
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: HexColor('#f1f1f1'),
                  boxShadow: [BoxShadow(
                    color: Colors.black26,
                    blurRadius: 1.0,
                  )
                  ]
              ),
              child: ListTile(
                  leading: Container(padding: EdgeInsets.only(top: 5.0,left: 5.0),child: Icon(Icons.radio_button_off_outlined, color: Colors.indigo,)),
                  title: Text(document['Coupon_Code'],textScaleFactor: 1.0, overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black87,fontSize: 16.0,fontFamily: 'Product Sans', fontWeight: FontWeight.w600)),
                  subtitle: Text('\u20B9 '+document['Discount'].toString(),textScaleFactor: 1.0, overflow: TextOverflow.ellipsis,maxLines: 3, style: TextStyle(color: Colors.black87,fontSize: 13.0,fontFamily: 'Product Sans', fontWeight: FontWeight.w300)),
                 trailing: Text('tap to copy'),
                  //trailing: Icon(Icons.arrow_forward_ios,size: 15.0,color: Colors.blueGrey.shade200,)
              )
          )
      );
    }
    catch(err){
      print(err);
    }
  }

  /*Widget AddNewButton(){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      constraints: const BoxConstraints(
          maxWidth: 500
      ),
      child: RaisedButton(
        onPressed: () {
          FocusScope.of(context).unfocus();
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddEditAddress()));
        },
        color: Colors.green.shade300,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          width: double.infinity,
          child: Text(
            'Add New Address',textScaleFactor: 1.0,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white,fontSize: 18.0),
          ),
        ),
      ),
    );
  }*/

}