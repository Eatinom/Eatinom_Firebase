
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatinom/Pages/App/AppConfig.dart';
import 'package:eatinom/Util/GlobalActions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClaimBonus extends StatefulWidget {
  ClaimBonus({Key key, this.title}) : super(key: key);
  final String title;

  @override
  ClaimBonusPage createState() => new ClaimBonusPage();
}

class ClaimBonusPage extends State<ClaimBonus> {

  TextEditingController couponController = TextEditingController();
  bool isLoading = false;
  dynamic bonusAmount;

  @override
  Widget build(BuildContext context) {
    AppConfig.context = context;

    ScreenUtil.init(context);
    ScreenUtil().allowFontScaling = false;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.blueGrey, //change your color here
        ),
        title: Text("Claim Referal Bonus",textScaleFactor: 1.0, style: TextStyle(fontFamily: 'Product Sans',color: Colors.blueGrey)),
        backgroundColor: Colors.white,
        //centerTitle: true,
      ),
      body: Stack(children: [
        ShowBody(),
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
                    height: 60.0,width: 60.0,
                    child: CircularProgressIndicator()
                )
            )
        ): SizedBox(),
      ])
    );
  }


  Widget ShowBody(){
    try{
      return Container(
         child: couponCodeBox()
      );
    }
    catch(err){
      print(err);
    }
  }


  Widget couponCodeBox(){
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0,bottom: 0.0),
      child:TextField(
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
            hintText: "Enter Referal Code",
            hintStyle: TextStyle(fontSize: 16,color: Color(0xFFB3B1B1)),
            errorText: bonusAmount != null && bonusAmount > 0 ? 'Referal Code applied successfully.' : '',
            errorStyle: TextStyle(color: Colors.green, fontSize: 12.0, fontFamily: 'Product Sans'),
            suffixIcon:  InkWell(
                onTap: (){
                  setState(() {
                    isLoading = true;
                  });
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

                    child: Text('Apply',textScaleFactor: 1.0, style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 15.0, fontFamily: 'Product Sans'))
                )
            )
        ),
        obscureText: false,
        onChanged:(value){
          if(value == ''){
            bonusAmount = 0;
            setState(() {});
          }
        } ,
      ),

    );
  }


  void applyCouponCode(){
    FocusScope.of(context).requestFocus(new FocusNode());
    try{
      String enteredCode = couponController.text;
      if(enteredCode != null && enteredCode != ''){
        FirebaseFirestore.instance.collection('Customer').where('Referal_Code', isEqualTo: enteredCode).snapshots().listen((event) {
          if(event != null && event.docs.length > 0){
            FocusScope.of(context).requestFocus(new FocusNode());

            FirebaseFirestore.instance.collection('Customer').doc(AppConfig.userID).snapshots().listen((newUser) {
              if(newUser != null){
                if(!newUser.data().containsKey('IsNewUser') || newUser['IsNewUser'] == true){
                  FirebaseFirestore.instance.collection('App').doc('Config').snapshots().listen((config) {
                    if(config != null){
                      bonusAmount = config['Referal_Bonus'];
                      dynamic currentWallet = 0;
                      if(newUser.data().containsKey('Wallet_Amount')){
                        currentWallet = newUser['Wallet_Amount'].ceil();
                      }
                      currentWallet = currentWallet + bonusAmount.ceil();
                      CollectionReference customer = AppConfig.firestore.collection('Customer');

                      FirebaseFirestore.instance.collection('Customer').doc(AppConfig.userID).set({
                        'Wallet_Amount': currentWallet,
                        'IsNewUser': false
                      },SetOptions(merge : true))
                      .then((value)
                      {
                        print("NewUser referal bonus added");
                        FirebaseFirestore.instance.collection('Customer').where('Referal_Code', isEqualTo: enteredCode).snapshots().listen((oldUser) {
                          if(oldUser != null && oldUser.docs.length > 0){

                            dynamic oldUserWallet = 0;
                            if(oldUser.docs[0].data().containsKey('Wallet_Amount')){
                              oldUserWallet = oldUser.docs[0]['Wallet_Amount'].ceil();
                            }
                            oldUserWallet = oldUserWallet + bonusAmount.ceil();


                            FirebaseFirestore.instance.collection('Customer').doc(AppConfig.userID).set({
                              'Wallet_Amount': oldUserWallet
                            },SetOptions(merge : true))
                                .then((value)
                                {
                                  print("NewUser referal bonus added");
                                  Navigator.pop(context,true);
                                  GlobalActions.showToast_Sucess('Success', 'Referal bonus amount successfully added to wallet.', context);
                                })
                                .catchError((error) => print("issue while saving changes"));
                          }
                        });
                      })
                      .catchError((error) => print("issue while saving changes"));
                    }
                  });
                }
                else{
                  Navigator.pop(context,true);
                  GlobalActions.showToast_Error('Error', 'You have already used first time referal code.', context);
                }
              }
            });
          }
          else{
            FocusScope.of(context).requestFocus(new FocusNode());
            GlobalActions.showToast_Error('Invalid Referal Code', 'Please enter valid coupon code.', context);
            bonusAmount = 0;
          }
          setState(() {isLoading = false;});
        });

      }
      else{
        FocusScope.of(context).requestFocus(new FocusNode());
        GlobalActions.showToast_Error('Invalid Coupon', 'Please enter valid coupon code.', context);
        setState(() {isLoading = false;});
        bonusAmount = 0;
      }
    }
    catch(err){
      setState(() {isLoading = false;});
      bonusAmount = 0;
    }
  }

}