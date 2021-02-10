

import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoInternet_Widget extends StatefulWidget {
  NoInternet_Widget({Key key, this.title}) : super(key: key);
  final String title;

  @override
  NoInternet_WidgetPage createState() => new NoInternet_WidgetPage();
}

class NoInternet_WidgetPage extends State<NoInternet_Widget> {

  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    try{
      initConnectivity();
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    } catch(err){
      print(err);
    }

  }

  @override
  void dispose() {
    try{
    _connectivitySubscription.cancel();
    }catch(err){
      print(err);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    ScreenUtil.init(context);
    ScreenUtil().allowFontScaling = false;

    try{
      return _connectionStatus == 'ConnectivityResult.none' || _connectionStatus == 'error' ? noInternetMessage() : SizedBox(width: 0.0,height: 0.0);
    }
    catch(err){
      print(err);
      return SizedBox(width: 0.0,height: 0.0);
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {

    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        setState(() => _connectionStatus = result.toString());
        break;
      default:
        setState(() => _connectionStatus = 'error');
        break;
    }
  }

  Widget noInternetMessage(){
    try{
      return Align(
          alignment: Alignment.topCenter,
          child: Container(
              color: Colors.red,
              height: 40.0,
              child: Center(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center ,//Center Row contents horizontally,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(padding: EdgeInsets.only(right: 10.0),child: Icon(Icons.wifi_off, color: Colors.white,size: 20.0)),
                        Text('You are Offline',textScaleFactor: 1.0, style: TextStyle(color: Colors.white, fontSize: 15.0))
                      ]
                  )
              )
          )
      );
    }
    catch(err){
      print(err);
      return SizedBox(width: 0.0,height: 0.0);
    }
  }


}