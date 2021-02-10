import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatinom/DataNotifier/ChefData.dart';
import 'package:eatinom/DataNotifier/ChefItemData.dart';
import 'package:eatinom/DataNotifier/CuisinesData.dart';
import 'package:eatinom/DataNotifier/CustomerData.dart';
import 'package:eatinom/Pages/App/AppConfig.dart';
import 'package:eatinom/Pages/Cart/CartIcon_Widget.dart';
import 'package:eatinom/Pages/Error/NoInternet_Widget.dart';
import 'package:eatinom/Pages/Home/Home.dart';
import 'package:eatinom/Pages/Index/helper.dart';
import 'package:eatinom/Pages/Notifications/Notifications.dart';
import 'package:eatinom/Pages/Orders/OrderSuccess.dart';
import 'package:eatinom/Pages/Orders/Orders.dart';
import 'package:eatinom/Pages/PinLocation/PinLocation.dart';
import 'package:eatinom/Pages/PinLocation/PinLocation2.dart';
import 'package:eatinom/Pages/Profile/Profile.dart';
import 'package:eatinom/Pages/Search/Search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';



class Index extends StatefulWidget {
  Index({Key key, this.page}) : super(key: key);
  final int page;

  @override
  IndexPage createState() => new IndexPage();
}

class IndexPage extends State<Index> with WidgetsBindingObserver
{
  int _selectedIndex = 0;

  bool locationLoaded = true;


  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black, // navigation bar color
      statusBarColor: Colors.black,
    ));

    if(widget.page != null){
      _selectedIndex = widget.page;
    }
    CustomerData.initialize();
    CuisinesData.initialize();
    ChefData.initialize();
    ChefItemData.initialize();
    //WidgetsBinding.instance.addPostFrameCallback((_) => referalCodePopup(context));
   // Future.delayed(const Duration(milliseconds: 1000), () => referalCodePopup(context));
  }



  @override
  void dispose() {
    ChefData.dispose();
    ChefItemData.dispose();
    CuisinesData.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    AppConfig.context = context;
    AppConfig.AppBarHeight = AppBar().preferredSize.height;
    AppConfig.BottomBarHeight = kBottomNavigationBarHeight;

    ScreenUtil.init(context);
    ScreenUtil().allowFontScaling = false;

    return WillPopScope(
    //  onWillPop: () async => false,
        onWillPop: Helper.of(context).onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: appBarWidget(),
        body: Stack(children: [
          bodyWidget(_selectedIndex),
          NoInternet_Widget()
        ]),
        bottomNavigationBar: navigationBarWidget()
    ));
  }

  Widget appBarWidget(){

    return AppBar(
      automaticallyImplyLeading: false,
      title: titleWidget(),
      backgroundColor: HexColor('#FAF7F1'),
      elevation: _selectedIndex == 0 ? 0.0 : 5.0,
      actions: [
        Container(
            padding: EdgeInsets.all(0.00),
          child: IconButton(
              icon: Image.asset('assets/Notification.png', height: 18.0,width: 18.0),
              onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => Notifications())); })
        ),
        CartIcon_Widget()
      ],
    );

  }

  Widget titleWidget(){
    if(_selectedIndex == 0){
      return curLocationWidget();
    }
    else if(_selectedIndex == 1){
      return Text('Search', textScaleFactor: 1.0, style: TextStyle(color: Colors.blueGrey, fontSize: 20.0, fontFamily: 'Product Sans', fontWeight: FontWeight.w600));
    }
    else if(_selectedIndex == 2){
      return Text('Orders', textScaleFactor: 1.0,style: TextStyle(color: Colors.blueGrey, fontSize: 20.0, fontFamily: 'Product Sans', fontWeight: FontWeight.w600));
    }
    else if(_selectedIndex == 3){
      return Text('Profile', textScaleFactor: 1.0, style: TextStyle(color: Colors.blueGrey, fontSize: 20.0, fontFamily: 'Product Sans', fontWeight: FontWeight.w600));
    }
  }

  Widget navigationBarWidget(){
    return Container(
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(color: Colors.black26, blurRadius: 5.0, spreadRadius: 1.0),
        ],
      ),
      child: BottomNavigationBar(
        elevation: 0.0,
        backgroundColor: HexColor('#FAF7F1'),
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset('assets/h1.png', height: 24.0,width: 24.0),
            activeIcon: Image.asset('assets/home.png',height: 24.0,width: 24.0),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/search.png', height: 24.0,width: 24.0),
            activeIcon: Image.asset('assets/search1.png', height: 24.0,width: 24.0),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/orders.png', height: 24.0,width: 24.0),
            activeIcon: Image.asset('assets/order1.png', height: 24.0,width: 24.0),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/profile.png', height: 24.0,width: 24.0),
            activeIcon: Image.asset('assets/profile1.png', height: 24.0,width: 24.0),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: HexColor('#FFB612'),
        unselectedItemColor: Colors.blueGrey,
        unselectedLabelStyle: TextStyle(color: Colors.blueGrey),
        selectedFontSize: 12.0,
        unselectedFontSize: 10.0,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget bodyWidget(int selectedIndex){
    Widget wgt;
    if(selectedIndex == 0){
      wgt = Home();
    }
    else if(selectedIndex == 1){
      wgt = Search();
    }
    else if(selectedIndex == 2){
      wgt = Orders();
    }
    else if(selectedIndex == 3){
      wgt = Profile();
    }

    return wgt;
  }

  Widget curLocationWidget(){

    String area = '-';
    String city = '-';
    if(AppConfig.subLocality != null){
      area = AppConfig.subLocality;
      if(area != null && area.length > 20){
        area = area.substring(0,20)+'..';
      }

      city = AppConfig.locality;
      if(city != null && city.length > 20){
        city = city.substring(0,20)+'..';
      }
    }


    return InkWell(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.50,
        child: Row(children: [
          Padding(padding: EdgeInsets.only(left: 0.0,right: 10.0),child: Image.asset('assets/Location.png',height: 22.0,width: 22.0,)),
          RichText(textScaleFactor: 1.0,overflow: TextOverflow.ellipsis,text: TextSpan(
            text: area+'\n',
            style: TextStyle(fontSize: 14.0,height: 1.3,color: Colors.black,fontFamily: 'Product Sans'),
            children: <TextSpan>[
              TextSpan(text: city, style: TextStyle(fontSize: 11.0,color: Colors.grey)),
            ],
          )
        )
      ])),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => PinLocation2()));
      },
    );
  }

  void referalCodePopup(BuildContext context) async{
    try{
      if(AppConfig.showReferalPopup){
         FirebaseFirestore.instance.collection('Customer').doc(AppConfig.userID).snapshots().listen((customer) {
          if(customer != null){
            if(!customer.data().containsKey('FirstTime_Login') || customer['FirstTime_Login'] == true){
              print('referalCodePopup called - 2');
              showModalBottomSheet(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(50.0), topRight: Radius.circular(50.0)),
                ),
                isScrollControlled: true,
                isDismissible: true,
                context: context,
                builder: (context){
                  AppConfig.showReferalPopup = false;




                  return Container(
                      height: 250.0,
                      color: Colors.cyan.shade50,
                      child: Container()
                  );
                },
              );
            }
          }
        });
      }





    }
    catch(err){
      print(err);
    }
  }

}


