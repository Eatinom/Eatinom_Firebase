import 'package:flutter/material.dart';

class CustomerDataNotifier{
  ValueNotifier valueNotifier = ValueNotifier(0);
  void incrementNotifier() {
    print('rrrrr');
    valueNotifier.value++;
  }
}