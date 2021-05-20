import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatinom/Pages/App/AppConfig.dart';
import 'package:eatinom/Pages/Cart/CartIcon_Widget.dart';
import 'package:eatinom/Pages/Item/ItemCard.dart';
import 'package:eatinom/Pages/Notifications/Notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Chef extends StatefulWidget {
  Chef({Key key, this.chef}) : super(key: key);
  final DocumentSnapshot chef;
  @override
  ChefPage createState() => new ChefPage();
}

class ChefPage extends State<Chef> {
  bool onlyVeg = false;
  int selectedMenu = 0;
  final GlobalKey<CartIcon_WidgetPage> keyCart = GlobalKey();
  @override
  Widget build(BuildContext context) {
    AppConfig.context = context;

    ScreenUtil.init(context);
    ScreenUtil().allowFontScaling = false;

    return Scaffold(
        backgroundColor: Colors.blueGrey.shade50,
        body: Stack(children: [
          Container(
            width: 40.0,
            color: Colors.blueGrey.shade100,
          ),
          NestedScrollView(headerSliverBuilder:
              (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  expandedHeight: MediaQuery.of(context).size.height * 0.25,
                  floating: false,
                  pinned: true,
                  backgroundColor: Colors.white,
                  iconTheme: IconThemeData(
                    color: Colors.blueGrey, //change your color here
                  ),
                  actions: [
                    Container(
                        child: IconButton(
                            icon: Image.asset(
                              'assets/Notification.png',
                              height: 21.0,
                              width: 21.0,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Notifications()));
                            })),
                    CartIcon_Widget(colorkey: Colors.white)
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                      centerTitle: false,
                      title: Text(widget.chef['Display_Name'],
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontFamily: 'Product Sans',
                              fontWeight: FontWeight.w600)),
                      background: Image.asset('assets/ChefAppBar.jpg',
                          fit: BoxFit.cover)),
                ),
              )
            ];
          }, body: Builder(builder: (context) {
            return CustomScrollView(
              slivers: <Widget>[
                SliverOverlapInjector(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                ),
                SliverToBoxAdapter(child: Container(child: RightBody())),
              ],
            );
          })),
          LeftMenu(),
        ]));
  }

  Widget LeftMenu() {
    try {
      return Container(
          margin: EdgeInsets.only(top: AppBar().preferredSize.height + 25),
          height: MediaQuery.of(context).size.height -
              (AppBar().preferredSize.height + 25),
          width: 40.0,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(height: 100.0),
                InkWell(
                    onTap: () {
                      setState(() {
                        selectedMenu = 0;
                      });
                    },
                    child: RotatedBox(
                      quarterTurns: -1,
                      child: selectedMenu == 0
                          ? Row(children: [
                              Container(
                                  width: 10.0,
                                  height: 10.0,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.deepOrangeAccent)),
                              SizedBox(width: 10.0),
                              Text('Menu',
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                      color: Colors.deepOrangeAccent,
                                      fontFamily: 'Product Sans',
                                      fontSize: 20.0))
                            ])
                          : Text('Menu',
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontFamily: 'Product Sans',
                                  fontSize: 20.0)),
                    )),
                InkWell(
                    onTap: () {
                      setState(() {
                        selectedMenu = 1;
                      });
                    },
                    child: RotatedBox(
                      quarterTurns: -1,
                      child: selectedMenu == 1
                          ? Row(children: [
                              Container(
                                  width: 10.0,
                                  height: 10.0,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.deepOrangeAccent)),
                              SizedBox(width: 10.0),
                              Text('Ratings & Reviews',
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                      color: Colors.deepOrangeAccent,
                                      fontFamily: 'Product Sans',
                                      fontSize: 20.0))
                            ])
                          : Text('Ratings & Reviews',
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontFamily: 'Product Sans',
                                  fontSize: 20.0)),
                    )),
                InkWell(
                    onTap: () {
                      setState(() {
                        selectedMenu = 2;
                      });
                    },
                    child: RotatedBox(
                      quarterTurns: -1,
                      child: selectedMenu == 2
                          ? Row(children: [
                              Container(
                                  width: 10.0,
                                  height: 10.0,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.deepOrangeAccent)),
                              SizedBox(width: 10.0),
                              Text('About',
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                      color: Colors.deepOrangeAccent,
                                      fontFamily: 'Product Sans',
                                      fontSize: 20.0))
                            ])
                          : Text('About',
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontFamily: 'Product Sans',
                                  fontSize: 20.0)),
                    )),
                SizedBox(height: 50.0),
              ]));
    } catch (err) {
      print(err);
    }
  }

  Widget RightBody() {
    if (selectedMenu == 0) {
      return MenuWidget();
    }
    if (selectedMenu == 1) {
      return RatingsWidget();
    }
    if (selectedMenu == 2) {
      return AboutWidget();
    }
  }

  Widget MenuWidget() {
    return Container(
        child: Container(
      margin: EdgeInsets.only(left: 40.0),
      child: Column(children: [
        Container(
            padding: EdgeInsets.only(
                top: 20.0, left: 20.0, right: 20.0, bottom: 5.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Chef\'s Menu',
                      textScaleFactor: 1.0,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22.0,
                          fontFamily: 'Product Sans',
                          fontWeight: FontWeight.w600)),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green.withOpacity(0.1),
                      ),
                      child: Padding(
                          padding: EdgeInsets.only(
                              left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(
                                        bottom: 2.0, right: 3.0),
                                    child: Icon(Icons.star_rate,
                                        size: 16.0, color: Colors.green)),
                                Text(
                                    widget.chef['Rating'] != null
                                        ? widget.chef['Rating']
                                                    .toString()
                                                    .length ==
                                                1
                                            ? widget.chef['Rating'].toString() +
                                                '.0'
                                            : widget.chef['Rating'].toString()
                                        : SizedBox(width: 0.0, height: 0.0),
                                    textScaleFactor: 1.0,
                                    style: TextStyle(color: Colors.blueGrey))
                              ])))
                ])),
        Align(
            alignment: Alignment.centerLeft,
            child: Container(
                padding: EdgeInsets.only(left: 20.0, top: 0.0, bottom: 10.0),
                child: Text(
                  'Veg, Non Veg',
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      color: Colors.black45,
                      fontSize: 15.0,
                      fontFamily: 'Product Sans'),
                ))),
        widget.chef.data().containsKey('Cuisines')
            ? Container(
                padding: EdgeInsets.only(left: 10.0),
                child: showCuisines(widget.chef['Cuisines']))
            : SizedBox(width: 0.0, height: 0.0),
        widget.chef.data().containsKey('Highlights')
            ? showHighlights(widget.chef['Highlights'])
            : SizedBox(width: 0.0, height: 0.0),
        Align(
            alignment: Alignment.centerLeft,
            child: Container(
                padding: EdgeInsets.only(
                    top: 10.0, bottom: 0.0, left: 20.0, right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Order Food',
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 18.0,
                            fontFamily: 'Product Sans')),
                    //Padding(padding: EdgeInsets.only(top: 6.0),child: Icon(Icons.search, color: Colors.blueGrey.withOpacity(0.7),size: 25.0))
                    Row(children: [
                      Text('Only Veg',
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.blue,
                              fontFamily: 'Product Sans')),
                      InkWell(
                          child: Switch(
                            value: onlyVeg,
                            onChanged: (value) {
                              setState(() {
                                onlyVeg = value;
                              });
                            },
                          ),
                          onTap: () {
                            setState(() {
                              onlyVeg = !onlyVeg;
                            });
                          })
                    ])
                  ],
                ))),
        AvailableItems(),
      ]),
      //)
    ));
  }

  Widget showCuisines(String cuisines) {
    try {
      List<Widget> lst = new List<Widget>();
      cuisines.split(',').forEach((element) {
        lst.add(Container(
            padding: EdgeInsets.only(left: 10.0, top: 0.0, bottom: 10.0),
            child: Container(
              padding: EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.orange.shade100,
              ),
              child: Text(element,
                  textScaleFactor: 1.0, style: TextStyle(color: Colors.black)),
            )));
      });
      return Column(
        children: [
          Row(children: lst),
        ],
      );
    } catch (err) {
      return SizedBox(width: 0.0, height: 0.0);
    }
  }

  Widget showHighlights(String highlights) {
    try {
      return Container(
          padding: EdgeInsets.all(20.0),
          child: Container(
              color: Colors.blue.withOpacity(0.1),
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Image.asset('assets/chef.png',
                          height: 59.0, width: 59.0)),
                  Flexible(
                      child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text(highlights,
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  height: 1.5,
                                  color: Colors.blueGrey,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Product Sans'))))
                ],
              )));
    } catch (err) {
      print(err.toString());
      return SizedBox(width: 0.0, height: 0.0);
    }
  }

  Widget RatingsWidget() {
    return Container(
        height: MediaQuery.of(context).size.height,
        child: Container(
            margin: EdgeInsets.only(left: 40.0),
            color: Colors.blueGrey.shade50,
            child: Center(
                child: Text(
              'Ratings',
              textScaleFactor: 1.0,
            ))));
  }

  Widget AboutWidget() {
    return Container(
        child: Container(
            margin: EdgeInsets.only(left: 40.0),
            color: Colors.blueGrey.shade50,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10, top: 70),
              child: Align(
                alignment: Alignment.topCenter,
                child: Center(
                  child: Text(
                      widget.chef['aboutChef'] != null
                          ? widget.chef['aboutChef']
                          : SizedBox(width: 0.0, height: 0.0),
                      textScaleFactor: 1.0,
                      style: TextStyle(color: Colors.blueGrey)),
                ),
              ),
            )));
  }

  Widget AvailableItems() {
    try {
      CollectionReference chefItems =
          FirebaseFirestore.instance.collection('ChefItems');

      return StreamBuilder<QuerySnapshot>(
          stream:
              chefItems.where('Chef_Id', isEqualTo: widget.chef.id).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            /*  if (snapshot.hasError) {
              return Center(child: Text('Error while loading data', style: TextStyle(color: Colors.red, fontFamily: 'Product Sans', fontSize: 20.0),));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(height: 100.0, child: Center(child: SizedBox(width: 20.0, height: 20.0, child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueGrey)))));
            }*/
            if (snapshot.hasData && snapshot.data.docs.length > 0) {
              List<Widget> filterItems = new List<Widget>();
              if (onlyVeg) {
                snapshot.data.docs.forEach((item) {
                  if (item.data().containsKey('Food_Type') &&
                      item['Food_Type'] == 'Veg') {
                    filterItems.add(ItemCard(item: item));
                  }
                });
              } else {
                snapshot.data.docs.forEach((item) {
                  filterItems.add(ItemCard(item: item));
                });
              }
              return filterItems.length > 0
                  ? Container(
                      child: Column(children: [
                        Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            //color: Colors.blueGrey.withOpacity(0.05),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                children: filterItems,
                              ),
                            ))
                      ]),
                    )
                  : Center(
                      child: Container(
                          padding: EdgeInsets.only(top: 30.0),
                          height: 100.0,
                          child: Text('No items found.',
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 18.0,
                                  fontFamily: 'Product Sans'))));
            } else {
              print('5555');
              return Container(
                  height: 150.0,
                  padding: EdgeInsets.all(20.0),
                  child: Flexible(
                      flex: 1,
                      child: Center(
                          child: Text(
                              'We are sorry. Currently no items are available.',
                              style: TextStyle(
                                  fontSize: 17.0,
                                  color: Colors.green.withOpacity(0.8))))));
            }
          });
    } catch (err) {
      print(err.toString());
      return Container(
          height: 150.0,
          padding: EdgeInsets.all(20.0),
          child: Flexible(
              flex: 1,
              child: Center(
                  child: Text('Error while loading data',
                      style: TextStyle(
                          color: Colors.red.withOpacity(0.8),
                          fontFamily: 'Product Sans',
                          fontSize: 17.0)))));
    }
  }
}
