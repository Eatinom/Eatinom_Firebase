import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatinom/Pages/App/AppConfig.dart';
import 'package:eatinom/Util/GlobalActions.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/services.dart' show rootBundle;

class Login extends StatefulWidget {
  Login_State createState() => Login_State();
}

class Login_State extends State<Login> {
  TextEditingController phoneCodeCtrl = TextEditingController();
  TextEditingController phoneNumCtrl = TextEditingController();
  TextEditingController otpFieldCtrl1 = TextEditingController();
  TextEditingController otpFieldCtrl2 = TextEditingController();
  TextEditingController otpFieldCtrl3 = TextEditingController();
  TextEditingController otpFieldCtrl4 = TextEditingController();
  TextEditingController otpFieldCtrl5 = TextEditingController();
  TextEditingController otpFieldCtrl6 = TextEditingController();
  FirebaseAuth _auth;
  String verificationId;
  var _phoneBlockHeight = 0.0;
  var _otpBlockHeight = 0.0;
  var _otpLoadingBlockHeight = 0.0;
  double scaleFactor;
  bool valuefirst = true;
  //bool valuesecond = true;
  String data;
  @override
  void initState() {
    super.initState();
    phoneCodeCtrl.text = '+91';
    WidgetsBinding.instance.addPostFrameCallback((_) => openPhoneBlock());
    getText();
  }

  void getText() async {
    data = await getFileData();
  }

  /// Assumes the given path is a text-file-asset.
  Future<String> getFileData() async {
    return await rootBundle.loadString("assets/termsconnditio.txt");
  }

  @override
  void dispose() {
    super.dispose();
    phoneCodeCtrl.dispose();
    phoneNumCtrl.dispose();
    otpFieldCtrl1.dispose();
    otpFieldCtrl2.dispose();
    otpFieldCtrl3.dispose();
    otpFieldCtrl4.dispose();
    otpFieldCtrl5.dispose();
    otpFieldCtrl6.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    ScreenUtil().allowFontScaling = false;
    scaleFactor = MediaQuery.of(context).textScaleFactor;
    return WillPopScope(
        onWillPop: () async => false,
        child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Material(
                child: Scaffold(
                    backgroundColor: HexColor("#F8EFE9"),
                    body: Stack(children: <Widget>[
                      Align(
                          alignment: Alignment.topCenter, child: bgCaurosel()),
                      phoneBlock(),
                      otpBlock(),
                      //loadingBlock()
                    ])))));
  }

  Widget bgCaurosel() {
    final List<String> imgList = [
      "assets/loginBG1.png",
      "assets/loginBG2.png",
    ];

    return CarouselSlider(
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height * 0.70,
        viewportFraction: 1.0,
        enlargeCenterPage: false,
        autoPlay: true,
      ),
      items: imgList
          .map(
            (item) => item.contains('loginBG1')
                ? Container(
                    padding: EdgeInsets.only(top: 100.0),
                    child: Center(
                        child: Image.asset(item, height: double.infinity)))
                : Container(
                    child: Center(
                        child: Image.asset(item, height: double.infinity))),
          )
          .toList(),
    );
  }

  void openPhoneBlock() {
    setState(() {
      FocusScope.of(context).unfocus();
      _otpBlockHeight = 0.0;
      _otpLoadingBlockHeight = 0.0;
      _phoneBlockHeight = 300.0;
    });
  }

  void openOtpBlock() {
    setState(() {
      FocusScope.of(context).unfocus();
      _phoneBlockHeight = 0.0;
      _otpLoadingBlockHeight = 0.0;
      //_otpBlockHeight = MediaQuery.of(context).size.height;
      _otpBlockHeight = 300;
    });
  }

  void openLoadingBlock() {
    setState(() {
      FocusScope.of(context).unfocus();
      _phoneBlockHeight = 0.0;
      _otpLoadingBlockHeight = 300.0;
      _otpBlockHeight = 0.0;
    });
  }

  Widget loadingBlock() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: AnimatedContainer(
            duration: Duration(seconds: 1),
            curve: Curves.fastOutSlowIn,
            height: _otpLoadingBlockHeight,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, blurRadius: 50.0, spreadRadius: 5.0)
              ],
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0)),
              color: Colors.white,
            ),
            child: Center(
                child: CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(Colors.orange)))));
  }

  Widget phoneBlock() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: AnimatedContainer(
          duration: Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
          height: _phoneBlockHeight,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, blurRadius: 50.0, spreadRadius: 5.0)
            ],
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0)),
            color: Colors.white,
          ),
          child: Stack(children: [
            //text
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                padding: EdgeInsets.only(left: 30, top: 40.0),
                child: RichText(
                    textScaleFactor: 1.0,
                    text: TextSpan(
                      text: 'Login through your mobile number\n',
                      style: TextStyle(
                          fontSize: 19.0, height: 1.5, color: Colors.black),
                      /*  children: <TextSpan>[
                      TextSpan(text: 'We will send ', style: TextStyle(fontSize: 11.0,color: Colors.grey)),
                      TextSpan(text: 'One Time Password ', style: TextStyle(fontSize: 11.0,color: Colors.grey,fontWeight: FontWeight.bold)),
                      TextSpan(text: 'to this mobile number', style: TextStyle(fontSize: 11.0,color: Colors.grey)),
                    ],*/
                    )),
              ),
            ),
            //phone code
            Align(
              alignment: Alignment.center,
              child: Container(
                  padding: EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 0, bottom: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      phoneCode(),
                      new Flexible(child: phoneNumber()),
                    ],
                  )),
            ),
            SizedBox(
              height: 2.0,
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                  padding: EdgeInsets.only(left: 30.0, right: 25.0, top: 80),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        activeColor: Colors.green,
                        value: this.valuefirst,
                        onChanged: (bool value) {
                          setState(() {
                            this.valuefirst = value;
                          });
                        },
                      ),

                      /*   Align(
          alignment: Alignment.bottomLeft,
          child: Container(color: Colors.white,width: double.infinity,
              padding: EdgeInsets.only(left: 20.0,right: 20.0,bottom: 225.0,top: 10.0),
              child: Text('Move pin to set new location ', textAlign: TextAlign.left,style: TextStyle(color: Colors.green,fontFamily: 'Product Sans',fontSize: 18.0))
          )
      ),*/
                      InkWell(
                        child: Text(
                            'I accept terms of service and\nprivacy policy',
                            textAlign: TextAlign.left,
                            textScaleFactor: 1.1,
                            style: TextStyle(
                                fontSize: 18.0,
                                height: 1.1,
                                color: HexColor('#000000'),
                                fontFamily: 'Product Sans',
                                fontWeight: FontWeight.w500)),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _buildAboutDialog(context),
                          );
                        },
                      ),
                    ],
                  )),
            ),

            /*  Align(
            alignment: Alignment.center,
            child: Container(padding: EdgeInsets.only(left: 30.0,right: 190.0,top:105),child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Checkbox(
                  checkColor: Colors.greenAccent,
                  activeColor: Colors.green,
                  value: this.valuesecond,
                  onChanged: (bool value) {
                    setState(() {
                      this.valuesecond = value;
                    });
                  },
                ),
                InkWell(
                  child: Text("Privacy and Policy",textScaleFactor: 1.0, style: TextStyle(fontSize: 10.0, height: 1.3, color: HexColor('#55A47E'), fontFamily: 'Product Sans', fontWeight: FontWeight.w500)),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => _buildPrivacyDialog(context),
                    );
                  },
                ),
              ],
            )
            ),

          ),*/

            //button
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10),
                  child: sendOtpButton()),
            )
          ]),
        ));
  }

  Widget otpBlock() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: AnimatedContainer(
          duration: Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
          height: _otpBlockHeight,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, blurRadius: 50.0, spreadRadius: 5.0)
            ],
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0)),
            color: Colors.white,
          ),
          child: Stack(children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                  padding: EdgeInsets.all(15.0),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_outlined),
                    onPressed: () {
                      openPhoneBlock();
                    },
                  )),
            ),

            //text
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: EdgeInsets.all(20.0),
                child: phoneNumCtrl.text != null && phoneNumCtrl.text != ''
                    ? RichText(
                        textScaleFactor: 1.0,
                        text: TextSpan(
                          text: 'OTP Verification\n',
                          style: TextStyle(
                              fontSize: 19.0, height: 1.5, color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Please enter the OTP sent to ' +
                                    phoneNumCtrl.text.substring(0, 3) +
                                    'XXXXXX' +
                                    phoneNumCtrl.text.substring(
                                        phoneNumCtrl.text.length - 2,
                                        phoneNumCtrl.text.length),
                                style: TextStyle(
                                    fontSize: 11.0, color: Colors.grey)),
                          ],
                        ))
                    : SizedBox(
                        height: 0.0,
                        width: 0.0,
                      ),
              ),
            ),

            //phone code
            Align(
                alignment: Alignment.center,
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.90,
                    padding: EdgeInsets.only(top: 110.0, left: 0.0, right: 0.0),
                    child: Column(children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            otpNumberField(otpFieldCtrl1),
                            otpNumberField(otpFieldCtrl2),
                            otpNumberField(otpFieldCtrl3),
                            otpNumberField(otpFieldCtrl4),
                            otpNumberField(otpFieldCtrl5),
                            otpNumberField(otpFieldCtrl6),
                          ])
                    ]))),

            //button
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10),
                  child: confirmOtpButton()),
            )
          ]),
        ));
  }

  Widget phoneCode() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.20,
      constraints: const BoxConstraints(maxWidth: 500),
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: CupertinoTextField(
        textAlign: TextAlign.center,
        padding: const EdgeInsets.only(left: 5),
        decoration: BoxDecoration(
            color: HexColor('#D2E1D2'),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        controller: phoneCodeCtrl,
        //clearButtonMode: OverlayVisibilityMode.editing,
        keyboardType: TextInputType.phone,
        maxLines: 1,
        maxLength: 3,
        placeholder: '+91',
        placeholderStyle: TextStyle(color: Colors.black45, fontSize: 17.0),
        style: TextStyle(fontSize: 17.0),
      ),
    );
  }

  Widget phoneNumber() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.80,
      constraints: const BoxConstraints(maxWidth: 500),
      margin: const EdgeInsets.only(left: 0, right: 10),
      child: CupertinoTextField(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
            color: HexColor('#D2E1D2'),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        controller: phoneNumCtrl,
        clearButtonMode: OverlayVisibilityMode.editing,
        keyboardType: TextInputType.phone,
        maxLines: 1,
        //minLength: 3,
        maxLength: 10,
        placeholder: 'Enter Phone Number',
        placeholderStyle: TextStyle(color: Colors.black45, fontSize: 17.0),
        style: TextStyle(fontSize: 17.0),
      ),
    );
  }
/*
  Widget _buildPrivacyText() {
    return new RichText(
      text: new TextSpan(
        text: 'Privacy & Policy'
            '.\n\n',
        style: const TextStyle(fontSize: 15.0, height: 1.3, color: Colors.black, fontFamily: 'Product Sans', fontWeight: FontWeight.w500),
        children: <TextSpan>[
          const TextSpan(text: 'Privacy & Policy'),
          const TextSpan(
            text: ' Privacy & Policy',
          ),

          const TextSpan(text: '.'),
        ],
      ),
    );
  }
*/

  Widget _buildAboutText() {
    return SingleChildScrollView(
        padding: new EdgeInsets.all(8.0),
        child: Text(data,
            textScaleFactor: 1.0,
            style: TextStyle(fontFamily: 'Product Sans')));
  }

  Widget _buildAboutDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Terms & Conditions'),
      content: SingleChildScrollView(
          padding: new EdgeInsets.all(8.0),
          child: Text(data,
              textScaleFactor: 1.0,
              style: TextStyle(fontFamily: 'Product Sans'))),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Accept'),
        ),
      ],
    );
  }

/*


  Widget _buildPrivacyDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Privacy & Policy'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildPrivacyText(),
          // _buildLogoAttribution(),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Accept'),
        ),
      ],
    );
  }
*/

  Widget sendOtpButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      constraints: const BoxConstraints(maxWidth: 500),
      child: RaisedButton(
        onPressed: () {
          FocusScope.of(context).unfocus();
          if (phoneCodeCtrl.text.isEmpty) {
            Flushbar(
              title: "Error",
              message: 'Please enter correct Country Code',
              duration: Duration(seconds: 3),
            )..show(context);
          } else if (phoneNumCtrl.text.isEmpty) {
            Flushbar(
              title: "Error",
              message: 'Please enter correct Mobile Number',
              duration: Duration(seconds: 3),
            )..show(context);
          } else if (valuefirst == false) {
            Flushbar(
              title: "Error",
              message: 'Please accept our terms and conditions',
              duration: Duration(seconds: 3),
            )..show(context);
          } else {
            // openLoadingBlock();
            var phnum =
                phoneCodeCtrl.text.toString() + phoneNumCtrl.text.toString();
            Flushbar(
              title: "Info",
              flushbarPosition: FlushbarPosition.TOP,
              message: 'Sending OTP to given number - ' + phnum,
              duration: Duration(seconds: 3),
            )..show(context);
            registerUser(phnum, context);
          }
        },
        color: Colors.green,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14))),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Send OTP',
                textAlign: TextAlign.center,
                textScaleFactor: 1.0,
                style: TextStyle(color: Colors.white, fontSize: 18.0),
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

  Widget confirmOtpButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      constraints: const BoxConstraints(maxWidth: 500),
      child: RaisedButton(
        onPressed: () async {
          FocusScope.of(context).unfocus();
          if (otpFieldCtrl1.text.isEmpty ||
              otpFieldCtrl2.text.isEmpty ||
              otpFieldCtrl3.text.isEmpty ||
              otpFieldCtrl4.text.isEmpty ||
              otpFieldCtrl5.text.isEmpty ||
              otpFieldCtrl6.text.isEmpty) {
            GlobalActions.showToast_Error(
                "Error", 'Please enter correct OTP Code', context);
          } else {
            openLoadingBlock();
            print('verificationId -- ' + verificationId);
            String smsCode = otpFieldCtrl1.text +
                otpFieldCtrl2.text +
                otpFieldCtrl3.text +
                otpFieldCtrl4.text +
                otpFieldCtrl5.text +
                otpFieldCtrl6.text;
            print('smscode -- ' + smsCode);
            // Create a PhoneAuthCredential with the code
            PhoneAuthCredential phoneAuthCredential =
                PhoneAuthProvider.credential(
                    verificationId: verificationId, smsCode: smsCode);
            final UserCredential authResult =
                await _auth.signInWithCredential(phoneAuthCredential);
            if (authResult != null && authResult.user.uid != null) {
              print(authResult.user.uid);
              saveLoginAndDeviceInfo(authResult.user.uid.toString());
            } else {
              GlobalActions.showToast_Error(
                  "Error", 'Login failed, Please enter correct OTP.', context);
            }
          }
        },
        color: Colors.green,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14))),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Confirm',
                textAlign: TextAlign.center,
                textScaleFactor: 1.0,
                style: TextStyle(color: Colors.white, fontSize: 18.0),
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

  Widget otpNumberField(TextEditingController fCtrl) {
    return Container(
      height: 60,
      width: 50,
      constraints: const BoxConstraints(maxWidth: 50),
      margin: const EdgeInsets.only(left: 0, right: 0),
      child: CupertinoTextField(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: HexColor('#D2E1D2'),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        controller: fCtrl,
        clearButtonMode: OverlayVisibilityMode.never,
        keyboardType: TextInputType.phone,
        maxLines: 1,
        style: TextStyle(fontSize: 23.0, color: HexColor('#206520')),
        placeholderStyle: TextStyle(color: Colors.black45),
        textAlign: TextAlign.center,
        cursorColor: Colors.blueGrey.shade300,
        cursorWidth: 5,
        cursorHeight: 1.0,
        maxLength: 1,
        onChanged: (value) {
          if (value.isNotEmpty) {
            FocusScope.of(context).nextFocus();
          } else {
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
  }

  void saveLoginAndDeviceInfo(String userID) {
    try {
      AppConfig.storage.deleteAll();
      AppConfig.storage.write(key: 'userID', value: userID);
      AppConfig.storage
          .write(key: 'phoneID', value: phoneCodeCtrl.text + phoneNumCtrl.text);
      AppConfig.userID = userID;
      CollectionReference customer = AppConfig.firestore.collection('Customer');

      customer.doc(userID).set({
        'Phone_Number': phoneCodeCtrl.text + ' ' + phoneNumCtrl.text,
        'Referal_Code':
            userID.toUpperCase().substring(userID.length - 5, userID.length),
        'Created_On': DateTime.now(),
        'Device_Brand': AppConfig.deviceInfo.brand,
        'Device_Display': AppConfig.deviceInfo.display,
        'Device_Model': AppConfig.deviceInfo.model,
        'Device_OS': AppConfig.deviceInfo.version.baseOS,
        'Device_ID': AppConfig.deviceInfo.androidId,
        'FCM_Token': AppConfig.fcmToken
      }).then((value) {
        print("User Added");
        Navigator.pushReplacementNamed(context, '/myapp');
      }).catchError((error) => print("Failed to add user: $error"));
    } catch (err) {}
  }

  Future registerUser(String mobile, BuildContext context) async {
    _auth = FirebaseAuth.instance;

    if (AppConfig.deviceInfo.isPhysicalDevice) {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: mobile,
        timeout: Duration(seconds: 1),
        verificationCompleted: (PhoneAuthCredential credential) async {
          openLoadingBlock();
          final UserCredential authResult =
              await _auth.signInWithCredential(credential);
          print(authResult.user.uid);
          saveLoginAndDeviceInfo(authResult.user.uid.toString());
        },
        verificationFailed: (FirebaseAuthException e) {
          print('verificationFailed --- ' + e.toString());
          openPhoneBlock();
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
            GlobalActions.showToast_Error(
                'Error', 'The provided phone number is not valid.', context);
          }
        },
        codeSent: (String verifyId, int resendToken) async {
          verificationId = verifyId;
          openOtpBlock();
        },
        codeAutoRetrievalTimeout: (String verifyId) {
          print('timeout code auto retrievel');
          verificationId = verifyId;
        },
      );
    } else {
      AppConfig.currentPosition = LatLng(
          // 37.3797536, -122.1017334);
          12.9732162,
          77.7503997);
      //18.1091, 83.1398);
      Navigator.of(context).pushReplacementNamed('/index');
    }
  }
}
