
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatinom/Pages/App/AppConfig.dart';
import 'package:eatinom/Pages/Orders/OrderMap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderSummary extends StatefulWidget {
  OrderSummary({Key key, this.selectedOrder}) : super(key: key);
  final DocumentSnapshot selectedOrder;
  @override
  OrderSummaryPage createState() => new OrderSummaryPage();
}

class OrderSummaryPage extends State<OrderSummary> {
  @override
  Widget build(BuildContext context) {
    AppConfig.context = context;
    ScreenUtil.init(context);
    ScreenUtil().allowFontScaling = false;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
          color: Colors.blueGrey, //change your color here
        ),
        title: Text("Order Summary",textScaleFactor: 1.0, style: TextStyle(fontFamily: 'Product Sans', color: Colors.blueGrey)),
        backgroundColor: Colors.white,
        //centerTitle: true,
        actions: [
          InkWell(
              child: Container(
                  padding: EdgeInsets.all(20.0),
                  child: Center(child: Text('Help',textScaleFactor: 1.0, style: TextStyle(color: Colors.redAccent, fontFamily: 'Product Sans',fontWeight: FontWeight.w400, fontSize: 15.0)))
              )
          )
        ],
      ),
      body: showBody(),
    );
  }

  Widget showBody(){
    try{
      return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('Order').doc(widget.selectedOrder.id).snapshots(),
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
          DocumentSnapshot order = snapshot.data;
          return Container(
            child: showList(order),
          );
        },
      );
    }
    catch(err){
      return Container(
        child: Center(child: Text('Error while loading page.')),
      );
    }
  }


  Widget showList(DocumentSnapshot order) {

    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Order').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
              height: 300.0,
              child: Center(child: CircularProgressIndicator())
          );
        }
        List<Widget> lst = new List<Widget>();
        lst.add(order['Status'] == 'Confirmed' ? OrderMap(order: order) :  SizedBox(height: 0.0));
        lst.add(Container(
            padding: EdgeInsets.all(20.0),
            color: Colors.white,
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
              Text('Order ID : '+order.id.substring(order.id.length - 10,order.id.length).toUpperCase(),textScaleFactor: 1.0, style: TextStyle(color: Colors.blueGrey.shade300, fontFamily: 'Product Sans', fontSize: 15.0,)),
              Text(order['Placed_On'].toDate().toString().split(' ')[0] +' '+ order['Placed_On'].toDate().toString().split(' ')[1].substring(0,5),textScaleFactor: 1.0, style: TextStyle(color: Colors.blueGrey.shade300, fontFamily: 'Product Sans', fontSize: 15.0,))
            ])
        ));
      /*  snapshot.data.docs.forEach((document) {
          lst.add(showCard(document));
        });*/
        lst.add(showCard());
        lst.add(otpPay());
        lst.add(slots());
        lst.add(totalPay());

        //widget.selectedOrder.data().containsKey('Otp_ID') ? lst.add(otp()) :  SizedBox();
        widget.selectedOrder.data().containsKey('Delivery_Person') ? lst.add(deliveryPerson()) :  SizedBox();
        widget.selectedOrder.data().containsKey('Chef_Phone') ? lst.add(chefPerson()) :  SizedBox();
        widget.selectedOrder.data().containsKey('Delivery_Address') ? lst.add(DeliveryAddress()) :  SizedBox();
        return SingleChildScrollView(
            child: Column(
              children: lst,
            )
        );
      },
    );
  }

  Widget showCard()
  //DocumentSnapshot dt
  {
    try{
      return Container(
        decoration: BoxDecoration(
          //borderRadius: BorderRadius.circular(10),
            color: Colors.white.withOpacity(1.0),
            boxShadow: [BoxShadow(
              color: Colors.black26,
              blurRadius: 0.5,
            )]
        ),
        child: Stack(children: [
          Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
              Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: Center(
                      child: widget.selectedOrder.data().containsKey('ImageStr') ? FittedBox(child: Image.memory(base64Decode(widget.selectedOrder['ImageStr']), height: 90.0,), fit: BoxFit.cover) : Icon(Icons.sort,size: 60.0,color: Colors.blueGrey.shade200,)
                  )
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  padding: EdgeInsets.all(10.0),
                  child: Column(children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(widget.selectedOrder['Item_Name'],textScaleFactor: 1.0, overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.blueGrey, fontFamily: 'Product Sans', fontSize: 17.0,fontWeight: FontWeight.w600)),
                    ),
                    SizedBox(height: 3.0),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Row(children: [
                          Text('HSN : ',textScaleFactor: 1.0, style: TextStyle(color: Colors.blueGrey.shade400, fontFamily: 'Product Sans', fontSize: 12.0)),
                          Text(widget.selectedOrder['HSN'],textScaleFactor: 1.0, style: TextStyle(color: Colors.blueGrey.shade400, fontFamily: 'Product Sans', fontSize: 12.0))
                        ])
                    ),
                    SizedBox(height: 10.0),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                      Text(
                        '\u20B9 '+widget.selectedOrder['Price'].toString(),textScaleFactor: 1.0,
                        style: const TextStyle(
                          fontSize: 20.0,
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                      RichText(textScaleFactor: 1.0,
                          text: TextSpan(
                            text: 'Discount : ',
                            style: TextStyle(fontSize: 14.0,color: Colors.blueGrey.withOpacity(0.7), fontWeight: FontWeight.w400, fontFamily: 'Product Sans'),
                            /*  children: <TextSpan>[
                              TextSpan(text: dt['Quantity'].toString()+'  ', style: TextStyle(fontSize: 16.0,color: Colors.blueGrey,fontWeight: FontWeight.w600)),
                            ],*/
                          )
                      ),
                      RichText(textScaleFactor: 1.0,
                          text: TextSpan(
                            text: 'Quantity : ',
                            style: TextStyle(fontSize: 14.0,color: Colors.blueGrey.withOpacity(0.7), fontWeight: FontWeight.w400, fontFamily: 'Product Sans'),
                            children: <TextSpan>[
                              TextSpan(text: widget.selectedOrder['Quantity'].toString()+'  ', style: TextStyle(fontSize: 16.0,color: Colors.blueGrey,fontWeight: FontWeight.w600)),
                            ],
                          )
                      ),
                    ])

                  ])
              )
            ]),
            widget.selectedOrder['Order_Type'] == 'Pre' && widget.selectedOrder.data().containsKey('Day_Slot') ?
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: HexColor('#F1E9DA'),
                ),
                padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                margin: EdgeInsets.all(10.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                  Text(widget.selectedOrder['Day_Slot'], style: TextStyle(color: Colors.orange)),
                  Text(widget.selectedOrder['Time_Slot'], style: TextStyle(color: Colors.orange))
                ]
                )
            ): SizedBox()
          ]),

          Align(
              alignment: Alignment.topRight,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: widget.selectedOrder['Order_Type'] == 'Instant' ? Colors.blueAccent.withOpacity(0.2) : Colors.deepPurple.withOpacity(0.2),
                ),
                margin: EdgeInsets.only(top: 10.0, right: 10.0),
                padding: EdgeInsets.only(left: 10.0,right: 10.0,top: 5.0,bottom: 5.0),
                child: Text(widget.selectedOrder['Order_Type'],textScaleFactor: 1.0, style: TextStyle(color: widget.selectedOrder['Order_Type'] == 'Instant' ? Colors.blueAccent : Colors.deepPurple, fontSize: 10.0,fontFamily: 'Product Sans')),
              )
          ),
        ]),
      );
    }
    catch(err){
      return SizedBox();
    }
  }


  Widget otpPay(){
    return Align(
        alignment: Alignment.topRight,
        child: Container(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0, bottom: 15.0),
            margin: EdgeInsets.only(top: 1.0),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(1.0),
                boxShadow: [BoxShadow(
                  color: Colors.black26,
                  blurRadius: 0.5,
                )]
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
              Column(
                children: [
                  RichText(textScaleFactor: 1.0,
                      text: TextSpan(
                        text: 'OTP : ',
                        style: TextStyle(fontSize: 15.0,color: Colors.blueGrey.withOpacity(0.7), fontWeight: FontWeight.w600),
                        children: <TextSpan>[
                          TextSpan(text:widget.selectedOrder['Otp_ID'].toString(), style: TextStyle(fontSize: 16.0,color: Colors.blueGrey,fontWeight: FontWeight.w600)),
                        ],
                      )
                  ),
                ],
              ),
            ])
        )
    );
  }

  Widget slots(){
    return   Align(
        alignment: Alignment.topRight,
        child:  Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white12,
              //HexColor('#F1E9DA'),
            ),
            padding: EdgeInsets.only(left: 20.0, right: 10.0, top: 5.0, bottom: 5.0),
            margin: EdgeInsets.all(1.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
              Text('Date :     '+widget.selectedOrder['Day_Slot'], style: TextStyle(color: Colors.orange)),
              Text('Time :     '+widget.selectedOrder['Time_Slot'], style: TextStyle(color: Colors.orange))
            ]
            )
        ),
    );
  }

  Widget totalPay(){
    return Align(
        alignment: Alignment.topRight,
        child: Container(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0, bottom: 15.0),
            margin: EdgeInsets.all(1.0),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(1.0),
                boxShadow: [BoxShadow(
                  color: Colors.black26,
                  blurRadius: 0.5,
                )]
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
              Column(
                children: [
                  RichText(textScaleFactor: 1.0,
                      text: TextSpan(
                        text: 'Total Amount         : ',
                        style: TextStyle(fontSize: 15.0,color: Colors.blueGrey.withOpacity(0.7), fontWeight: FontWeight.w600),
                        children: <TextSpan>[
                          TextSpan(text: '\u20B9 '+widget.selectedOrder['Total_Amount'].toString(), style: TextStyle(fontSize: 16.0,color: Colors.blueGrey,fontWeight: FontWeight.w600)),
                        ],
                      )
                  ),
                  RichText(textScaleFactor: 1.0,
                      text: TextSpan(
                        text: 'Delivery charges : ',
                        style: TextStyle(fontSize: 15.0,color: Colors.blueGrey.withOpacity(0.7), fontWeight: FontWeight.w600),
                        children: <TextSpan>[
                          TextSpan(text: '\u20B9 '+widget.selectedOrder['Delivery_Charges'].toString(), style: TextStyle(fontSize: 16.0,color: Colors.blueGrey,fontWeight: FontWeight.w600)),
                        ],
                      )
                  ),

                      RichText(textScaleFactor: 1.0,
                          text: TextSpan(
                            text: 'cgst                     : ',
                            style: TextStyle(fontSize: 15.0,color: Colors.blueGrey.withOpacity(0.7), fontWeight: FontWeight.w600),
                            children: <TextSpan>[
                              TextSpan(text: '\u20B9 '+widget.selectedOrder['CSGT'].toString(), style: TextStyle(fontSize: 16.0,color: Colors.blueGrey,fontWeight: FontWeight.w600)),
                            ],
                          )
                      ),
                      SizedBox(width: 20,),
                      RichText(textScaleFactor: 1.0,
                          text: TextSpan(
                            text: 'sgst                     : ',
                            style: TextStyle(fontSize: 15.0,color: Colors.blueGrey.withOpacity(0.7), fontWeight: FontWeight.w600),
                            children: <TextSpan>[
                              TextSpan(text: '\u20B9 '+widget.selectedOrder['SGST'].toString(), style: TextStyle(fontSize: 16.0,color: Colors.blueGrey,fontWeight: FontWeight.w600)),
                            ],
                          )
                      ),

                ],
              ),

              Row(children: [
                Text('Paid Online',textScaleFactor: 1.0, style: TextStyle(color: Colors.green, fontSize: 16.0, fontFamily: 'Product Sans')),
                SizedBox(width: 5.0),
                Icon(Icons.assignment_turned_in_sharp, color: Colors.green,size: 20.0),
              ]
              )
            ])

        )
    );
  }

  Widget deliveryPerson(){

    return Container(
        margin: EdgeInsets.only(top: 20.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(
              color: Colors.black26,
              blurRadius: 1.0,
            )]
        ),
        child: Column(children: [
          Align(alignment: Alignment.topLeft,child: Container(padding: EdgeInsets.only(left: 10.0, top: 5.0),child: Text('Delivery Person',textScaleFactor: 1.0, style: TextStyle(color: Colors.teal.shade200, fontFamily: 'Product Sans', fontSize: 14.0)))),
          SizedBox(height: 3.0),
          Container(
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white.withOpacity(1),
                  boxShadow: [BoxShadow(
                    color: Colors.black26,
                    blurRadius: 1.0,
                  )]
              ),
              child: ListTile(
                leading: Padding(padding: EdgeInsets.only(top: 8.0, left: 5.0),child: Icon(Icons.person)),
                title: Text(widget.selectedOrder['Delivery_Person'],textScaleFactor: 1.0, style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w600)),
                subtitle: Text(widget.selectedOrder['Delivery_Person_Content'],textScaleFactor: 1.0,overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.blueGrey)),
                trailing: Container(
                    padding: EdgeInsets.all(0.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue.shade50,
                        boxShadow: [BoxShadow(
                          color: Colors.black26,
                          blurRadius: 1.0,
                        )]
                    ),
                    child: IconButton(
                      icon: Icon(Icons.call, size: 20.0, color: Colors.blue),
                      onPressed: (){
                        _launchCaller(widget.selectedOrder['Delivery_Person_Phone']);
                      },
                    )
                ),
              )
          )
        ])
    );
  }

  Widget chefPerson(){

    return Container(
        margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(
              color: Colors.black26,
              blurRadius: 1.0,
            )]
        ),
        child: Column(children: [
          Align(alignment: Alignment.topLeft,child: Container(padding: EdgeInsets.only(left: 10.0, top: 5.0),child: Text('Chef Info',textScaleFactor: 1.0, style: TextStyle(color: Colors.teal.shade200, fontFamily: 'Product Sans', fontSize: 14.0)))),
          SizedBox(height: 3.0),
          Container(
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white.withOpacity(1),
                  boxShadow: [BoxShadow(
                    color: Colors.black26,
                    blurRadius: 1.0,
                  )]
              ),
              child: ListTile(
                leading: Padding(padding: EdgeInsets.only(top: 8.0, left: 5.0),child: Icon(Icons.person)),
                title: Text(widget.selectedOrder['Chef_Name'],textScaleFactor: 1.0, style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w600)),
                subtitle: Text(widget.selectedOrder['Chef_Phone'],textScaleFactor: 1.0, style: TextStyle(color: Colors.blueGrey)),
                trailing: Container(
                    padding: EdgeInsets.all(0.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue.shade50,
                        boxShadow: [BoxShadow(
                          color: Colors.black26,
                          blurRadius: 1.0,
                        )]
                    ),
                    child: IconButton(
                      icon: Icon(Icons.call, size: 20.0, color: Colors.blue),
                      onPressed: (){
                        _launchCaller(widget.selectedOrder['Chef_Phone']);
                      },
                    )
                ),
              )
          )
        ])
    );
  }

  Widget DeliveryAddress(){

    return Container(
        margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(
              color: Colors.black26,
              blurRadius: 1.0,
            )]
        ),
        child: Column(children: [
          Align(alignment: Alignment.topLeft,child: Container(padding: EdgeInsets.only(left: 10.0, top: 5.0),child: Text('Delivery Address',textScaleFactor: 1.0, style: TextStyle(color: Colors.teal.shade200, fontFamily: 'Product Sans', fontSize: 14.0)))),
          SizedBox(height: 5.0),
          Container(
            margin: EdgeInsets.all(10.0),

            child: Container(
                color: Colors.blue.shade50,
                padding: EdgeInsets.all(10.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.10,
                      child: Image.asset('assets/home.png', height: 24.0,width: 24.0),
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.72,
                      child: Text(AppConfig.currentAddress,textScaleFactor: 1.0,maxLines: 3, softWrap: true,overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.blueGrey.shade300,fontSize: 14.0,fontFamily: 'Product Sans')
                      )
                  ),
                ])
            ),
          )
        ])
    );
  }

  _launchCaller(String Phone) async {
    String url = "tel:"+Phone;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


}


