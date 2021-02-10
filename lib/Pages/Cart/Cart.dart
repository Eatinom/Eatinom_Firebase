
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatinom/DataNotifier/CartData.dart';
import 'package:eatinom/DataNotifier/ChefData.dart';
import 'package:eatinom/DataNotifier/ChefItemData.dart';
import 'package:eatinom/Pages/App/AppConfig.dart';
import 'package:eatinom/Pages/Cart/CartHolder.dart';
import 'package:eatinom/Pages/Coupons/CPlist.dart';
import 'package:eatinom/Pages/PinLocation/PinLocation.dart';
import 'package:eatinom/Pages/PinLocation/PinLocation2.dart';
import 'package:eatinom/Util/GlobalActions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:randomizer/randomizer.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;

class Cart extends StatefulWidget {
  Cart({Key key, this.title, @required this.document, this.onchanged}) : super(key: key);
  final String title;
  final VoidCallback onchanged;
  final DocumentSnapshot document;
  @override
  CartPage createState() => new CartPage();
}

class CartPage extends State<Cart> {

  double totalPay = 0.0;
  int dp =0;
  List<DocumentSnapshot> finalItems = new List<DocumentSnapshot>();
  Razorpay _razorpay;
  bool isLoading = false;
  int couponAmount = 0;


  TextEditingController couponController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
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
            Navigator.of(context).popAndPushNamed('/index');
          },
          child: Icon(
            Icons.arrow_back_ios_outlined, // add custom icons also
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.blueGrey, //change your color here
        ),
        title: Text("Cart",textScaleFactor: 1.0, style: TextStyle(fontFamily: 'Product Sans', color: Colors.blueGrey)),
        backgroundColor: Colors.white,
       // elevation: 5.0,
        actions: [
          Container(
              padding: EdgeInsets.all(0.00),
              child: Row(
                children: [
                  InkWell(
                      child: Container(
                          padding: EdgeInsets.all(10.0),
                          child: Center(child: Text('Offers',textScaleFactor: 1.0, style: TextStyle(color: Colors.redAccent, fontFamily: 'Product Sans',fontWeight: FontWeight.w400, fontSize: 15.0)))
                      )
                  ),
                  IconButton(

                      icon: Image.asset('assets/GiftBox.png', height: 29.0,width: 29.0),
                      onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => CPlist())); })
                ],
              ),

          ),
        ],
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
                      child: showList()
                  )
              )
          ),
          CartData.cart.length > 0 ?
          Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
            height: 120,
            child: Container(
                color: Colors.blue.shade50,
                //height: 120.0,
                padding: EdgeInsets.only(left: 20.0,right: 20.0 , top: 15.0,bottom: 10.0),
                child: Column(children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                    Text('Delivering to',textScaleFactor: 1.0, style: TextStyle(color: Colors.blueGrey, fontSize: 16.0,fontFamily: 'Product Sans')),
                    InkWell(
                      child: Container(
                          child: Text('Edit',textScaleFactor: 1.0, style: TextStyle(color: Colors.blue, fontSize: 16.0,fontFamily: 'Product Sans'))
                      ),onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PinLocation()));
                      },
                    )
                  ]),
                  SizedBox(height: 10.0),
                  Container(
                      height: 60.0,
                      color: Colors.white,
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                        IconButton(
                            icon: Image.asset('assets/home.png', height: 24.0,width: 24.0),
                            onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => CPlist())); }),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.72,
                            child: Text(AppConfig.currentAddress,maxLines: 3,textScaleFactor: 1.0, softWrap: true,overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.blueGrey.shade300,fontSize: 14.0,fontFamily: 'Product Sans')
                            )
                        ),

                      ])
                  ),
                ])
            ),
          )

          ):SizedBox(),
          CartData.cart.length > 0 ?
           Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 140.0,
              color: Colors.blueGrey.shade50,
              child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                Container(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 10.0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                    Text('Total Amount',textScaleFactor: 1.0, style: TextStyle(color: Colors.black54, fontSize: 18.0,fontFamily: 'Product Sans', fontWeight: FontWeight.w600)),
                    Text('\u20B9 '+(totalPay * (5 / (100))+totalPay - couponAmount+dp).toStringAsFixed(2),textScaleFactor: 1.0,
                      style: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.black54,
                        fontFamily: 'Product Sans',
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ])
                ),
                PayButton()
              ]),
            )
          )
               : SizedBox(),

          isLoading ? Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.black.withOpacity(0.4),
            child: Center(
              child: Container(
                padding: EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                    //borderRadius: BorderRadius.circular(20),
                    color: Colors.white.withOpacity(1),
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(
                      color: Colors.black45,
                      blurRadius: 5.0,
                      spreadRadius: 1.0
                    )]
                ),
                height: 50.0,width: 50.0,
                child: CircularProgressIndicator()
              )
            )
          ): SizedBox(),
        ],
      );
    }
    catch(err){
      return Container();
    }
  }
  Widget showList(){
    try{
      totalPay = 0.0;
      dp = 0;
      List<Widget> lst = new List<Widget>();
      if(CartData.cart != null && CartData.cart.length > 0){
        lst.add(SizedBox(height: 120));
       // lst.add(couponCodeBox());
        CartData.cart.values.forEach((hld) {
          print('cart item added');
          lst.add(showCard(hld));
          finalItems.add(hld.item);
          totalPay = totalPay + (hld.item['Price'] * hld.count) ;
          dp = dp + (hld.item['DeliveryCharges']) ;
        }
        );
        lst.add(couponCodeBox());
      }

      if(lst.length > 0 ){
        lst.add(paymentSummary());
        //lst.add(deliveryPay());
        lst.add(SizedBox(height: 200));
        return Column(children: lst);
      }else{
        return Container(height: 300.0, child: Center(child: Text('No items are added to the cart',textScaleFactor: 1.0, style: TextStyle(color: Colors.redAccent, fontSize: 18.0,fontFamily: 'Product Sans'))));
      }

    }
    catch(err){
      return SizedBox();
    }
  }

  Widget paymentSummary(){
    return Container(
      child: Column(children: [
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            padding: EdgeInsets.only(top: 15.0, bottom: 0.0, left: 20.0, right: 20.0),
            child: Text('Payment Summary',textScaleFactor: 1.0, style: TextStyle(color: Colors.blueGrey, fontFamily: 'Product Sans', fontSize: 18.0, fontWeight: FontWeight.w600))
          )
        ),
        Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: EdgeInsets.only(top: 10.0,),
              child:  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                Container(
                  padding: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 20.0, right: 12.0),
                  child:Text('Item Total',textScaleFactor: 1.0, style: TextStyle(color: Colors.blueGrey, fontSize: 16.0, fontFamily: 'Product Sans')),
                ),
                Container(
                    padding: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 20.0, right: 20.0),
                    child: Text('\u20B9 '+(totalPay).toString(),textScaleFactor: 1.0, style: TextStyle(color: Colors.blueGrey, fontFamily: 'Product Sans', fontSize: 16.0, fontWeight: FontWeight.w600))
                )
              ]),
            )
        ),
        Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: EdgeInsets.only(top: 10.0,),
              child:  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                Container(
                  padding: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 20.0, right: 12.0),
                  child:Text('Delivery charges',textScaleFactor: 1.0, style: TextStyle(color: Colors.blueGrey, fontSize: 16.0, fontFamily: 'Product Sans')),
                ),
                Container(
                    padding: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 20.0, right: 20.0),
                    child: Text('\u20B9 '+(dp).toString(),textScaleFactor: 1.0, style: TextStyle(color: Colors.blueGrey, fontFamily: 'Product Sans', fontSize: 16.0, fontWeight: FontWeight.w600))
                )
              ]),
            )
        ),
        Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: EdgeInsets.only(top: 10.0,),
              child:  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                Container(
                  padding: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 20.0, right: 12.0),
                  child:Text('CGST',textScaleFactor: 1.0, style: TextStyle(color: Colors.blueGrey, fontSize: 12.0, fontFamily: 'Product Sans')),
                ),
                Container(
                    padding: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 20.0, right: 20.0),
                    child: Text('\u20B9 '+(totalPay * (5 / (100))/2).toStringAsFixed(2),textScaleFactor: 1.0, style: TextStyle(color: Colors.blueGrey, fontFamily: 'Product Sans', fontSize: 16.0, fontWeight: FontWeight.w600))
                )
              ]),
            )
        ),
        Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: EdgeInsets.only(top: 10.0,),
              child:  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                Container(
                  padding: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 20.0, right: 12.0),
                  child:Text('SGST',textScaleFactor: 1.0, style: TextStyle(color: Colors.blueGrey, fontSize: 12.0, fontFamily: 'Product Sans')),
                ),
                Container(
                    padding: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 20.0, right: 20.0),
                    child: Text('\u20B9 '+(totalPay * (5 / (100 ))/2).toStringAsFixed(2),textScaleFactor: 1.0, style: TextStyle(color: Colors.blueGrey, fontFamily: 'Product Sans', fontSize: 16.0, fontWeight: FontWeight.w600))
                )
              ]),
            )
        ),

        couponAmount != null && couponAmount > 0 ? Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: EdgeInsets.only(top: 10.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                Container(
                  padding: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 20.0, right: 12.0),
                  child:Text('Coupon Discount',textScaleFactor: 1.0, style: TextStyle(color: Colors.green.shade300, fontSize: 16.0, fontFamily: 'Product Sans')),
                ),
                Container(
                    padding: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 20.0, right: 20.0),
                    child: Text('- '+'\u20B9 '+couponAmount.toString(),textScaleFactor: 1.0, style: TextStyle(color: Colors.green.shade300, fontFamily: 'Product Sans', fontSize: 16.0, fontWeight: FontWeight.w600))
                )
              ])
            )
        ) :  SizedBox()
      ])
    );
  }


  Widget showCard(CartHolder hld){
    try{
      DocumentSnapshot dt = hld.item;
      return Stack(children: [
        Container(
            margin: EdgeInsets.only(top: 10.0,bottom: 5.0,left: 5.0,right: 5.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white.withOpacity(1),
                boxShadow: [BoxShadow(
                  color: Colors.black45,
                  blurRadius: 1.0,
                )]
            ),

            child:Column(children: [
              Row(
                 // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
               Padding(padding: EdgeInsets.only(right: 1.0,left : 10.0,)),
                Align(
                  alignment: Alignment.centerLeft,
                  child : ClipRRect(
                    borderRadius: BorderRadius.circular(28.0),
                    child: Image.memory(
                      base64Decode(dt['ImageStr']),
                      width: 60,
                      height: 85,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(top: 10.0, bottom:10.0,right: 10.0,left : 10.0,),
                    width: (MediaQuery.of(context).size.width - 20) * 0.75,
                    child: Column(children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(dt['Name'],textScaleFactor: 1.0, overflow: TextOverflow.ellipsis,maxLines: 2,style: TextStyle(color: Colors.blueGrey, fontFamily: 'Product Sans', fontSize: 17.0,fontWeight: FontWeight.w600)),
                      ),
                      SizedBox(height: 3.0),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Row(children: [
                            Padding(padding: EdgeInsets.only(right: 5.0),
                                child: Icon(Icons.person, size: 15.0,color: Colors.blueGrey.shade300,)),
                            Text(dt['Chef_Name'],textScaleFactor: 1.0, style: TextStyle(color: Colors.blueGrey.shade400, fontFamily: 'Product Sans', fontSize: 13.0))
                          ])
                      ),
                      SizedBox(height: 10.0),
                      Align(alignment: Alignment.centerLeft,child: Text(
                        '\u20B9 '+dt['Price'].toString(),textScaleFactor: 1.0,
                        style: const TextStyle(
                          fontSize: 20.0,
                          color: Colors.deepOrangeAccent,
                        ),
                      )),
                    ])
                )
              ]),
              dt['Order_Type'] == 'Pre' ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.orange.shade50,
                  ),
                  padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                  margin: EdgeInsets.all(5.0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                    Text(hld.daySlot.day.toString()+'/'+hld.daySlot.month.toString()+'/'+hld.daySlot.year.toString(), style: TextStyle(color: Colors.orange)),
                    Text(hld.timeSlot, style: TextStyle(color: Colors.orange))
                  ])
              ): SizedBox()
            ])
        ),


            Align(
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
    Padding(padding: EdgeInsets.only(left: 210.0)),

                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: dt['ItemCat'] == 'veg' ? Colors.blueAccent.withOpacity(0.2) : Colors.deepPurple.withOpacity(0.2),
                      ),
                      margin: EdgeInsets.only(top: 20.0, right: 20.0),
                      padding: EdgeInsets.only(left: 10.0,right: 10.0,top: 5.0,bottom: 5.0),

                      child: Text(dt['ItemCat'],textScaleFactor: 1.0, style: TextStyle(color: dt['ItemCat'] == 'veg' ? Colors.blueAccent : Colors.deepPurple, fontSize: 10.0,fontFamily: 'Product Sans')),
                    ),
                   // Padding(padding: EdgeInsets.only(right: 10.0)),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: dt['Order_Type'] == 'Instant' ? Colors.blueAccent.withOpacity(0.2) : Colors.deepPurple.withOpacity(0.2),
                      ),
                      margin: EdgeInsets.only(top: 20.0, right: 20.0),
                      padding: EdgeInsets.only(left: 10.0,right: 10.0,top: 5.0,bottom: 5.0),

                      child: Text(dt['Order_Type'],textScaleFactor: 1.0, style: TextStyle(color: dt['Order_Type'] == 'Instant' ? Colors.blueAccent : Colors.deepPurple, fontSize: 10.0,fontFamily: 'Product Sans')),
                    ),
                  ],
                ),



            ),

        Align(
            alignment: Alignment.bottomRight,
            child: Container(
                width: 100.0,
                height: 30.0,
                margin: EdgeInsets.only(right: 20.0,top: 65.0),
                padding: EdgeInsets.only(top: 5.0,bottom: 5.0,left: 10.0,right: 10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: HexColor('#efefef'),
                    boxShadow: [BoxShadow(
                      color: Colors.black26,
                      blurRadius: 1.0,
                    )]
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                  _decrementButton(dt),

                  Text(CartData.getItemCount(dt.id).toString(),textScaleFactor: 1.0, style: TextStyle(fontSize: 18.0,color: Colors.blueAccent.shade200)),

                  _incrementButton(dt),
                ])
            )
        )
      ]);
    }
    catch(err){
      return SizedBox();
    }
  }


  Widget _incrementButton(DocumentSnapshot item) {
    return InkWell(

        onTap: () {
          this.setState(() {
            CartData.increaseItemCount(item);
            CartData.callNotifier();
          });
        },

        child: Icon(Icons.add, color: Colors.blueGrey,size: 17.0,)
    );
  }

  Widget _decrementButton(DocumentSnapshot item) {
    return InkWell(
      onTap: (){
        this.setState(() {
          CartData.decreaseItemCount(item);
          CartData.callNotifier();
        });
      },child: new Icon(Icons.remove, color: Colors.blueGrey, size: 17.0),
    );
  }


  Widget PayButton(){
    return Container(
      margin: const EdgeInsets.only(left: 20, top: 10,bottom: 20.0,right: 20.0),
      constraints: const BoxConstraints(
          maxWidth: 500
      ),
      child: RaisedButton(
        onPressed: () {
          //PlaceOrder();
          setState(() {
            isLoading = true;
          });
          openCheckout();
        },
        color: Colors.green,
        //teal.shade300,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Proceed to Pay',textScaleFactor: 1.0,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white,fontSize: 18.0),
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


  void PlaceOrder(String orderID , String paymentID ){
    try{
      setState(() {
        isLoading = true;
      });
      GlobalActions.showToast_Notification(
          'Please Wait..', 'We are confirming your order.', AppConfig.context);
      List<String> chefs = new List<String>();

      CartData.cart.values.forEach((hld) {
        if (!chefs.contains(hld.item['Chef_Id'])) {
          chefs.add(hld.item['Chef_Id']);
        }
      });

      CollectionReference Orders = FirebaseFirestore.instance.collection('Order');
      print('placeorder chefs --- '+chefs.length.toString());
      int OrderedCount = 0;
      chefs.forEach((chef)
      {
        int chefPay = 0;
        int cgst = 0;
        int sgst = 0;
        int otp = 0;
        String daySlot = '';
        String timeSlot = '';
        var randomizer = new Randomizer();
        int chefPayDiscount = (couponAmount / chefs.length).ceil();
        int chefItemsCount = 0;
        DocumentSnapshot chefDoc;
       // DocumentSnapshot chefDoc1;
        List<String> orderTypes = new List<String>();
        CartData.cart.values.forEach((hld) {
          if(hld.item['Chef_Id'] == chef && hld.item['Price'] != null){
            chefPay = chefPay + (totalPay * (5 / (100 + 5))+totalPay - couponAmount).ceil();
            cgst = cgst + (totalPay * (5 / (100 + 5))).ceil();
            sgst = sgst + (totalPay * (5 / (100 + 5))).ceil();
            otp =  randomizer.getrandomnumber(10000, 99999);
                //hld.item['Price'].ceil();
            chefItemsCount++;
            if(chefDoc == null){
              chefDoc = ChefData.getChef(chef);
            }
            if(!orderTypes.contains(hld.item['Order_Type'])){
              orderTypes.add(hld.item['Order_Type']);
            }
            print(hld.item['Order_Type']);
            if (hld.daySlot != null && hld.timeSlot != null ) {

              daySlot = hld.daySlot.day.toString() +
                  "/" +
                  hld.daySlot.month.toString() +
                  '/' +
                  hld.daySlot.year.toString();

              timeSlot = hld.timeSlot;

            }
            if (hld.daySlot == null && hld.timeSlot == null  ) {
              daySlot ="";
              timeSlot = "";
            }
          }
        });
        print('order placing');
        print('chefdoc --- '+chefDoc.id);
        Orders.add({
          'Customer_ID': AppConfig.userID,
          'Customer_Phone': AppConfig.phoneID,
          'Placed_On': DateTime.now(),
          'Total_Amount': chefPay,
          'CSGT' : cgst,
          'SGST' :sgst,
          'Discount_Amount': chefPayDiscount,
          'Final_Amount': chefPay - chefPayDiscount,
          'Order_Type': orderTypes,
          'Status': 'Confirmed',
          'Items_Count': chefItemsCount,
          'Chef_Name': chefDoc['Display_Name'],
          'Delivery_Charges': chefDoc['DeliveryCharges'],
          'Chef_ID': chefDoc.id,
          'Delivery_Address': AppConfig.currentAddress,
          'Delivery_Landmark': AppConfig.landMark,
          'Chef_Address': chefDoc['Address'],
          'Delivery_Location': new GeoPoint(AppConfig.currentPosition.latitude,AppConfig.currentPosition.longitude),
          'Chef_Location': new GeoPoint(chefDoc['Current_Latitude'],chefDoc['Current_Longitude']),
          'Order_ID': orderID,
          'Otp_ID' : otp,
          'Payment_ID': paymentID,
          'Day_Slot': daySlot,
          'Time_Slot': timeSlot
        })
        .then( (order){
          if (order != null) {
            print("Order Added -- " + order.id);
            CollectionReference OrdersItems = FirebaseFirestore.instance.collection('Order/' + order.id + '/Items');
            print("Order Added2 -- " + order.id);
            CartData.cart.values.forEach((hld) {
              print("Order Added3 -- " + order.id);
              if (hld.item['Chef_Id'] == chef) {
                print("Order Added4 -- " + order.id);
                String daySlot = '';
                String timeSlot = '';
                print("Order Added5 -- " + order.id);
                if (hld.daySlot != null) {
                  print("Order Added6 -- " + order.id);
                  daySlot = hld.daySlot.day.toString() +
                      "/" +
                      hld.daySlot.month.toString() +
                      '/' +
                      hld.daySlot.year.toString();
                }
                if (hld.timeSlot != null) {
                  print("Order Added7 -- " + order.id);
                  timeSlot = hld.timeSlot;
                }
                print("Order Added8 -- " );

                OrdersItems.add(
                    {
                  'Customer_ID': AppConfig.userID,
                  'Customer_Phone': AppConfig.phoneID,
                  'Placed_On': DateTime.now(),
                  'Order_ID': order.id,
                  'Item_Name': hld.item['Name'],
                  'Item_ID': hld.item.id,
                  'Quantity': CartData.getItemCount(hld.item.id),
                  'Order_Type': hld.item['Order_Type'],
                  'Price': hld.item['Price'],
                //  'HSN': hld.item['HSN'],
                  'ImageStr': hld.item['ImageStr'],
                 'Day_Slot': daySlot,
                 'Time_Slot': timeSlot
                }).then((itm) {
                  if (itm != null) {
                    print("Item Added -- " + itm.id);
                    setState(() {
                      isLoading = false;
                    });
                    OrderedCount++;
                    if (CartData.cart.length == OrderedCount) {
                      CartData.cart.clear();
                      CartData.callNotifier();
                      Navigator.pushReplacementNamed(context, '/ordersuccess');
                    }
                  }
                }).catchError((error) => print("Failed to add user: $error"));
              }
            });
          }
/*
          CartData.cart.values.forEach(
                  (hld) {
            if(hld.item['Chef_Id'] == chef){
              print("Order Added to collections3 -- "+order.id);
              print("Order Added to collections4 -- "+order.id);
              OrderedCount++;
              print("Order Added to collections5 -- "+order.id);
              if(CartData.cart.length == OrderedCount){
                CartData.cart.clear();
                CartData.callNotifier();
                Navigator.pushReplacementNamed(context, '/ordersuccess');
              }
              print("Order Added to collections6 -- "+order.id);
            }
          }
          );*/

        /*

          if(order != null){
            print("Order Added -- "+order.id);
            // CollectionReference OrdersItems = FirebaseFirestore.instance.collection('Order/'+order.id+'/Items');
        print("Order Added to collections -- "+order.id);
            CartData.cart.values.forEach((hld) {
              print("Order Added to collections2 -- "+order.id);
              if(hld.item['Chef_Id'] == chef){
                print("Order Added to collections3 -- "+order.id);
                print("Order Added to collections4 -- "+order.id);
                OrderedCount++;
                print("Order Added to collections5 -- "+order.id);
                if(CartData.cart.length == OrderedCount){
                  CartData.cart.clear();
                  CartData.callNotifier();
                  Navigator.pushReplacementNamed(context, '/ordersuccess');
                }
                print("Order Added to collections6 -- "+order.id);
        */
          /*        OrdersItems.add(
                    {
                  'Customer_ID': AppConfig.userID,
                  'Customer_Phone': AppConfig.phoneID,
                  'Placed_On': DateTime.now(),
                  'Order_ID': AppConfig.orderID,
                  'Item_Name': hld.item['Name'],
                  'Item_ID': hld.item.id,
                  'Quantity': CartData.getItemCount(hld.item.id),
                  'Order_Type': hld.item['Order_Type'],
                  'Price': hld.item['Price'],
                  'HSN': hld.item['HSN'],
                  'ImageStr': hld.item['ImageStr'],
                  'Day_Slot': daySlot,
                  'Time_Slot': timeSlot
                }
                )
                .then(
                        (itm){
                  print("Order Added to collections7 -- "+order.id);
                  if(itm != null){
                    print("Item Added -- "+itm.id);
                    setState(() {
                      isLoading = false;
                    });
                    print("Order Added to collections8 -- "+order.id);
                    OrderedCount++;
                    if(CartData.cart.length == OrderedCount){
                      CartData.cart.clear();
                      CartData.callNotifier();
                      Navigator.pushReplacementNamed(context, '/ordersuccess');
                    }
                  }
                }
                ).catchError((error) => print("Failed to add user: $error"));*//*
              }
            });
          }*/
        }
        )
        .catchError((error) => print("Failed to add user: $error"));
      });
    }
    catch(err){
      print(err);
    }
  }


  void openCheckout() async {
    setState(() {
      isLoading = true;
    });
    int finalPay = (totalPay * (5 / (100 + 5))+totalPay - couponAmount+dp).ceil() * 100;
    String orderid = await generateOrderId('rzp_test_tFrGCbt37NG0qM' , 'PMx9Y3oPmIi6Cs8AaHMkaW4v', finalPay);
    var randomizer = new Randomizer();
    int otp = randomizer.getrandomnumber(3,78);
    var options = {
      'key': 'rzp_test_tFrGCbt37NG0qM',
      'amount': finalPay,
      'name': 'Eatinom',
      'description': 'Food order online',
      'order_id': orderid,
      'otp' : otp,
      'prefill': {'contact': '9100466729', 'email': 'pbrtechnologies@yahoo.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
      setState(() {
        isLoading = true;
      });
    } catch (e) {
      debugPrint('*****************'+e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('response.paymentId --- '+response.paymentId);
    print('response.orderId --- '+response.orderId);
    if(response.paymentId != null){
      PlaceOrder(response.orderId , response.paymentId);
    }
    setState(() {
      isLoading = false;
    });
  }
  void _handlePaymentError(PaymentFailureResponse response) {
    GlobalActions.showToast_Error('Payment Failed', '....', context);
    setState(() {
      isLoading = false;
    });
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    GlobalActions.showToast_Error('Payment EXTERNAL_WALLET', response.walletName, context);
    setState(() {
      isLoading = false;
    });
  }

  Future<String> generateOrderId(String key, String secret,int amount) async{
    var authn = 'Basic ' + base64Encode(utf8.encode('$key:$secret'));
    var headers = {
      'content-type': 'application/json',
      'Authorization': authn,
    };
//$amount
    var data = '{ "amount": $amount, "currency": "INR", "receipt": "receipt#R1", "payment_capture": 1 }'; // as per my experience the receipt doesn't play any role in helping you generate a certain pattern in your Order ID!!
    var res = await http.post('https://api.razorpay.com/v1/orders', headers: headers, body: data);
    if (res.statusCode != 200) throw Exception('http.post error: statusCode= ${res.statusCode}---'+res.body);
    print('ORDER ID response => ${res.body}');
    return json.decode(res.body)['id'].toString();
  }


  Widget couponCodeBox() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 0.0),
      child: TextField(
        style: TextStyle(
            fontSize: 20.0,
            color: Colors.deepOrangeAccent,
            fontFamily: 'Product Sans',
            fontWeight: FontWeight.w600),
        enabled: true,
        controller: couponController, // to trigger disabledBorder
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(15, 20, 20, 0),
            filled: true,
            fillColor: Colors.pink.withOpacity(0.02),
           // prefixIcon: Image.asset('assets/GiftBox.png',height: 10.0,width: 10.0),
            prefixIcon: InkWell(
                onTap: () {
                  setState(() {
                    isLoading = true;
                  });
                  applyCouponCode();
                },
                child: Container(
                   // margin: EdgeInsets.all(10.0),
                    padding: EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                    child: IconButton(
                        icon: Image.asset('assets/GiftBox.png',height: 40,width: 40,),
                        onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => CPlist())); }),
                )


            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(width: 1, color: Colors.blueGrey.shade100),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(width: 1, color: Colors.blueGrey.shade100),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(width: 1, color: Colors.blueGrey.shade100),
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide: BorderSide(
                  width: 1,
                )),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide:
                BorderSide(width: 1, color: Colors.blueGrey.shade100)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide:
                BorderSide(width: 1, color: Colors.blueGrey.shade100)),

            hintText: "Coupon Code",

            hintStyle: TextStyle(fontSize: 16, color: Color(0xFFB3B1B1)),
            errorText: couponAmount != null && couponAmount > 0
                ? 'Coupon applied successfully.'
                : '',
            errorStyle: TextStyle(
                color: Colors.green,
                fontSize: 12.0,
                fontFamily: 'Product Sans'),
            suffixIcon: InkWell(
                onTap: () {
                  setState(() {
                    isLoading = true;
                  });
                  applyCouponCode();
                },
                child: Container(
                    margin: EdgeInsets.all(10.0),
                    padding: EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 5.0, bottom: 5.0),
                    child: Text('Apply',
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            color: Colors.deepOrangeAccent,
                            fontSize: 15.0,
                            fontFamily: 'Product Sans')
                    )
                )
            
            
            )
        ),
        obscureText: false,
        onChanged: (value) {
          if (value == '') {
            couponAmount = 0;
            setState(() {});
          }
        },
      ),
    );
  }

  void applyCouponCode() {
    FocusScope.of(context).requestFocus(new FocusNode());
    try {
      String enteredCoupon = couponController.text;
      if (enteredCoupon != null && enteredCoupon != '') {
        Firestore.instance
            .collection('Coupon')
            .where('Coupon_Code', isEqualTo: enteredCoupon)
            .where('Active', isEqualTo: true)
            .snapshots()
            .listen((event) {
          if (event != null && event.docs.length > 0) {
            FocusScope.of(context).requestFocus(new FocusNode());

            int discount = event.docs[0]['Discount'];
            print('discount --- ' + discount.toString());
            if (discount != null && discount > 0.0) {
              couponAmount = discount;
            } else {
              couponAmount = 0;
            }
          } else {
            FocusScope.of(context).requestFocus(new FocusNode());
            GlobalActions.showToast_Error(
                'Invalid Coupon', 'Please enter valid coupon code.', context);
            couponAmount = 0;
          }
          setState(() {
            isLoading = false;
          });
        });
      } else {
        FocusScope.of(context).requestFocus(new FocusNode());
        GlobalActions.showToast_Error(
            'Invalid Coupon', 'Please enter valid coupon code.', context);
        setState(() {
          isLoading = false;
        });
        couponAmount = 0;
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      couponAmount = 0;
    }
  }





 /* Widget couponCodeBox(){
    return Container(
        color: Colors.white,
        margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0,bottom: 0.0),
        child: Column(
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    padding: EdgeInsets.only(top: 7.0,bottom: 8.0,left: 15.0,right: 15.0),
                    color: Colors.blueGrey.withOpacity(0.1),
                    width: double.infinity,
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                      Text("Select a Promo Code ",textScaleFactor: 1.0, style: TextStyle(fontSize: 17.0, height: 1.3, color: HexColor('#55A47E'), fontFamily: 'Product Sans', fontWeight: FontWeight.w500)),
                      InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CPlist()));
                          },
                          child: Container(child: Text('Apply',textScaleFactor: 1.0, style: TextStyle(color: Colors.blueGrey)))
                      )
                    ])
                )
            ),

           *//* TextField(
              style: TextStyle(fontSize: 20.0, color: Colors.blueGrey,fontFamily: 'Product Sans', fontWeight: FontWeight.w600),
             enabled: true,
              controller: couponController,// to trigger disabledBorder
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(15, 20, 20, 0),
                  filled: false,
                  fillColor: Colors.black.withOpacity(0.02),
                  //hintText: text,
                  hintStyle: TextStyle(fontSize: 16,color: Color(0xFFB3B1B1)),
                  errorText: couponAmount != null && couponAmount > 0 ? 'Coupon applied successfully.' : '',
                  errorStyle: TextStyle(color: Colors.green, fontSize: 12.0, fontFamily: 'Product Sans'),
                  suffixIcon:  InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CPlist()));
                      },
                      child: Container(
                          margin: EdgeInsets.all(10.0),
                          padding: EdgeInsets.only(left: 20.0, right: 20.0,top: 5.0,bottom: 5.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey.shade50,
                              boxShadow: [BoxShadow(
                                color: Colors.black26,
                                blurRadius: 1.0,
                              )]
                          ),
                          child: Text('View offers',textScaleFactor: 1.0, style: TextStyle(color: Colors.green, fontSize: 15.0, fontFamily: 'Product Sans'))
                      )
                  )
              ),

            //  obscureText: false,

              onChanged:(document){
                if(document == ''){
                  couponAmount = 0;
                  setState(() {
                    applyCouponCode();
                   // Navigator.of(context).pushReplacementNamed('/Coupon_Code');
                  });
                }
              } ,

            ),*//*
        *//*    Align(
              alignment: Alignment.center,
              child: Container(padding: EdgeInsets.only(left: 160.0,right: 08.0,),child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    child: Text("Coupon List",style: TextStyle(fontSize: 16.0,color: Colors.red)),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Coupons()));
                    },
                  ),
                ],
              )
              ),
            ),*//*
          ],
        ),
      );
  }
*/


}

