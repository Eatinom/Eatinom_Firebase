import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatinom/DataNotifier/ChefData.dart';
import 'package:eatinom/Pages/App/AppConfig.dart';
import 'package:eatinom/Util/GlobalActions.dart';
import 'package:flutter/material.dart';

class ChefItemData{
  static List<DocumentSnapshot> availableChefsItems_Instant = new List<DocumentSnapshot>();
  static List<DocumentSnapshot> availableChefsItems_Pre = new List<DocumentSnapshot>();
  static StreamSubscription ChefItemsSubscription_Instant;
  static StreamSubscription ChefItemsSubscription_Pre;
  static ValueNotifier notifier = ValueNotifier(0);
  static void callNotifier() {
    notifier.value++;
  }


  static void dispose(){
    if (ChefItemsSubscription_Instant != null) ChefItemsSubscription_Instant.cancel();
    if (ChefItemsSubscription_Pre != null) ChefItemsSubscription_Pre.cancel();
  }

  static void initialize(){
    print('chef items data initialize');
    availableChefsItems_Instant = new List<DocumentSnapshot>();
    availableChefsItems_Pre = new List<DocumentSnapshot>();
    print('chef items data initialize1');
    if(ChefData.availableChefIDs_Instant != null && ChefData.availableChefIDs_Instant.length > 0){
      print('chef items data initialize2');
      ChefItemsSubscription_Instant = FirebaseFirestore.instance.collection('ChefItems').where('Chef_Id',whereIn: ChefData.availableChefIDs_Instant).where('Order_Type', isEqualTo: 'Instant').where('Active',isEqualTo: true).where('Available', isEqualTo: true).snapshots().listen((data) {
        if(data != null && data.size > 0){
          availableChefsItems_Instant = data.docs;
          print('chef items data initialize');
        }
        callNotifier();
      });
    }

    if(ChefData.availableChefIDs_Pre != null && ChefData.availableChefIDs_Pre.length > 0){
      ChefItemsSubscription_Pre = FirebaseFirestore.instance.collection('ChefItems').where('Chef_Id',whereIn: ChefData.availableChefIDs_Pre).where('Order_Type', isEqualTo: 'Pre').where('Active',isEqualTo: true).where('Available', isEqualTo: true).snapshots().listen((data) {
        if(data != null && data.size > 0){
          availableChefsItems_Pre = data.docs;
        }
        callNotifier();
      });
    }
  }
}