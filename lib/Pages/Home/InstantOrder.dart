

import 'package:eatinom/Pages/Ads/ShowAds_Widget.dart';
import 'package:eatinom/Pages/App/AppConfig.dart';
import 'package:eatinom/Pages/Chef/PopularChefs_Widget.dart';
import 'package:eatinom/Pages/Cuisines/ShowCuisines_Widget.dart';
import 'package:eatinom/Pages/Item/AvailableItems_Widget.dart';
import 'package:eatinom/Pages/TodaysSpecial/TodaySpecial_Widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InstantOrder extends StatefulWidget {
  InstantOrder({Key key}) : super(key: key);

  @override
  InstantOrder_State createState() => new InstantOrder_State();
}

class InstantOrder_State extends State<InstantOrder> with AutomaticKeepAliveClientMixin<InstantOrder>{

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
        PopularChefs_Widget(mode: 'instant'),
        ShowCuisines_Widget(mode: 'instant'),
        TodaySpecial_Widget(mode: 'instant'),
        AvailableItems_Widget(mode: 'instant')
      ]);
    }
    catch(err){
      print(err.toString());
      return Center(child: Text('Error.'));
    }
  }

}