
import 'package:eatinom/Pages/PinLocation/PinLocation.dart';
import 'package:eatinom/Pages/PinLocation/PinLocation2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class NoLocation extends StatefulWidget {
  @override
  _NoLocationState createState() => _NoLocationState();
}

class _NoLocationState extends State<NoLocation> {


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    ScreenUtil.init(context);
    ScreenUtil().allowFontScaling = false;

    double width= MediaQuery.of(context).size.width;
    double height= MediaQuery.of(context).size.height;
    return Scaffold(
        body: Stack(children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              width: width,
              height: height,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.location_off,color: Colors.red,size: 100.0),
                  SizedBox(height: 50.0),
                  Text('Whoops!',textScaleFactor: 1.0,style: TextStyle(color:Colors.redAccent,fontSize: 40,fontWeight:FontWeight.w500,fontFamily: 'Product Sans' )),
                  SizedBox(height: 20.0),
                  Text('Location access disabled \n Check your location settings or try again',textScaleFactor: 1.0,style: TextStyle(fontSize:18,color: Colors.redAccent,fontWeight: FontWeight.w400,fontFamily: 'Product Sans'),textAlign: TextAlign.center,),
                  SizedBox(height: 20.0),
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.all(30.0),
                      child: Center(child: Text('Set location manually',textScaleFactor: 1.0, style: TextStyle(color: Colors.blueGrey,fontSize: 20.0,fontFamily: 'Product Sans')))
                    )
                    ,onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PinLocation()));
                  },
                  )
                ],
              ),
            )
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
            width: double.infinity,
            child: RaisedButton(padding: EdgeInsets.all(15.0),
              child: Text(
                "RETRY",textScaleFactor: 1.0,
                style: TextStyle(color: Colors.white,fontSize: 18.0),
              ),
              color: Colors.red,
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/myapp');
              },
            ),
          )),
        ]),

    );
  }
}
