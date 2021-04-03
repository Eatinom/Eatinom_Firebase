import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatinom/DataNotifier/CartData.dart';
import 'package:eatinom/DataNotifier/ChefData.dart';
import 'package:eatinom/DataNotifier/ChefItemData.dart';
import 'package:eatinom/Pages/App/AppConfig.dart';
import 'package:eatinom/Pages/Item/Item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

class ItemCard extends StatefulWidget {
  ItemCard({Key key, this.item}) : super(key: key);
  final DocumentSnapshot item;
  @override
  ItemCardPage createState() => new ItemCardPage();
}

class ItemCardPage extends State<ItemCard> {
  String availableFrom, availableTo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection('Chef')
        .doc(widget.item['Chef_Id'])
        .snapshots()
        .listen((event) {
      availableFrom = event["availableFrom"][0]['itemName'];
      availableTo = event["availableTo"][0]['itemName'];
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    ScreenUtil().allowFontScaling = false;
    DocumentSnapshot dt = widget.item;

    return InkWell(
        onTap: () {
          ShowItemDetail(widget.item, availableFrom, availableTo);
        },
        child: ValueListenableBuilder(
            valueListenable: CartData.notifier,
            builder: (context, value, child) {
              return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Container(
                    height: 130,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white.withOpacity(1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 1.0,
                          )
                        ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(right: 15.0)),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(28.0),
                            child: Image.memory(
                              base64Decode(dt['ImageStr']),
                              width: 60,
                              height: 85,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 10.0, 10.0, 5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    dt['Name'],
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textScaleFactor: 1.0,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )),
                                              Align(
                                                  alignment: Alignment.topRight,
                                                  child: Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 5.0),
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            2.0,
                                                                        bottom:
                                                                            1.0),
                                                                child: Icon(
                                                                    Icons
                                                                        .star_rate,
                                                                    size: 13.0,
                                                                    color: Colors
                                                                        .blueGrey)),
                                                            Text(
                                                                dt['Rating'] !=
                                                                        null
                                                                    ? dt['Rating'].toString().length ==
                                                                            1
                                                                        ? dt['Rating'].toString() +
                                                                            '.0'
                                                                        : dt['Rating']
                                                                            .toString()
                                                                    : SizedBox(
                                                                        width:
                                                                            0.0,
                                                                        height:
                                                                            0.0),
                                                                textScaleFactor:
                                                                    1.0,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .blueGrey))
                                                          ])))
                                            ]),
                                        const Padding(
                                            padding: EdgeInsets.only(
                                                top: 3.0, bottom: 2.0)),
                                        Text(
                                          dt['Description'],
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textScaleFactor: 1.0,
                                          style: const TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          //price block
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              /*   Text(
                                        '\u20B9 '+dt['Price'].toString(),//dt.data().containsKey('Price') ? dt['Price'] is int ? dt['Price'].toDouble().toString() : dt['Price'].toString() : '-',

                                            textScaleFactor: 1.0,
                                            style: const TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.blueGrey,
                                            ),
                                          ),*/
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Colors.deepOrangeAccent
                                                      .withOpacity(0.2),
                                                ),
                                                padding: EdgeInsets.only(
                                                    left: 10.0,
                                                    right: 10.0,
                                                    top: 1.0,
                                                    bottom: 5.0),
                                                child: Text(dt['ItemCat'],
                                                    textScaleFactor: 1.0,
                                                    style: TextStyle(
                                                        color:
                                                            Colors.pinkAccent,
                                                        fontSize: 10.0,
                                                        fontFamily:
                                                            'Product Sans')),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                '\u20B9 ' +
                                                    dt['Price']
                                                        .toString(), //dt.data().containsKey('Price') ? dt['Price'] is int ? dt['Price'].toDouble().toString() : dt['Price'].toString() : '-',
                                                textScaleFactor: 1.0,
                                                style: const TextStyle(
                                                  fontSize: 18.0,
                                                  color: Colors.lightGreen,
                                                ),
                                              ),
                                              Text(
                                                '\u20B9 ' +
                                                    dt['DeliveryCharges']
                                                        .toString(), //dt.data().containsKey('Price') ? dt['Price'] is int ? dt['Price'].toDouble().toString() : dt['Price'].toString() : '-',
                                                textScaleFactor: 1.0,
                                                style: const TextStyle(
                                                  fontSize: 1.0,
                                                  color: Colors.lightGreen,
                                                ),
                                              ),
                                            ],
                                          ),

                                          dt['Order_Type'] == 'Instant'
                                              ? CartData.getItemCount(dt.id) > 0
                                                  ? Align(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      child: Container(
                                                          width: 100.0,
                                                          height: 30.0,
                                                          margin: EdgeInsets.only(
                                                              bottom: 5.0),
                                                          padding: EdgeInsets.only(
                                                              top: 3.0,
                                                              bottom: 3.0,
                                                              left: 10.0,
                                                              right: 10.0),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      20),
                                                              color: HexColor(
                                                                  '#efefef'),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .black26,
                                                                  blurRadius:
                                                                      1.0,
                                                                )
                                                              ]),
                                                          child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                _decrementButton(
                                                                    dt),
                                                                Text(
                                                                    CartData.getItemCount(dt
                                                                            .id)
                                                                        .toString(),
                                                                    textScaleFactor:
                                                                        1.0,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18.0,
                                                                        color: Colors
                                                                            .blueAccent
                                                                            .shade200)),
                                                                _incrementButton(
                                                                    dt),
                                                              ])))
                                                  : Align(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      child: InkWell(
                                                        child: Container(
                                                            width: 70.0,
                                                            height: 27.0,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    bottom:
                                                                        6.0),
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 3.5,
                                                                    bottom: 2.0,
                                                                    left: 5.0,
                                                                    right:
                                                                        10.0),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                color: Colors
                                                                    .deepOrangeAccent,
                                                                //.shade100,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .white,
                                                                    blurRadius:
                                                                        1.0,
                                                                  )
                                                                ]),
                                                            child: Center(
                                                                child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                  Padding(
                                                                      padding: EdgeInsets.only(
                                                                          bottom:
                                                                              20.0),
                                                                      child: Icon(
                                                                          Icons
                                                                              .add_circle,
                                                                          size:
                                                                              20.0,
                                                                          color: Colors
                                                                              .white
                                                                              .withOpacity(0.3))),
                                                                  Text('ADD',
                                                                      textScaleFactor:
                                                                          1.0,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              13.0,
                                                                          fontFamily:
                                                                              'Product Sans',
                                                                          color:
                                                                              Colors.white))
                                                                ]))),
                                                        onTap: () {
                                                          this.setState(() {
                                                            //  if(dt['Order_Type']=='Pre' && dt['Order_Type'] != 'Instant')
                                                            //  if(CartData.cart.containsValue== null && CartData.cart.containsValue==ChefItemData.availableChefsItems_Instant && CartData.cart.containsValue != ChefItemData.availableChefsItems_Pre)
                                                            //  if(CartData(dt) == )
                                                            CartData
                                                                .increaseItemCount(
                                                                    dt);
                                                            //if(CartData.cart==ChefData.availableChefIDs_Instant && CartData.cart != ChefData.availableChefIDs_Pre)
                                                            CartData
                                                                .callNotifier();
                                                          });
                                                        },
                                                      ))
                                              : dt['Order_Type'] == 'Pre'
                                                  ? CartData.getItemCount(dt.id) >
                                                          0
                                                      ? Align(
                                                          alignment: Alignment
                                                              .bottomRight,
                                                          child: Container(
                                                              width: 100.0,
                                                              height: 30.0,
                                                              margin: EdgeInsets.only(
                                                                  bottom: 5.0),
                                                              padding:
                                                                  EdgeInsets.only(top: 3.0, bottom: 3.0, left: 10.0, right: 10.0),
                                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: HexColor('#efefef'), boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .black26,
                                                                  blurRadius:
                                                                      1.0,
                                                                )
                                                              ]),
                                                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                                _decrementButton(
                                                                    dt),
                                                                Text(
                                                                    CartData.getItemCount(dt
                                                                            .id)
                                                                        .toString(),
                                                                    textScaleFactor:
                                                                        1.0,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18.0,
                                                                        color: Colors
                                                                            .blueAccent
                                                                            .shade200)),
                                                                _incrementButton(
                                                                    dt),
                                                              ])))
                                                      : Align(
                                                          alignment: Alignment.bottomRight,
                                                          child: InkWell(
                                                            child: Container(
                                                                width: 70.0,
                                                                height: 27.0,
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            6.0),
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            3.5,
                                                                        bottom:
                                                                            2.0,
                                                                        left:
                                                                            5.0,
                                                                        right:
                                                                            10.0),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                    color: Colors
                                                                        .deepOrangeAccent,
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .black26,
                                                                        blurRadius:
                                                                            1.0,
                                                                      )
                                                                    ]),
                                                                child: Center(
                                                                    child: Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                      Padding(
                                                                          padding: EdgeInsets.only(
                                                                              bottom:
                                                                                  20.0),
                                                                          child: Icon(
                                                                              Icons.add_circle,
                                                                              size: 20.0,
                                                                              color: Colors.white.withOpacity(0.3))),
                                                                      Text(
                                                                          'ADD',
                                                                          textScaleFactor:
                                                                              1.0,
                                                                          style: TextStyle(
                                                                              fontSize: 13.0,
                                                                              fontFamily: 'Product Sans',
                                                                              color: Colors.white))
                                                                    ]))),
                                                            onTap: () {
                                                              ShowItemDetail(
                                                                  widget.item,
                                                                  availableFrom,
                                                                  availableTo);
                                                              /*     this.setState(() {
                                                    CartData.increaseItemCount(dt);
                                                    CartData.callNotifier();
                                                  }
                                                  );*/
                                                            },
                                                          ))
                                                  : SizedBox()
                                        ]),
                                  ),
                                ],
                              )),
                        )
                      ],
                    ),
                  ));
            }));
  }

  Widget _incrementButton(DocumentSnapshot item) {
    return InkWell(
        onTap: () {
          this.setState(() {
            CartData.increaseItemCount(item);
            CartData.callNotifier();
          });
        },
        child: Icon(Icons.add, color: Colors.blueGrey));
  }

  Widget _decrementButton(DocumentSnapshot item) {
    return InkWell(
      onTap: () {
        this.setState(() {
          CartData.decreaseItemCount(item);
          CartData.callNotifier();
        });
      },
      child: new Icon(Icons.remove, color: Colors.blueGrey),
    );
  }

  refreshItemCard() {
    this.setState(() {});
  }

  Widget ShowItemDetail(
      DocumentSnapshot itm, String availableFrom, String avaialbleTo) {
    try {
      showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50.0), topRight: Radius.circular(50.0)),
        ),
        isScrollControlled: true,
        isDismissible: true,
        backgroundColor: Colors.white.withOpacity(0.0),
        context: context,
        builder: (context) => Container(
            height: MediaQuery.of(context).size.height * 0.90,
            child: Item(
                item: itm,
                availableFrom: availableFrom,
                availableTo: avaialbleTo)),
      );
    } catch (err) {
      print(err.toString());
      return SizedBox();
    }
  }
}
