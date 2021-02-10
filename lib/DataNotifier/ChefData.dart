import 'dart:async';
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatinom/DataNotifier/ChefItemData.dart';
import 'package:eatinom/Pages/App/AppConfig.dart';
import 'package:eatinom/Util/GlobalActions.dart';
import 'package:flutter/material.dart';

class ChefData{
  static Map<String, DocumentSnapshot> availableChefs = new Map<String,DocumentSnapshot>();
  static Map<String,DocumentSnapshot> availableChefs_Instant = new Map<String,DocumentSnapshot>();
  static Map<String,DocumentSnapshot> availableChefs_Pre = new Map<String,DocumentSnapshot>();
  static List<DocumentSnapshot> topChefs_Instant = new List<DocumentSnapshot>();
  static List<DocumentSnapshot> topChefs_Pre = new List<DocumentSnapshot>();
  static List<String> availableChefIDs_Instant = new List<String>();
  static List<String> availableChefIDs_Pre = new List<String>();
  static StreamSubscription ChefSubscription_Instant;
  static StreamSubscription ChefSubscription_Pre;
  static ValueNotifier notifier = ValueNotifier(0);
  static void callNotifier() {
    notifier.value++;
  }


  static void dispose(){
    if (ChefSubscription_Instant != null) ChefSubscription_Instant.cancel();
    if (ChefSubscription_Pre != null) ChefSubscription_Pre.cancel();
  }

  static void initialize(){
    print('chef data initialize');
    availableChefs_Instant = new Map<String,DocumentSnapshot>();
    availableChefs_Pre = new Map<String,DocumentSnapshot>();
    availableChefIDs_Instant = new List<String>();
    availableChefIDs_Pre = new List<String>();
//    ChefSubscription_Instant = FirebaseFirestore.instance.collection('Chef').where('Available_For',arrayContains: 'Instant').where('Available', isEqualTo: true).orderBy('Rating', descending: true).snapshots().listen((data) {
    ChefSubscription_Instant = FirebaseFirestore.instance.collection('Chef').where('Available_For',arrayContains: 'Instant').where('Available', isEqualTo: true).orderBy('Rating', descending: true).snapshots().listen((data) {

      if(data != null && data.size > 0){
        print('availableChefIDs_Instant --- '+data.docs.length.toString());
        print('chef data ');
        if(AppConfig.searchRadius == null){
          AppConfig.searchRadius = 10.0;
        }

        availableChefIDs_Instant = new List<String>();
        availableChefs_Instant = new Map<String,DocumentSnapshot>();
        topChefs_Instant = new List<DocumentSnapshot>();
        data.docs.forEach((dt) {
          if(dt['Current_Latitude'] != null){
            double distCalc = GlobalActions.calculateDistance(AppConfig.currentPosition.latitude , AppConfig.currentPosition.longitude , dt['Current_Latitude'] , dt['Current_Longitude']);
            if(distCalc <= AppConfig.searchRadius){
              availableChefs_Instant[dt.id] = dt;
              availableChefIDs_Instant.add(dt.id);
            }
          }
        });

        int cnt = 0;
        availableChefs_Instant.values.forEach((chef) {
          if(cnt < 5){
            topChefs_Instant.add(chef);
            cnt++;
          }
        });

        print('topChefs_Instant  -- '+topChefs_Instant.length.toString());

      }

      callNotifier();
      ChefItemData.initialize();
    });


    ChefSubscription_Pre = FirebaseFirestore.instance.collection('Chef').where('Available_For',arrayContains: 'Pre').where('Active',isEqualTo: true).where('Available', isEqualTo: true).orderBy('Rating', descending: true).snapshots().listen((data) {
      if(data != null && data.size > 0){

        if(AppConfig.searchRadius == null){
          AppConfig.searchRadius = 10.0;
        }

        availableChefIDs_Pre = new List<String>();
        availableChefs_Pre = new Map<String,DocumentSnapshot>();
        topChefs_Pre = new List<DocumentSnapshot>();
        data.docs.forEach((dt) {
          if(dt['Current_Latitude'] != null){
            double distCalc = GlobalActions.calculateDistance(AppConfig.currentPosition.latitude , AppConfig.currentPosition.longitude , dt['Current_Latitude'] , dt['Current_Longitude']);
            if(distCalc <= AppConfig.searchRadius){
              availableChefs_Pre[dt.id] = dt;
              availableChefIDs_Pre.add(dt.id);
            }
          }
        });

        int cnt = 0;
        availableChefs_Pre.values.forEach((chef) {
          if(cnt < 5){
            topChefs_Pre.add(chef);
            cnt++;
          }
        });
        print('topChefs_Pre  -- '+topChefs_Pre.length.toString());

      }
      callNotifier();
      ChefItemData.initialize();
    });
  }


  static DocumentSnapshot getChef(String chefID){
      if(availableChefs_Instant.containsKey(chefID)){
        return availableChefs_Instant[chefID];
      }
      else if(availableChefs_Pre.containsKey(chefID)){
        return availableChefs_Pre[chefID];
      }
  }


}