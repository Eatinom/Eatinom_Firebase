import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppError extends StatefulWidget {
  static const routeName = '/AppErrorImage';
  @override
  _AppErrorState createState() => _AppErrorState();
}

class _AppErrorState extends State<AppError> {
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
                  Icon(Icons.error_outline,color: Colors.red,size: 100.0),
                  SizedBox(height: 50.0),
                  Text('Whoops!',textScaleFactor: 1.0,style: TextStyle(color:Colors.redAccent,fontSize: 40,fontWeight:FontWeight.w500,fontFamily: 'Product Sans' )),
                  SizedBox(height: 20.0),
                  Text('Something went wrong \n Error while loading app',textScaleFactor: 1.0,style: TextStyle(fontSize:18,color: Colors.redAccent,fontWeight: FontWeight.w400,fontFamily: 'Product Sans'),textAlign: TextAlign.center,),
                  SizedBox(height: 10.0),
                ],
              ),
            )
        ),
        Align(alignment: Alignment.bottomCenter,child: Container(
          width: double.infinity,
          child: RaisedButton(padding: EdgeInsets.all(15.0),
            child: Text(
              "RETRY",textScaleFactor: 1.0,
              style: TextStyle(color: Colors.white,fontSize: 18.0),
            ),
            color: Colors.blueGrey.withOpacity(0.6),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/myapp');
            },
          ),
        )),
      ]),

    );
  }
}
