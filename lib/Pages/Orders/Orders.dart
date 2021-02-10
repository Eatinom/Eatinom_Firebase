
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatinom/Pages/App/AppConfig.dart';
import 'package:eatinom/Pages/Index/helper.dart';
import 'package:eatinom/Pages/Orders/OrderSummary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Orders extends StatefulWidget {
  Orders({Key key, this.title}) : super(key: key);
  final String title;

  @override
  OrdersPage createState() => new OrdersPage();
}

class OrdersPage extends State<Orders>{

  String filterBy = 'All';
 // var v =int.parse('order.id.substring(order.id.length - 10,order.id.length).toUpperCase()');

  @override
  Widget build(BuildContext context) {
    AppConfig.context = context;

    ScreenUtil.init(context);
    ScreenUtil().allowFontScaling = false;



    return WillPopScope(

        child: Scaffold(
          backgroundColor: Colors.blue.withOpacity(0.03),
          body: Container(
              child: Stack(children: [
                Container(
                    margin: EdgeInsets.only(top: 50.0),
                    child: ordersList()
                ),
                Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                        padding: EdgeInsets.only(right: 15.0, top: 0.0),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                          Padding(padding: EdgeInsets.only(left: 15.0), child: Text('Previous Orders',textScaleFactor: 1.0, style: TextStyle(color: Colors.black.withOpacity(0.4), fontSize: 18.0, fontFamily: 'Product Sans'))),

                          filterBox()
                        ])

                    )
                )
              ])
          ),
        ), onWillPop: Helper.of(context).onWillPop);


  }

  Widget orderCard2(DocumentSnapshot order){
    try{

      return InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => OrderSummary(selectedOrder: order)));
          },
          child: Stack(children: [
            Container(
              margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                  boxShadow: [BoxShadow(
                    color: Colors.black45,
                    blurRadius: 1.0,
                  )]
              ),
              child: Column(children: [

                Container(
                    height: 32.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0), topRight: Radius.circular(5.0)),
                      color: Colors.blueGrey.shade50,
                    ),
                    padding: EdgeInsets.only(left: 10.0,right: 10.0,),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                     // Text('Order ID : '+v.toString(),overflow: TextOverflow.ellipsis,textScaleFactor: 1.0, style: TextStyle(color: Colors.blueGrey,fontSize: 15.0,fontFamily: 'Product Sans',fontWeight: FontWeight.w600)),
                   Text('Order ID : '+order.id.substring(order.id.length - 10,order.id.length).toUpperCase(),overflow: TextOverflow.ellipsis,textScaleFactor: 1.0, style: TextStyle(color: Colors.blueGrey,fontSize: 15.0,fontFamily: 'Product Sans',fontWeight: FontWeight.w600)),
                     // Text(order['Status'], style: TextStyle(color: Colors.deepOrangeAccent,fontSize: 15.0,fontFamily: 'Product Sans')),

                      SizedBox()
                    ]
                    )
                ),


                Container(
                  padding: EdgeInsets.all(5.0),
                  child: ListTile(
                    leading: Icon(Icons.receipt_long_sharp, size: 40.0,color: Colors.blueGrey.shade200,),
                    title: Text(order['Chef_Name'].toString(),textScaleFactor: 1.0,overflow: TextOverflow.ellipsis,maxLines: 1, style: TextStyle(color: Colors.blueGrey,fontSize: 16.0,fontFamily: 'Product Sans', fontWeight: FontWeight.w600)),
                    subtitle: Text(order['Delivery_Address'],textScaleFactor: 1.0,overflow: TextOverflow.ellipsis,maxLines: 1, style: TextStyle(color: Colors.black45,fontSize: 14.0, fontFamily: 'Product Sans')),
                    trailing: Icon(Icons.arrow_forward_ios_sharp, color: Colors.blueGrey.shade100,size: 20.0,),
                  ),
                ),

                Container(
                    padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 15.0, right: 15.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12)
                    ),
                    width: double.infinity,
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                      Text(order['Status'],textScaleFactor: 1.0, style: TextStyle(color: order['Status'] == 'Delivered' ? Colors.green : Colors.deepOrangeAccent, fontFamily: 'Product Sans')),
                      Text(order['Placed_On'].toDate().toString().split(' ')[0] +' '+ order['Placed_On'].toDate().toString().split(' ')[1].substring(0,5),textScaleFactor: 1.0, style: TextStyle(color: Colors.blueGrey.shade300, fontFamily: 'Product Sans')),
                    ])

                )

              ]),
            ),

            Align(
                alignment: Alignment.topRight, child: Container(
               margin: EdgeInsets.only(top: 25.0,right: 25.0),
              //padding: EdgeInsets.only(left: 10.0, right: 0.0, top: 0.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                  SizedBox(),
                  Row(children: [
                    order['Order_Type'].contains('Pre') ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.deepPurple.withOpacity(0.2),
                      ),
                      padding: EdgeInsets.only(left: 10.0,right: 10.0,top: 5.0,bottom: 5.0),
                      child: Text('Pre',textScaleFactor: 1.0, style: TextStyle(color: Colors.deepPurple, fontSize: 10.0,fontFamily: 'Product Sans')),
                    ) : SizedBox(height: 0.0,width: 0.0),
                    SizedBox(width: 10.0),
                    order['Order_Type'].contains('Instant') ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.blueAccent.withOpacity(0.2),
                      ),
                      padding: EdgeInsets.only(left: 10.0,right: 10.0,top: 5.0,bottom: 5.0),
                      child: Text('Instant',textScaleFactor: 1.0, style: TextStyle(color: Colors.blueAccent, fontSize: 10.0,fontFamily: 'Product Sans')),
                    ) : SizedBox(height: 0.0,width: 0.0),
                  ])
                ])
            )
            )
          ])


      );
    }
    catch(err){
      print(err.toString());
      return SizedBox();
    }
  }

  Widget filterBox(){
    return DropdownButton<String>(
      items: <String>['All','Confirmed', 'Delivered', 'Cancelled'].map((String value) {
        return new DropdownMenuItem<String>(
          value: value,
          child: new Text(value,textScaleFactor: 1.0, style: TextStyle(color: Colors.black.withOpacity(0.4))),
        );
      }).toList(),
      onChanged: (value) {
        this.setState(() {
          filterBy = value;
        });
      },
      icon: Icon(Icons.filter_alt_sharp, color: Colors.black.withOpacity(0.4),size: 20.0,),
      value: filterBy,
    );
  }

  Widget ordersList(){
    try{
      CollectionReference orders = FirebaseFirestore.instance.collection('Order');
      var query;
      if(filterBy == 'All'){
        print('if-- ');
        query = orders.where('Customer_ID', isEqualTo: AppConfig.userID).orderBy('Placed_On', descending: true).snapshots();
      }else{
        print('else');
        query = orders.where('Customer_ID', isEqualTo: AppConfig.userID).where('Status', isEqualTo: filterBy).snapshots();
      }


      return SingleChildScrollView(
        padding: EdgeInsets.only(top: 10.0, bottom: 30.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: query,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(height: MediaQuery.of(context).size.height - (AppBar().preferredSize.height - kToolbarHeight + 200),child: Center(child: CircularProgressIndicator()));
            }

            List<Widget> lst = new List<Widget>();
            if(snapshot.hasData && snapshot.data.docs.length > 0){
              snapshot.data.docs.forEach((doc) {
                lst.add(orderCard2(doc));
              });
            }
            return Column(
              children: lst,
            );
          }
        )
      );
    }
    catch(err){
      print(err.toString());
      return Container(height: 300.0,child: Center(child: Text('Error while loading previous orders. ',textScaleFactor: 1.0, style: TextStyle(color: Colors.redAccent, fontSize: 16.0,fontFamily: 'Product Sans'),)));
    }
  }





}