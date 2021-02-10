



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatinom/Pages/Ads/ShowAds_Widget.dart';
import 'package:eatinom/Pages/App/AppConfig.dart';
import 'package:eatinom/Pages/Chef/PopularChefs_Widget.dart';
import 'package:eatinom/Pages/Cuisines/ShowCuisines_Widget.dart';
import 'package:eatinom/Pages/Item/AvailableItems_Widget.dart';
import 'package:eatinom/Pages/TodaysSpecial/TodaySpecial_Widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PreOrder extends StatefulWidget {
  PreOrder({Key key}) : super(key: key);

  @override
  PreOrder_State createState() => new PreOrder_State();
}

class PreOrder_State extends State<PreOrder> with AutomaticKeepAliveClientMixin<PreOrder>{

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    AppConfig.context = context;

    ScreenUtil.init(context);
    ScreenUtil().allowFontScaling = false;

    return Container(
        child: AppConfig.currentPosition != null ? SingleChildScrollView(
            child: Column(children: [
              ShowAds_Widget(),
              ShowBody()
            ])
        ) : Center(child: CircularProgressIndicator())
    );
  }


  Widget ShowBody(){
    try{
      return Column(children: [
        PopularChefs_Widget(mode: 'preorder'),
        ShowCuisines_Widget(mode: 'preorder'),
        TodaySpecial_Widget(mode: 'preorder'),
        AvailableItems_Widget(mode: 'preorder',)
      ]);
    }
    catch(err){
      print(err.toString());
      return Center(child: Text('Error.'));
    }
  }

}