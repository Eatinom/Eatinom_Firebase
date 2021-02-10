import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatinom/Pages/App/AppConfig.dart';
import 'package:flutter/material.dart';

class CustomerData{
  static DocumentSnapshot Customer;
  ValueNotifier notifier = ValueNotifier(0);
  static StreamSubscription subscription;
  void changeNotifier() {
    notifier.value++;
  }

  static void initialize(){
    print('Customer data initialize');
    subscription = FirebaseFirestore.instance.collection('Customer').doc(AppConfig.userID).snapshots().listen((data) {
      if(data != null){
        Customer = data;
      }
      else{
        Customer = null;
      }
    });
  }
}