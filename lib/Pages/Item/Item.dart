import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:eatinom/DataNotifier/CartData.dart';
import 'package:eatinom/DataNotifier/ChefData.dart';
import 'package:eatinom/Pages/App/AppConfig.dart';
import 'package:eatinom/Pages/Cart/Cart.dart';
import 'package:eatinom/Pages/Cart/CartHolder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class Item extends StatefulWidget {
  Item({Key key, this.item, this.availableFrom, this.availableTo})
      : super(key: key);
  final DocumentSnapshot item;
  String availableFrom, availableTo;
  @override
  ItemPage createState() => new ItemPage();
}

class ItemPage extends State<Item> with AutomaticKeepAliveClientMixin<Item> {
  @override
  bool get wantKeepAlive => true;

  var slots = [
    '07:00 AM',
    '07:30 AM',
    '08:00 AM',
    '08:30 AM',
    '09:00 AM',
    '09:30 AM',
    '10:00 AM',
    '10:30 AM',
    '11:00 AM',
    '11:30 AM',
    '12:00 PM',
    '12:30 PM',
    '01:00 PM',
    '01:30 PM',
    '02:00 PM',
    '02:30 PM',
    '03:00 PM',
    '03:30 PM',
    '04:00 AM',
    '04:30 PM',
    '05:00 PM',
    '05:30 PM',
    '06:00 PM',
    '06:30 PM',
    '07:00 PM',
    '07:30 PM',
    '08:00 PM',
    '08:30 PM',
    '09:00 PM',
    '09:30 PM',
    '10:00 PM',
    '10:30 PM',
    '11:00 PM',
    '11:30 PM',
    '12:00 AM',
    '12:30 AM',
    '01:00 AM',
    '01:30 AM',
    '02:00 AM',
    '02:30 AM',
    '03:00 AM',
    '03:30 AM',
    '04:00 AM',
    '04:30 AM',
    '05:00 AM',
    '05:30 AM',
    '06:00 AM',
    '06:30 AM'
  ];

  String selectedTimeSlot = '09:00 AM';
  DateTime selectedDaySlot = DateTime.now();

  // .add(new Duration(days: 0))
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    ScreenUtil().allowFontScaling = false;

    AppConfig.context = context;
    DocumentSnapshot item = widget.item;

    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.white.withOpacity(0.0),
      child: Stack(
        children: [
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  padding: EdgeInsets.only(
                    top: 100.0,
                  ),
                  height: ((MediaQuery.of(context).size.height * 0.90) - 60.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40)),
                    color: Colors.blueGrey.shade50,
                  ),
                  child: SingleChildScrollView(
                      child: Column(children: [
                    Container(
                        padding: EdgeInsets.only(
                            top: 8.0, bottom: 8.0, left: 15.0, right: 15.0),
                        color: Colors.blueGrey.withOpacity(0.1),
                        width: double.infinity,
                        child: Text("Item Details",
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                fontSize: 17.0,
                                height: 1.3,
                                color: HexColor('#55A47E'),
                                fontFamily: 'Product Sans',
                                fontWeight: FontWeight.w500))),
                    CartData.getItemCount(item.id) > 0
                        ? Container(
                            padding: EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                top: 10.0,
                                bottom: 10.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Quantity',
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontFamily: 'Product Sans',
                                          fontSize: 18.0)),
                                  Container(
                                      width: 120.0,
                                      height: 35.0,
                                      padding: EdgeInsets.only(
                                          top: 5.0,
                                          bottom: 5.0,
                                          left: 10.0,
                                          right: 10.0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: HexColor('#efefef'),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 1.0,
                                            )
                                          ]),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            _decrementButton(item),
                                            Text(
                                              CartData.getItemCount(item.id)
                                                  .toString(),
                                              textScaleFactor: 1.0,
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: Colors
                                                      .blueAccent.shade200),
                                            ),
                                            _incrementButton(item),
                                          ]))
                                ]))
                        : SizedBox(),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 20.0, right: 20.0, bottom: 10.0, top: 10.0),
                          child: Text('Description',
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontFamily: 'Product Sans',
                                  fontSize: 18.0)),
                        )),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 20.0, right: 20.0, bottom: 10.0, top: 10.0),
                          child: Text(item['Description'],
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  color: Colors.blueGrey.withOpacity(0.8),
                                  fontFamily: 'Product Sans',
                                  fontSize: 14.0)),
                        )),
                    /* Container(
                            padding: EdgeInsets.only(left: 20.0, right: 20.0,bottom: 10.0),
                            child: Text(item['Description'],textScaleFactor: 1.0, style: TextStyle(color: Colors.blueGrey.withOpacity(0.8),fontFamily: 'Product Sans',fontSize: 14.0))
                        ),*/

                    item['Order_Type'] == 'Pre'
                        ? Container(
                            padding: EdgeInsets.only(
                                top: 8.0, bottom: 8.0, left: 15.0, right: 15.0),
                            color: Colors.blueGrey.withOpacity(0.1),
                            width: double.infinity,
                            child: Text("Slot Details",
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    fontSize: 17.0,
                                    height: 1.3,
                                    color: HexColor('#55A47E'),
                                    fontFamily: 'Product Sans',
                                    fontWeight: FontWeight.w500)))
                        : SizedBox(),
                    item['Order_Type'] == 'Pre'
                        ? Container(
                            padding: EdgeInsets.only(
                                left: 10.0, top: 20.0, bottom: 10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                DatePicker(
                                  DateTime.now(),
                                  //.add(new Duration(days: 1)),
                                  daysCount: 10,
                                  initialSelectedDate: selectedDaySlot,
                                  selectionColor: Colors.orange.shade300,
                                  selectedTextColor: Colors.white,
                                  onDateChange: (date) {
                                    // New date selected
                                    setState(() {
                                      // _selectedValue = date;
                                      selectedDaySlot = date;
                                      this.setState(() {});
                                    });
                                  },
                                ),
                              ],
                            ))
                        : SizedBox(),
                    item['Order_Type'] == 'Pre' ? timeSlots() : SizedBox(),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                        padding: EdgeInsets.only(
                            top: 8.0, bottom: 8.0, left: 15.0, right: 15.0),
                        color: Colors.blueGrey.withOpacity(0.1),
                        width: double.infinity,
                        child: Text("Chef Details",
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                fontSize: 17.0,
                                height: 1.3,
                                color: HexColor('#55A47E'),
                                fontFamily: 'Product Sans',
                                fontWeight: FontWeight.w500))),
                    Container(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 10.0, left: 20.0, right: 15.0),
                        child: Row(children: [
                          Padding(
                              padding: EdgeInsets.only(right: 20.0),
                              child: Icon(
                                Icons.person,
                                size: 20.0,
                                color: Colors.blueGrey,
                              )),
                          Text(item['Chef_Name'],
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 17.0,
                                  fontFamily: 'Product Sans'))
                        ])),
                    Container(
                        padding: EdgeInsets.only(
                            top: 10.0, bottom: 5.0, left: 20.0, right: 15.0),
                        child: Row(children: [
                          Padding(
                              padding: EdgeInsets.only(right: 20.0),
                              child: Icon(
                                Icons.timer,
                                size: 20.0,
                                color: Colors.blueGrey,
                              )),
                          Text(item['Preparation_Time_Display'],
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 17.0,
                                  fontFamily: 'Product Sans'))
                        ])),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            padding: EdgeInsets.only(left: 60),
                            child: Text('Item Preparation Time',
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    color: Colors.blueGrey.withOpacity(0.7),
                                    fontSize: 15.0,
                                    fontFamily: 'Product Sans')))),
                    SizedBox(height: 100.0)
                  ])))),

          //top icon
          Align(
              alignment: Alignment.topCenter,
              child: Container(
                  height: 150,
                  //color: Colors.blueGrey,
                  child: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                        Container(
                          height: 90,
                          width: 90,
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: HexColor('#efefef'),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 2.0,
                                )
                              ]),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.memory(
                                base64Decode(widget.item['ImageStr']),
                                width: 200,
                                height: 400,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),

                          /*FittedBox(
                                child: Image.memory(base64Decode(
                                  //  widget.item['ImageStr']
                                )), fit: BoxFit.cover)*/
                        ),
                        Container(
                            height: 22.0,
                            padding: EdgeInsets.only(top: 0.0, bottom: 0.0),
                            child: Center(
                                child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(item['Name'],
                                        textScaleFactor: 1.0,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20.0,
                                            fontFamily: 'Product Sans'))))),
                        Container(
                            height: 18.0,
                            padding: EdgeInsets.only(bottom: 0.0),
                            child: Center(
                                child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(item['ItemCat'],
                                        textScaleFactor: 1.0,
                                        style: TextStyle(
                                            color: Colors.black45,
                                            fontSize: 15.0,
                                            fontFamily: 'Product Sans')))))
                      ])))),

          Align(
              alignment: Alignment.bottomCenter,
              child: CartData.getItemCount(item.id) > 0
                  ? ViewToCartButton(item)
                  : AddToCartButton(item))
        ],
      ),
    );
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

  Widget AddToCartButton(DocumentSnapshot item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      constraints: const BoxConstraints(maxWidth: 500),
      child: RaisedButton(
        onPressed: () {
          this.setState(() {
            CartData.increaseItemCount(item);
            CartHolder hld = CartData.getCartItem(item.id);
            hld.daySlot = selectedDaySlot;
            hld.timeSlot = selectedTimeSlot;
            CartData.setCartItem(hld);
            // if(CartData.cart==ChefData.availableChefIDs_Pre && CartData.cart != ChefData.availableChefIDs_Instant)
            CartData.callNotifier();
          });
        },
        color: Colors.green,
        //teal.shade300,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14))),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Text(
                    '\u20B9 ' + item['Price'].toString(),
                    textScaleFactor: 1.0,
                    style: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  )),
              Text('Add to Cart',
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17.0,
                      fontFamily: 'Product Sans'))
            ],
          ),
        ),
      ),
    );
  }

  Widget ViewToCartButton(DocumentSnapshot item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      constraints: const BoxConstraints(maxWidth: 500),
      child: RaisedButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Cart()));
        },
        color: Colors.green,
        //teal.shade300,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14))),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'View Cart',
                textAlign: TextAlign.center,
                textScaleFactor: 1.0,
                style: TextStyle(color: Colors.white, fontSize: 17.0),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: Colors.black12,
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 16,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget timeSlots() {
    try {
      DateTime now = DateTime.now();
      String minute = "00 ";
      String time = DateFormat("hh:mm a").format(now).toString();
      if (int.parse(time.substring(3, 5)) <= 30) {
        minute = "00 ";
      } else {
        minute = "30 ";
      }
      String currentTime = time.substring(0, 3) + minute + time.substring(6, 8);
      List<Widget> lst = new List<Widget>();
      int value, to, currentFormat;
      if (slots.contains(widget.availableFrom.toString())) {
        value = slots.indexOf(widget.availableFrom.toString());
        value = value + 6;
      }
      if (slots.contains(widget.availableTo.toString())) {
        to = slots.indexOf(widget.availableTo.toString());
      }

      currentFormat = slots.indexOf(currentTime);

      for (int i = value; i < slots.length; i++) {
        if (i <= to && i >= currentFormat) {
          lst.add(InkWell(
            child: Container(
                margin: EdgeInsets.all(5.0),
                padding: EdgeInsets.only(
                    top: 5.0, bottom: 5.0, left: 15.0, right: 15.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: selectedTimeSlot == slots[i]
                        ? Colors.orange.shade300
                        : HexColor('#efefef'),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 1.0,
                      )
                    ]),
                child: Center(
                    child: Text(slots[i],
                        style: TextStyle(
                            color: selectedTimeSlot == slots[i]
                                ? Colors.white
                                : Colors.blueGrey,
                            fontSize: 14.0,
                            fontFamily: 'Product Sans')))),
            onTap: () {
              selectedTimeSlot = slots[i];
              this.setState(() {});
            },
          ));
        }
      }
      if (widget.availableFrom == null) {
        slots.forEach((element) {
          lst.add(InkWell(
            child: Container(
                margin: EdgeInsets.all(5.0),
                padding: EdgeInsets.only(
                    top: 5.0, bottom: 5.0, left: 15.0, right: 15.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: selectedTimeSlot == element
                        ? Colors.orange.shade300
                        : HexColor('#efefef'),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 1.0,
                      )
                    ]),
                child: Center(
                    child: Text(element,
                        style: TextStyle(
                            color: selectedTimeSlot == element
                                ? Colors.white
                                : Colors.blueGrey,
                            fontSize: 14.0,
                            fontFamily: 'Product Sans')))),
            onTap: () {
              selectedTimeSlot = element;
              this.setState(() {});
            },
          ));
        });
      }

      return SingleChildScrollView(
          padding: EdgeInsets.only(left: 10.0, top: 10.0),
          scrollDirection: Axis.horizontal,
          child: Row(children: lst));
    } catch (err) {
      return SizedBox();
    }
  }
}
