
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatinom/Pages/App/AppConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share/share.dart';

class ReferFriend extends StatefulWidget {
  ReferFriend({Key key}) : super(key: key);

  @override
  ReferFriendPage createState() => new ReferFriendPage();
}

class ReferFriendPage extends State<ReferFriend> {


  @override
  Widget build(BuildContext context) {
    AppConfig.context = context;

    ScreenUtil.init(context);
    ScreenUtil().allowFontScaling = false;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.blueGrey, //change your color here
        ),
        title: Text("Refer a Friend",textScaleFactor: 1.0, style: TextStyle(fontFamily: 'Product Sans', color: Colors.blueGrey)),
        backgroundColor: Colors.white,
        //centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('App').doc('Config').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                height: 300.0,
                child: Center(child: CircularProgressIndicator())
            );
          }

          DocumentSnapshot config = snapshot.data;

          return Container(
            child: ShowBody(config),
          );
        },
      )
    );
  }

  Widget ShowBody(DocumentSnapshot config){

    return Stack(children: [
      Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: EdgeInsets.only(top: 50.0),
          child: Image.asset('assets/ReferFriendBg.png'),
        )
      ),
      Container(
        height: 30.0,
        margin: EdgeInsets.only(top: 40.0),
        width: double.infinity,
        child: Center(
            child: Container(
                width: MediaQuery.of(context).size.width * 0.80,
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: [
                  FittedBox(child: Text('Spread some love with Foood',textScaleFactor: 1.0, style: TextStyle(color: Colors.green, fontSize: 18.0, fontFamily: 'Product Sans')), fit: BoxFit.cover),
                  Icon(Icons.tag_faces_outlined, color: Colors.green, size: 25.0)
                ])
            )
        ),
      ),

      Align(alignment: Alignment.bottomCenter,child: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 150.0),
        padding: EdgeInsets.all(10.0),
        height: 90.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.orange.shade100,
          boxShadow: [BoxShadow(
            color: Colors.black26,
            blurRadius: 0.5,
          )]
        ),

        child: Center(child: ListTile(
          leading: Image.asset('assets/GiftBox.png'),
          subtitle: Text('Invite your friend and get Referal bonus each of Rs '+config['Referal_Bonus'].toString(),textScaleFactor: 1.0,overflow: TextOverflow.ellipsis,maxLines: 3, style: TextStyle(fontFamily: 'Product Sans', fontSize: 16.0)),
        ))
      )),

      Align(
        alignment: Alignment.bottomCenter,
        child: ReferButton(config),
      )

    ]);
  }


  Widget ReferButton(DocumentSnapshot config){

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      constraints: const BoxConstraints(
          maxWidth: 500
      ),
      child: RaisedButton(elevation: 0.0,
        onPressed: () {
          FocusScope.of(context).unfocus();
          Share.share('Eatinom is great app to get around. Signup using below Referal Code and you will get Rs. '+config['Referal_Bonus'].toString()+' credit towards future orders.\nReferal Code : '+AppConfig.userID.toUpperCase().substring(AppConfig.userID.length - 15 ,AppConfig.userID.length)+'https://play.google.com/store/apps/details?id=com.eatinom.eatinom');
        },
        color: Colors.green.shade100,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Text(
            'Refer a Friend',textScaleFactor: 1.0,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.green,fontSize: 19.0),
          ),
        ),
      ),

    );
  }

}