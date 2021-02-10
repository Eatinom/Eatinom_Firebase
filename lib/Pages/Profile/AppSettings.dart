
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatinom/Pages/App/AppConfig.dart';
import 'package:eatinom/Pages/Profile/About.dart';
import 'package:eatinom/Pages/Profile/FAQ.dart';
import 'package:eatinom/Pages/Profile/Help.dart';
import 'package:eatinom/Pages/Profile/PrivacyPolicy.dart';
import 'package:eatinom/Pages/Profile/TermsConditions.dart';
import 'package:eatinom/Util/GlobalActions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:responsive_grid/responsive_grid.dart';

class AppSettings extends StatefulWidget {
  AppSettings({Key key, this.title}) : super(key: key);
  final String title;

  @override
  AppSettingsPage createState() => new AppSettingsPage();
}

class AppSettingsPage extends State<AppSettings>{
  DocumentSnapshot data;


  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppConfig.context = context;
    ScreenUtil.init(context);
    ScreenUtil().allowFontScaling = false;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.blueGrey, //change your color here
        ),
        title: Text("Notifications",textScaleFactor: 1.0, style: TextStyle(fontFamily: 'Product Sans', color: Colors.blueGrey)),
        backgroundColor: Colors.white,
        //centerTitle: true,
      ),
      body: showData()
    );
  }

  Widget showData(){
    return Container(
        child: SingleChildScrollView(
          child: Column(children: [
            SizedBox(height: 20.0),
            //about link
            InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => About()));
                },
                child: Container(
                    margin: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: HexColor('#f1f1f1'),
                        boxShadow: [BoxShadow(
                          color: Colors.black12,
                          blurRadius: 0.5,
                        )]
                    ),
                    child: ListTile(
                      leading: Container(
                          padding: EdgeInsets.all(7.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blueGrey.shade50,
                              boxShadow: [BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5.0,
                              )]
                          ),
                          child: Icon(Icons.info_outline, color: Colors.orange.shade200,size: 20.0)
                      ),
                      title: Text('About',textScaleFactor: 1.0, style: TextStyle(color: Colors.black87,fontSize: 17.0,fontFamily: 'Product Sans', fontWeight: FontWeight.w500)),
                      trailing: Icon(Icons.arrow_forward_ios,size: 15.0,color: Colors.blueGrey.shade200,),
                    )
                )
            ),


            //Your Addresses link
            InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Help()));
                },
                child: Container(
                    margin: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: HexColor('#f1f1f1'),
                        boxShadow: [BoxShadow(
                          color: Colors.black12,
                          blurRadius: 0.5,
                        )]
                    ),
                    child: ListTile(
                      leading: Container(
                          padding: EdgeInsets.all(7.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blueGrey.shade50,
                              boxShadow: [
                                BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5.0,
                              )
                              ]
                          ),
                          child: Icon(Icons.location_pin, color: Colors.orange.shade200,size: 20.0)
                      ),
                      title: Text('Help',textScaleFactor: 1.0, style: TextStyle(color: Colors.black87,fontSize: 17.0,fontFamily: 'Product Sans', fontWeight: FontWeight.w500)),
                      trailing: Icon(Icons.arrow_forward_ios,size: 15.0,color: Colors.blueGrey.shade200,),
                    )
                )
            ),

            //Ratings Reviews link
            InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TermsConditions()));
                },
                child: Container(
                    margin: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: HexColor('#f1f1f1'),
                        boxShadow: [BoxShadow(
                          color: Colors.black12,
                          blurRadius: 0.5,
                        )]
                    ),
                    child: ListTile(
                      leading: Container(
                          padding: EdgeInsets.all(7.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blueGrey.shade50,
                              boxShadow: [BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5.0,
                              )]
                          ),
                          child: Icon(Icons.star_rate, color: Colors.orange.shade200,size: 20.0)
                      ),
                      title: Text('Terms & Conditions',textScaleFactor: 1.0, style: TextStyle(color: Colors.black87,fontSize: 17.0,fontFamily: 'Product Sans', fontWeight: FontWeight.w500)),
                      trailing: Icon(Icons.arrow_forward_ios,size: 15.0,color: Colors.blueGrey.shade200,),
                    )
                )
            ),

            //Claim Referal
            InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPolicy()));
                },
                child: Container(
                    margin: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: HexColor('#f1f1f1'),
                        boxShadow: [BoxShadow(
                          color: Colors.black12,
                          blurRadius: 0.5,
                        )]
                    ),
                    child: ListTile(
                      leading: Container(
                          padding: EdgeInsets.all(7.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blueGrey.shade50,
                              boxShadow: [BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5.0,
                              )]
                          ),
                          child: Icon(Icons.location_pin, color: Colors.orange.shade200,size: 20.0)
                      ),
                      title: Text('Privacy Policy',textScaleFactor: 1.0, style: TextStyle(color: Colors.black87,fontSize: 17.0,fontFamily: 'Product Sans', fontWeight: FontWeight.w500)),
                      trailing: Icon(Icons.arrow_forward_ios,size: 15.0,color: Colors.blueGrey.shade200,),
                    )
                )
            ),


            //Refer Friend link
            InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FAQ()));
                },
                child: Container(
                    margin: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: HexColor('#f1f1f1'),
                        boxShadow: [BoxShadow(
                          color: Colors.black12,
                          blurRadius: 0.5,
                        )]
                    ),
                    child: ListTile(
                      leading: Container(
                          padding: EdgeInsets.all(7.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blueGrey.shade50,
                              boxShadow: [BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5.0,
                              )]
                          ),
                          child: Icon(Icons.storefront, color: Colors.orange.shade200,size: 20.0)
                      ),
                      title: Text('FAQ',textScaleFactor: 1.0, style: TextStyle(color: Colors.black87,fontSize: 17.0,fontFamily: 'Product Sans', fontWeight: FontWeight.w500)),
                      trailing: Icon(Icons.arrow_forward_ios,size: 15.0,color: Colors.blueGrey.shade200,),
                    )
                )
            ),

            //AppSettings link
            InkWell(
                onTap: (){
                  signout();
                },
                child: Container(
                    margin: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: HexColor('#f1f1f1'),
                        boxShadow: [BoxShadow(
                          color: Colors.black12,
                          blurRadius: 0.5,
                        )]
                    ),
                    child: ListTile(
                      leading: Container(
                          padding: EdgeInsets.all(7.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blueGrey.shade50,
                              boxShadow: [BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5.0,
                              )]
                          ),
                          child: Icon(Icons.logout, color: Colors.orange.shade200,size: 20.0)
                      ),
                      title: Text('Logout',textScaleFactor: 1.0, style: TextStyle(color: Colors.black87,fontSize: 17.0,fontFamily: 'Product Sans', fontWeight: FontWeight.w500)),
                      trailing: Icon(Icons.arrow_forward_ios,size: 15.0,color: Colors.blueGrey.shade200,),
                    )
                )
            ),

            SizedBox(height: 30.0,)

          ]),
        )
    );
  }


  void signout(){

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel", style: TextStyle(fontSize: 18.0)),
      onPressed:  () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Proceed", style: TextStyle(fontSize: 18.0)),
      onPressed:  () async {
        await FirebaseAuth.instance.signOut();
        await AppConfig.storage.deleteAll();
        Navigator.of(context, rootNavigator: true).pushReplacementNamed('/login');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Logout",style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600)),
      content: Text("Are you sure want to logout?"),
      actions: [
        RaisedButton(
          child: Text('Logout'),
          onPressed: null,),
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

  }


}