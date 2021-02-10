

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:device_info/device_info.dart';
import 'package:eatinom/Pages/App/AppConfig.dart';
import 'package:eatinom/Pages/App/Splash.dart';
import 'package:eatinom/Util/PushNotifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class AppStart extends StatefulWidget{
  AppStart_State createState() => AppStart_State();
}

class AppStart_State extends State<AppStart> {
  bool appLoaded = false;
  bool hasError = false;
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  @override
  void initState(){
    checkPermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext con) {
    print('AppStart****************');
    AppConfig.context = con;
    loadAppConfig();
    return Splash();
  }

  Future<void> checkPermissions() async {
    try{
      Map<Permission, PermissionStatus> statuses = await [Permission.sms,Permission.location, Permission.locationAlways,Permission.storage].request();
    }
    catch(err){}
  }

  Future<bool> loadAppConfig() async{
    try{
      WidgetsFlutterBinding.ensureInitialized();

      ConnectivityResult result = await Connectivity().checkConnectivity();
      if(result.toString() != 'ConnectivityResult.wifi' && result.toString() != 'ConnectivityResult.mobile')  {
        Navigator.pushReplacementNamed(context, '/nointernet');
        return true;
      }


      //Initializing Firebase
      await Firebase.initializeApp();
      print("Firebase initiated");

      //Get Device Info
      AppConfig.deviceInfo = await deviceInfoPlugin.androidInfo;
      print("DeivceInfo Data Fetched");

      //Firebase Database
      AppConfig.firestore = FirebaseFirestore.instance;

      await PushNotifications.initialize();

      //local Storage
      AppConfig.storage = new FlutterSecureStorage();
      String userID = await AppConfig.storage.read(key: 'userID');
      AppConfig.userID = userID;
      String phoneID = await AppConfig.storage.read(key: 'phoneID');
      AppConfig.phoneID = phoneID;
      if(userID != null && userID != ''){
        try{
          bool isLocationServiceEnabled  = await Geolocator.isLocationServiceEnabled();
          if(isLocationServiceEnabled){
            Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
            if(position != null){
              AppConfig.currentPosition = LatLng(position.latitude , position.longitude);
              final coordinates = new Coordinates(position.latitude, position.longitude);
              var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
              AppConfig.currentAddress = addresses.first.addressLine;
              //AppConfig.subLocality = addresses.first.locality;
              //AppConfig.locality = addresses.first.subAdminArea;

              if(addresses.first.subLocality != null){
                AppConfig.subLocality = addresses.first.subLocality;
                AppConfig.locality = addresses.first.locality;
              }
              else if(addresses.first.subAdminArea != null){
                AppConfig.subLocality = addresses.first.locality;
                AppConfig.locality = addresses.first.subAdminArea;
              }
              else{
                AppConfig.subLocality = addresses.first.addressLine;
                AppConfig.locality = addresses.first.locality;
              }

            }
            else{
              Navigator.pushReplacementNamed(context, '/nolocation');
              return true;
            }
          }
          else{
            Navigator.pushReplacementNamed(context, '/nolocation');
            return true;
          }
        }on PlatformException catch (err) {
          // Handle err
          print('Platform exception Error -- '+err.toString());
        }
        Navigator.pushReplacementNamed(context, '/index');
      }else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }

    catch(err){
      print('AppStart Error -- '+err.toString());
      Navigator.pushReplacementNamed(context, '/apperror');
    }
  }




}