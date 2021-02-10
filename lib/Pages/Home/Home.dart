

import 'package:eatinom/Pages/App/AppConfig.dart';
import 'package:eatinom/Pages/Home/InstantOrder.dart';
import 'package:eatinom/Pages/Home/PreOrder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

class Home extends StatefulWidget {
  static const routeName = '/Home';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin,AutomaticKeepAliveClientMixin<Home> {

  @override
  bool get wantKeepAlive => true;

  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {

    ScreenUtil.init(context);
    ScreenUtil().allowFontScaling = false;

    return Container(
      child: ListView(children: [
        Container(
          decoration: BoxDecoration(
              color: HexColor('#FAF7F1'),
              boxShadow: [BoxShadow(
                color: Colors.black26,
                blurRadius: 5.0,
                spreadRadius: 1.0
              )
              ]
          ),
          child:TabBar(
          controller: _controller,
          isScrollable: true,
          indicatorColor: Colors.blueGrey.withOpacity(0.5),
          tabs: <Widget>[
            new Tab(
              child: Row(
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(right: 5.0),child: Icon(Icons.emoji_food_beverage,color:  Colors.blueGrey.shade300,size: 15.0,)),
                  Text('Instant',textScaleFactor: 1.0,style: TextStyle(color:  Colors.blueGrey.shade400,fontSize: 16.0,fontFamily: 'Product Sans')),
                ],
              ),
            ),
            new Tab(
              child:Row(
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(right: 5.0),child: Icon(Icons.av_timer,color:  Colors.blueGrey.shade300,size: 15.0,)),
                  Text('Pre Order',textScaleFactor: 1.0,style: TextStyle(color:  Colors.blueGrey.shade400,fontSize: 16.0,fontFamily: 'Product Sans')),
                ],
              ),
            ),
            new Tab(
              child: Row(
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(right: 5.0),child: Icon(Icons.expand,color:  Colors.blueGrey.shade300,size: 15.0,)),
                  Text('Long Term',textScaleFactor: 1.0,style: TextStyle(color:  Colors.blueGrey.shade400,fontSize: 16.0,fontFamily: 'Product Sans')),
                ],
              ),
            ),
            new Tab(
              child: Row(
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(right: 5.0),child: Icon(Icons.accessibility,color:  Colors.blueGrey.shade300,size: 15.0,)),
                  Text('Diet Plan',textScaleFactor: 1.0,style: TextStyle(color:  Colors.blueGrey.shade400,fontSize: 16.0,fontFamily: 'Product Sans')),
                ],
              ),
            ),
          ],
        )),
        Container(
          color: Colors.blue.withOpacity(0.02),
            height: MediaQuery.of(context).size.height - (AppBar().preferredSize.height + AppConfig.AppBarHeight + AppConfig.BottomBarHeight + 10),
            child: new TabBarView(
                controller: _controller,
                children: <Widget>[
                  InstantOrder(),
                  PreOrder(),
                  new Container(
                    child: new Center(
                      child: new Image.asset("assets/1.png"),
                    ),
                  ),
                  new Container(
                    child: new Center(
                      child: new Image.asset("assets/3.png"),
                      /*Text('Coming Soon...',textScaleFactor: 1.0, style: TextStyle(fontSize: 22.0,
                          height: 1.3,
                          color: HexColor('#55A47E'),
                          fontFamily: 'Product Sans',
                          fontWeight: FontWeight.w500))*/
                    ),
                  )
                ])
        )
      ])
    );



  }

}