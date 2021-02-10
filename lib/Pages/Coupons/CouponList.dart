
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatinom/DataNotifier/CartData.dart';
import 'package:eatinom/DataNotifier/ChefData.dart';
import 'package:eatinom/DataNotifier/ChefItemData.dart';
import 'package:eatinom/Pages/App/AppConfig.dart';
import 'package:eatinom/Pages/Cart/CartHolder.dart';
import 'package:eatinom/Pages/Coupons/Coupons.dart';
import 'package:eatinom/Pages/Orders/OrderSuccess.dart';
import 'package:eatinom/Pages/PinLocation/PinLocation.dart';
import 'package:eatinom/Pages/PinLocation/PinLocation2.dart';
import 'package:eatinom/Util/GlobalActions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;

class CouponList extends StatefulWidget {
  CouponList({Key key, this.title, this.onchanged}) : super(key: key);
  final String title;
  final VoidCallback onchanged;

  @override
  CouponListPage createState() => new CouponListPage();

}

class CouponListPage extends State<CouponList> {

  double totalPay = 0.0;
  List<DocumentSnapshot> finalItems = new List<DocumentSnapshot>();

  bool isLoading = false;
  int couponAmount = 0;


  TextEditingController couponController = TextEditingController();


  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    AppConfig.context = context;

    ScreenUtil.init(context);
    ScreenUtil().allowFontScaling = false;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).popAndPushNamed('/cart');
          },
          child: Icon(
            Icons.arrow_back, // add custom icons also
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.blueGrey, //change your color here
        ),
        title: Text("CouponList",textScaleFactor: 1.0, style: TextStyle(fontFamily: 'Product Sans', color: Colors.blueGrey)),
        backgroundColor: Colors.white,
        // centerTitle: true,
      ),
      body: showBody(),
    );
  }

  Widget showBody(){
    try{
      return Stack(
        children: [
          Align(
              alignment: Alignment.topCenter,
              child: Container(
                  child: SingleChildScrollView(
                      child: couponCodeBox()
                  )
              )
          ),
        ],
      );

    }
    catch(err){
      return Container();
    }
  }

  Widget couponCodeBox(){
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0,bottom: 0.0),
      child: Column(
        children: [
          TextField(
            style: TextStyle(fontSize: 20.0, color: Colors.blueGrey,fontFamily: 'Product Sans', fontWeight: FontWeight.w600),
            enabled: true,
            controller: couponController,// to trigger disabledBorder
            decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(15, 20, 20, 0),
                filled: true,
                fillColor: Colors.black.withOpacity(0.02),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(width: 1,color: Colors.blueGrey.shade100),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(width: 1,color: Colors.blueGrey.shade100),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(width: 1,color: Colors.blueGrey.shade100),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1,)
                ),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1,color: Colors.blueGrey.shade100)
                ),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1,color: Colors.blueGrey.shade100)
                ),
                hintText: "Enter Coupon Code",
                hintStyle: TextStyle(fontSize: 16,color: Color(0xFFB3B1B1)),
                errorText: couponAmount != null && couponAmount > 0 ? 'Coupon applied successfully.' : '',
                errorStyle: TextStyle(color: Colors.green, fontSize: 12.0, fontFamily: 'Product Sans'),
                suffixIcon:  InkWell(
                    onTap: (){
                      applyCouponCode();
                    },
                    child: Container(
                        margin: EdgeInsets.all(10.0),
                        padding: EdgeInsets.only(left: 20.0, right: 20.0,top: 5.0,bottom: 5.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.deepOrange.shade50,
                            boxShadow: [BoxShadow(
                              color: Colors.black26,
                              blurRadius: 1.0,
                            )]
                        ),
                        child: Text('Apply',textScaleFactor: 1.0, style: TextStyle(color: Colors.green, fontSize: 15.0, fontFamily: 'Product Sans'))
                    )
                )
            ),

            obscureText: false,
            onChanged:(value){
              if(value == ''){
                couponAmount = 0;
                setState(() {
                  // Navigator.of(context).pushReplacementNamed('/Coupon_Code');
                });
              }
            } ,
          ),
        ],
      ),



    );
  }





  Widget applyCouponCode(){
    FocusScope.of(context).requestFocus(new FocusNode());

    try{
      String enteredCoupon = couponController.text;
      if(enteredCoupon != null && enteredCoupon != ''){
        FirebaseFirestore.instance.collection('Coupon').where('Coupon_Code', isEqualTo: enteredCoupon).where('Active', isEqualTo: true).snapshots().listen((event) {
          if(event != null && event.docs.length > 0){
            FocusScope.of(context).requestFocus(new FocusNode());

            int discount = event.docs[0]['Discount'];
            print('discount --- '+discount.toString());
            if(discount != null && discount > 0.0){
              couponAmount = discount;
            }else{
              couponAmount = 0;
            }
          }
          else{
            FocusScope.of(context).requestFocus(new FocusNode());
            GlobalActions.showToast_Error('Invalid Coupon', 'Please enter valid coupon code.', context);
            couponAmount = 0;
          }
          setState(() {isLoading = false;});
        });

      }
      else{
        FocusScope.of(context).requestFocus(new FocusNode());
        GlobalActions.showToast_Error('Invalid Coupon', 'Please enter valid coupon code.', context);
        setState(() {isLoading = false;});
        couponAmount = 0;
      }
    }
    catch(err){
      setState(() {isLoading = false;});
      couponAmount = 0;
    }
  }

}

