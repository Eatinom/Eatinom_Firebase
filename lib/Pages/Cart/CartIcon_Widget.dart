

import 'package:eatinom/DataNotifier/CartData.dart';
import 'package:eatinom/Pages/App/AppConfig.dart';
import 'package:eatinom/Pages/Cart/Cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartIcon_Widget extends StatefulWidget {
  CartIcon_Widget({Key key, this.colorkey}) : super(key: key);
  final Color colorkey;
  @override
  CartIcon_WidgetPage createState() => new CartIcon_WidgetPage();
}

class CartIcon_WidgetPage extends State<CartIcon_Widget> {

  @override
  Widget build(BuildContext context) {

    ScreenUtil.init(context);
    ScreenUtil().allowFontScaling = false;
    return ValueListenableBuilder(
      valueListenable: CartData.notifier,
      builder: (context, value, child) {
        return Stack(
          children: <Widget>[
            Container(padding: EdgeInsets.only(top: 5.0,left: 0.0,right: 10.0),child: IconButton(icon: Image.asset('assets/Cart.png', height: 20.0,width: 20.0,), onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => Cart())); })),
            CartData.cart.length > 0 ?
            Positioned(
              right: 15.0,
              top: 12.0,
              child: new Container(
                padding: EdgeInsets.all(1),
                decoration: new BoxDecoration(
                  color: Colors.deepOrangeAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: BoxConstraints(
                  minWidth: 15,
                  minHeight: 15,
                ),
                child: new Text(
                  CartData.cart.length.toString(),textScaleFactor: 1.0,
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 11.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ) : SizedBox(width: 0.0,height: 0.0)
          ],
        );
      }
    );
  }


  void reloadCartCount(){
    setState(() {

    });
  }

}