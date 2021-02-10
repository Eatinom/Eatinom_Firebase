
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatinom/Pages/App/AppConfig.dart';
import 'package:eatinom/Pages/Profile/ClaimBonus.dart';
import 'package:eatinom/Pages/Profile/General.dart';
import 'package:eatinom/Pages/Profile/ReferFriend.dart';
import 'package:eatinom/Pages/Profile/ReviewRating.dart';
import 'package:eatinom/Pages/Profile/AppSettings.dart';
import 'package:eatinom/Pages/Profile/YourAddresess.dart';
import 'package:eatinom/Pages/Profile/AppSettings.dart';
import 'package:eatinom/Util/GlobalActions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:responsive_grid/responsive_grid.dart';

class Profile extends StatefulWidget {
  Profile({Key key, this.title}) : super(key: key);
  final String title;

  @override
  ProfilePage createState() => new ProfilePage();
}

class ProfilePage extends State<Profile>{

  String selectedProfilePic = 'ProfilePic1.jpg';
  TextEditingController ctrlFirstName = new TextEditingController();
  TextEditingController ctrlLastName = new TextEditingController();
  TextEditingController ctrlEmail = new TextEditingController();
  TextEditingController ctrlPhone = new TextEditingController();
  TextEditingController ctrlDOB = new TextEditingController();
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
      body: showData()
    );
  }

  Widget showData(){

    return Container(
        child: SingleChildScrollView(
          child: Column(children: [
        //    profilePic(),
            SizedBox(height: 20.0),

            //general link
            InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => General()));
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
                          child: Image.asset('assets/pro1.png', height: 24.0,width: 24.0),
                      ),
                      title: Text('General Profile',textScaleFactor: 1.0, style: TextStyle(color: Colors.black87,fontSize: 17.0,fontFamily: 'Product Sans', fontWeight: FontWeight.w500)),
                      trailing: Image.asset('assets/pro5.png', height: 15.0,width: 15.0),
                    )
                )
            ),


            //Your Addresses link
            InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => YourAddresses()));
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
                          child: Image.asset('assets/Location.png', height: 24.0,width: 24.0),
                      ),
                      title: Text('Your Addresses',textScaleFactor: 1.0, style: TextStyle(color: Colors.black87,fontSize: 17.0,fontFamily: 'Product Sans', fontWeight: FontWeight.w500)),
                      trailing: Image.asset('assets/pro5.png', height: 15.0,width: 15.0),
                    )
                )
            ),


            //Ratings Reviews link
            InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ReviewRating()));
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
                          child: Image.asset('assets/pro4.png', height: 24.0,width: 24.0),
                      ),
                      title: Text('Rating & Reviews',textScaleFactor: 1.0, style: TextStyle(color: Colors.black87,fontSize: 17.0,fontFamily: 'Product Sans', fontWeight: FontWeight.w500)),
                      trailing: Image.asset('assets/pro5.png', height: 15.0,width: 15.0),
                    )
                )
            ),

            //Claim Referal
            InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ClaimBonus()));
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
                      title: Text('Claim Referal Bonus',textScaleFactor: 1.0, style: TextStyle(color: Colors.black87,fontSize: 17.0,fontFamily: 'Product Sans', fontWeight: FontWeight.w500)),
                      trailing: Image.asset('assets/pro5.png', height: 15.0,width: 15.0),
                    )
                )
            ),


            //Refer Friend link
            InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ReferFriend()));
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
                          child: Image.asset('assets/pro2.png', height: 24.0,width: 24.0),
                      ),
                      title: Text('Refer a Friend',textScaleFactor: 1.0, style: TextStyle(color: Colors.black87,fontSize: 17.0,fontFamily: 'Product Sans', fontWeight: FontWeight.w500)),
                      trailing: Image.asset('assets/pro5.png', height: 15.0,width: 15.0),
                    )
                )
            ),

            //Settings link
            InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AppSettings()));
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
                          child: Image.asset('assets/pro3.png', height: 24.0,width: 24.0),
                      ),
                      title: Text('Settings',textScaleFactor: 1.0, style: TextStyle(color: Colors.black87,fontSize: 17.0,fontFamily: 'Product Sans', fontWeight: FontWeight.w500)),
                      trailing: Image.asset('assets/pro5.png', height: 15.0,width: 15.0),
                    )
                )
            ),

            SizedBox(height: 30.0,)

          ]),
        )
    );
  }


  Widget profilePic(){
    try{
      return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('Customer').doc(AppConfig.userID).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if(snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                height: 300.0,
                child: Center(child: CircularProgressIndicator())
            );
          }

          DocumentSnapshot dt = snapshot.data;
          return Container(
            height: MediaQuery.of(context).size.height * 0.30,
            color: HexColor('#f1f1f1'),
            child: Center(
                child: Stack(children: [
                  Align(alignment: Alignment.center, child: Container(
                    width: 90.0,
                    height: 90.0,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(
                            color: Colors.black26,
                            blurRadius: 1.0
                        )]
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: dt.data().containsKey('ProfilePic') ? AssetImage('assets/'+dt['ProfilePic']) : AssetImage('assets/'+selectedProfilePic),
                    ),
                  )),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          height: 65.0,
                          //padding: EdgeInsets.only(bottom: 25.0),
                          child: RichText(textScaleFactor: 1.0,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: dt.data().containsKey('Full_Name') ? dt['Full_Name'] : 'Unknown',
                                style: TextStyle(fontSize: 17.0,color: Colors.orange, fontWeight: FontWeight.w600, fontFamily: 'Product Sans'),
                                children: <TextSpan>[
                                  TextSpan(text: '\n'+dt['Phone_Number'], style: TextStyle(fontSize: 12.0,color: Colors.blueGrey,fontWeight: FontWeight.w400)),
                                ],
                              )
                          )

                      )
                  )
                ])
            ),
          );
        },
      );



    }
    catch(err){
      print(err.toString());
      return SizedBox();
    }
  }


}