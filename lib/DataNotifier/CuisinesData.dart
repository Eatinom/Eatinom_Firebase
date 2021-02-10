import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatinom/Pages/App/AppConfig.dart';
import 'package:eatinom/Util/GlobalActions.dart';
import 'package:flutter/material.dart';

class CuisinesData{
  static bool cuisinesDataLoaded = false;
  static List<DocumentSnapshot> instantAvailableCuisines = new List<DocumentSnapshot>();
  static List<DocumentSnapshot> preAvailableCuisines = new List<DocumentSnapshot>();
  static StreamSubscription InstantCusinesSubscription;
  static StreamSubscription PreCusinesSubscription;
  static ValueNotifier notifier = ValueNotifier(0);
  static void callNotifier() {
    notifier.value++;
  }


  static void dispose(){
    if (InstantCusinesSubscription != null) InstantCusinesSubscription.cancel();
    if (PreCusinesSubscription != null) PreCusinesSubscription.cancel();
  }

  static void initialize(){
    print('chef data initialize');
    InstantCusinesSubscription = FirebaseFirestore.instance.collection('App/Cuisines/Instant').where('Active',isEqualTo: true).orderBy('Sequence').snapshots().listen((data) {
      if(data != null && data.size > 0){
        instantAvailableCuisines = data.docs;
        callNotifier();
        print('instantAvailableCuisines -- '+instantAvailableCuisines.length.toString());
        cuisinesDataLoaded = true;
      }
    });

    PreCusinesSubscription = FirebaseFirestore.instance.collection('App/Cuisines/Pre').where('Active',isEqualTo: true).orderBy('Sequence').snapshots().listen((data) {
      if(data != null && data.size > 0){
        preAvailableCuisines = data.docs;
        callNotifier();
        print('preAvailableCuisines -- '+preAvailableCuisines.length.toString());
        cuisinesDataLoaded = true;
      }
    });
  }


}