

import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatinom/Pages/Offers/Offers.dart';
import 'package:flutter/material.dart';

class ShowAds_Widget extends StatefulWidget {
  @override
  ShowAds_Widget_State createState() => new ShowAds_Widget_State();
}

class ShowAds_Widget_State extends State<ShowAds_Widget> {
  @override
  Widget build(BuildContext context) {
    try
    {
      CollectionReference users = FirebaseFirestore.instance.collection('Banners');
      return StreamBuilder<QuerySnapshot>(
        stream: users.where('IsActive',isEqualTo: true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return SizedBox(width: 0.0,height: 0.0);
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(height: 100.0,child: Center(child: SizedBox(width:20.0,height: 20.0, child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange)))));
          }

          return Container(
            padding: EdgeInsets.only(top: 5.0),
            child: CarouselSlider(
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.20,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                autoPlay: true,
              ),
              items: snapshot.data.documents.map((DocumentSnapshot document) {
                return InkWell(
                  child: Padding(padding: EdgeInsets.only(left:15.0,right: 15.0),child: Image.memory(base64Decode(document.data()['ImageStr']))),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Offers(selectedBanner: document)));
                  },
                );
              }).toList(),
            )
          );

        },
      );
    }catch(err){
      print(err.toString());
      return Container();
    }
  }
}
