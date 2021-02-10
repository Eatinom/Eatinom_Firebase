import 'package:eatinom/DataNotifier/CartData.dart';
import 'package:eatinom/Pages/App/AppConfig.dart';
import 'package:eatinom/Pages/Index/Index.dart';
import 'package:eatinom/Pages/Orders/OrderSummary.dart';
import 'package:eatinom/Pages/Orders/Orders.dart';
import 'package:flutter/material.dart';

class OrderSuccess extends StatefulWidget {
  OrderSuccess({Key key}) : super(key: key);
  @override
  OrderSuccessPage createState() => new OrderSuccessPage();
}

class OrderSuccessPage extends State<OrderSuccess> {

  @override
  Widget build(BuildContext context) {
    AppConfig.context = context;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        Center(
            child: Image.asset('assets/OrderSuccess.png')
        ),
        Align(alignment: Alignment.bottomCenter, child: Container(
          margin: const EdgeInsets.only(left: 20, top: 10,bottom: 20.0,right: 20.0),
          constraints: const BoxConstraints(
              maxWidth: 500
          ),
          child: RaisedButton(elevation: 0.0,
            onPressed: () {
              CartData.cart.clear();
              CartData.callNotifier();
              Navigator.push(context, MaterialPageRoute(builder: (context) => Index(page: 2)));
            },
            color: Colors.green.shade50,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Check your Order',textScaleFactor: 1.0,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.green,fontSize: 20.0),
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
        ))
      ])
    ));
  }
}