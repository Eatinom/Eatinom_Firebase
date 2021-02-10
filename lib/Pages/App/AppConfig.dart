

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppConfig{

  //CONSTANTS
  static String version = '2.0.0';
  static String mapsApiKey =

     // 'AIzaSyBNWw1hpoglaQc3JK0Iy3NKQYD0U1Sk39E';
      //'AIzaSyD3RNBqZV6P1Sjhreidq-0q-BEGrUE3ca0';
      'AIzaSyAELNieF2psjXd05ZRn6qDvLNWXZ2jSdNY';


  static BuildContext context;
  static String userID;
  static String orderID;
  static String phoneID;
  static var storage;
  static double searchRadius = 5.0;
  static FirebaseFirestore firestore;
  static FirebaseMessaging firebaseMessaging;
  static String fcmToken;
  static AndroidDeviceInfo deviceInfo;
  static LatLng currentPosition;
  //initialCameraPosition initialLocation;
  static var currentAddress;
  static String subLocality;
  static String locality;
  static String landMark;
  static List<DocumentSnapshot> availableChefs;
  static List<String> availableChefIDs;
  static List<DocumentSnapshot> availableCuisines;
  static List<DocumentSnapshot> availableItems;
  static Map<String , int> cartItems;
  static double BottomBarHeight;
  static double AppBarHeight;
  static Map<String , int> CartItems = new Map<String, int>();
  static bool showReferalPopup = true;

  static bool isItemAdded(String itemID){
    try{
      return CartItems.containsKey(CartItems);
    }
    catch(err){
      print(err);
    }
  }

  static int getItemCount(String itemID){
    try{
      if(CartItems.containsKey(itemID)){
        return CartItems[itemID];
      }
      else{
        return 0;
      }
    }
    catch(err){
      return 0;
    }
  }

  static void increaseItemCount(String itemID){
    try{
      if(CartItems.containsKey(itemID)){
        if(CartItems[itemID] == null){
          CartItems[itemID] = 0;
        }
        CartItems[itemID] = CartItems[itemID] + 1;
      }
      else{
        CartItems[itemID] = 1;
      }
    }
    catch(err){
      CartItems[itemID] = 1;
    }
  }

  static void decreaseItemCount(String itemID){
    try{
      if(CartItems.containsKey(itemID)){
        if(CartItems[itemID] == null || CartItems[itemID] <= 1){
          CartItems.remove(itemID);
        }else{
          CartItems[itemID] = CartItems[itemID] - 1;
        }
      }
    }
    catch(err){
      print(err);
    }
  }



}