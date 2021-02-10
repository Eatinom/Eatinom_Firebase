import 'package:eatinom/Pages/Cart/Cart.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';


class Coupons extends StatelessWidget {
  TextEditingController textFieldController = TextEditingController();
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CouponPage(),
     // debugShowCheckedModeBanner: false,
    );
  }
}

class CouponPage extends StatelessWidget {

  const CouponPage({Key key, this.title, TextStyle style, double textScaleFactor,}) : super(key: key);


  final String title;

  Widget _buildListItem(BuildContext context, DocumentSnapshot document ){
    return ListTile(
    //  margin: EdgeInsets.only(left: 220.0, right: 5.0, top: 0.0,bottom: 10.0),
      title: Row(
        children: [
Align(
  alignment: Alignment.bottomLeft,
  child :
  Column(
    children: [
      Expanded(
        child: Text(
          document['Coupon_Code'],
          // style: Theme.of(context).textTheme.headline,
        ),
      ),
      Container(
        /*      decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue.shade50,
                    boxShadow: [BoxShadow(
                      color: Colors.black26,
                      blurRadius: 1.0,
                    )]
                ),*/
        padding: const EdgeInsets.all(10.0),
        child:
        Text('\u20B9 '+document['Discount'].toString(),
          // style: Theme.of(context).textTheme.display1,

        ),
      ),
    ],
  ),
),


          Align(
            //alignment: Alignment.bottomRight,
            child :    Container(
              padding: const EdgeInsets.fromLTRB(20, 2, 20, 2),
              margin: EdgeInsets.only(left: 220.0, right: 5.0, top: 0.0,bottom: 10.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue.shade50,
                  boxShadow: [BoxShadow(
                    color: Colors.black26,
                    blurRadius: 1.0,
                  )]
              ),
              child:
              Text('apply'
                // style: Theme.of(context).textTheme.display1,
              ),


            ),
          ),

          /*     InkWell(
            onTap: (){
            //  applyCouponCode();

            },
                 child: Container(
                      margin: EdgeInsets.all(10.0),
                      padding: EdgeInsets.only(left: 20.0, right: 20.0,top: 5.0,bottom: 5.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.deepOrange.shade50,
                          boxShadow: [BoxShadow(
                            color: Colors.black26,
                            blurRadius: 1.0,
                          )]
                      ),

                      child: Text('Apply',textScaleFactor: 1.0, style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 15.0, fontFamily: 'Product Sans'))
                  )
          )*/
        ],
      ),

      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Cart(document: document['Coupon_Code']),
          ),
        );
      },

    );

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.blueGrey, //change your color here
        ),
        title: Text("Coupon List ",textScaleFactor: 1.0, style: TextStyle(fontFamily: 'Product Sans', color: Colors.blueGrey)),
        backgroundColor: Colors.white,
       // centerTitle: true,
      ),
      body: StreamBuilder(

          stream: Firestore.instance.collection('Coupon').snapshots(),
          builder: (context, snapshot){

            if(!snapshot.hasData) return const Text('loading....');
            return ListView.builder(
              itemExtent: 80.0,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) =>
                  _buildListItem(context, snapshot.data.documents[index]),

            );
          }

// This trailing comma makes auto-formatting nicer for build methods.
      ),
    );

  }

}