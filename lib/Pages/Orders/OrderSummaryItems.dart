import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderSummaryItems extends StatefulWidget{
  OrderSummaryItems({Key key, this.order}) : super(key: key);
  final DocumentSnapshot order;
  @override
  OrderSummaryItemsState createState() => new OrderSummaryItemsState();
}

class OrderSummaryItemsState extends State<OrderSummaryItems>{
  @override
  Widget build(BuildContext context) {
    CollectionReference items = FirebaseFirestore.instance.collection('Order/'+widget.order.id+'/Items');

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Order/'+widget.order.id).snapshots(),
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


        snapshot.data.docs.forEach((document) {
          lst.add(showCard(document));
        });
        lst.add(totalPay());

        widget.order.data().containsKey('Delivery_Person') ? lst.add(deliveryPerson()) :  SizedBox();
        widget.order.data().containsKey('Chef_Phone') ? lst.add(chefPerson()) :  SizedBox();
        return ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: lst,
        );
      },
    );
  }


  Widget showCard(DocumentSnapshot dt){
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
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.25,
              child: Center(
                  child: dt.data().containsKey('ImageStr') ? FittedBox(child: Image.memory(base64Decode(dt['ImageStr']), height: 90.0,), fit: BoxFit.cover) : Icon(Icons.sort,size: 60.0,color: Colors.blueGrey.shade200,)
              )
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              padding: EdgeInsets.all(10.0),
              child: Column(children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(dt['Item_Name'], overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.blueGrey, fontFamily: 'Product Sans', fontSize: 17.0,fontWeight: FontWeight.w600)),
                ),
                SizedBox(height: 3.0),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Row(children: [
                      Text('HSN : ', style: TextStyle(color: Colors.blueGrey.shade400, fontFamily: 'Product Sans', fontSize: 12.0)),
                      Text(dt['HSN'], style: TextStyle(color: Colors.blueGrey.shade400, fontFamily: 'Product Sans', fontSize: 12.0))
                    ])
                ),
                SizedBox(height: 10.0),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                  Text(
                    '\u20B9 '+dt['Price'].toString(),
                    style: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.deepOrangeAccent,
                    ),
                  ),
                  RichText(
                      text: TextSpan(
                        text: 'Quantity : ',
                        style: TextStyle(fontSize: 14.0,color: Colors.blueGrey.withOpacity(0.7), fontWeight: FontWeight.w400, fontFamily: 'Product Sans'),
                        children: <TextSpan>[
                          TextSpan(text: dt['Quantity'].toString()+'  ', style: TextStyle(fontSize: 16.0,color: Colors.blueGrey,fontWeight: FontWeight.w600)),
                        ],
                      )
                  ),
                ])

              ])
            )
          ]),
          Align(
              alignment: Alignment.topRight,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: dt['Order_Type'] == 'Instant' ? Colors.blueAccent.withOpacity(0.2) : Colors.deepPurple.withOpacity(0.2),
                ),
                margin: EdgeInsets.only(top: 10.0, right: 10.0),
                padding: EdgeInsets.only(left: 10.0,right: 10.0,top: 5.0,bottom: 5.0),

                child: Text(dt['Order_Type'], style: TextStyle(color: dt['Order_Type'] == 'Instant' ? Colors.blueAccent : Colors.deepPurple, fontSize: 10.0,fontFamily: 'Product Sans')),
              )
          ),
        ]),
      );
    }
    catch(err){
      return SizedBox();
    }
  }

  Widget totalPay(){
    return Align(
        alignment: Alignment.topRight,
        child: Container(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0, bottom: 15.0),
            margin: EdgeInsets.only(top: 20.0),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(1.0),
                boxShadow: [BoxShadow(
                  color: Colors.black26,
                  blurRadius: 0.5,
                )]
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
              RichText(
                  text: TextSpan(
                    text: 'Total Amount : ',
                    style: TextStyle(fontSize: 15.0,color: Colors.blueGrey.withOpacity(0.7), fontWeight: FontWeight.w600),
                    children: <TextSpan>[
                      TextSpan(text: '\u20B9 '+widget.order['Total_Amount'].toString(), style: TextStyle(fontSize: 16.0,color: Colors.blueGrey,fontWeight: FontWeight.w600)),
                    ],
                  )
              ),

              Row(children: [
                Text('Paid Online', style: TextStyle(color: Colors.green, fontSize: 16.0, fontFamily: 'Product Sans')),
                SizedBox(width: 5.0),
                Icon(Icons.assignment_turned_in_sharp, color: Colors.green,size: 20.0),
              ])


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
        Align(alignment: Alignment.topLeft,child: Container(padding: EdgeInsets.only(left: 10.0, top: 5.0),child: Text('Delivery Person', style: TextStyle(color: Colors.teal.shade200, fontFamily: 'Product Sans', fontSize: 13.0)))),
        SizedBox(height: 5.0),
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
              title: Text(widget.order['Delivery_Person'], style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w600)),
              subtitle: Text(widget.order['Delivery_Person_Content'], style: TextStyle(color: Colors.blueGrey)),
              trailing: Container(
                  padding: EdgeInsets.all(0.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.blue.shade50,
                      boxShadow: [BoxShadow(
                        color: Colors.black26,
                        blurRadius: 1.0,
                      )]
                  ),
                  child: IconButton(
                    icon: Icon(Icons.call, size: 20.0, color: Colors.blue),
                    onPressed: _launchCaller,
                  )
              ),
            )
        )
      ])
    );
  }

  Widget chefPerson(){

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
          Align(alignment: Alignment.topLeft,child: Container(padding: EdgeInsets.only(left: 10.0, top: 5.0),child: Text('Chef Info', style: TextStyle(color: Colors.teal.shade200, fontFamily: 'Product Sans', fontSize: 13.0)))),
          SizedBox(height: 5.0),
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
                title: Text(widget.order['Chef_Name'], style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w600)),
                subtitle: Text(widget.order['Chef_Phone'], style: TextStyle(color: Colors.blueGrey)),
                trailing: Container(
                    padding: EdgeInsets.all(0.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.blue.shade50,
                        boxShadow: [BoxShadow(
                          color: Colors.black26,
                          blurRadius: 1.0,
                        )]
                    ),
                    child: IconButton(
                      icon: Icon(Icons.call, size: 20.0, color: Colors.blue),
                      onPressed: _launchCaller,
                    )
                ),
              )
          )
        ])
    );
  }

  _launchCaller() async {
    String url = "tel:"+widget.order['Delivery_Person_Phone'].toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}