

import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:wakelock/wakelock.dart';

class OnBoarding extends StatefulWidget {
  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.pushReplacementNamed(context, '/login');
  }

  Widget _buildImage(String assetName) {
    FocusScope.of(context).requestFocus(new FocusNode());
    return Align(
      child: Image.asset('assets/$assetName.png', width: 300.0,height: 280.0),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {

    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
            padding: EdgeInsets.only(top: 150),
            child: IntroductionScreen(
          key: introKey,
          pages: [
            PageViewModel(
              titleWidget: Text("Fresh Food",textScaleFactor: 1.0, style: TextStyle(color: Colors.black87, fontSize: 25.0, fontFamily: 'Product Sans', fontWeight: FontWeight.w600)),
              bodyWidget: Text("Order from your favourite Home Chef & From Fresh Food.",textScaleFactor: 1.0, textAlign: TextAlign.center, style: TextStyle(color: Colors.blueGrey, fontSize: 18.0, fontFamily: 'Product Sans')),
              image: _buildImage('slide1'),
              decoration: pageDecoration,
            ),
            PageViewModel(
              titleWidget: Text("Fast Delivery",textScaleFactor: 1.0, style: TextStyle(color: Colors.black87, fontSize: 25.0, fontFamily: 'Product Sans', fontWeight: FontWeight.w600)),
              bodyWidget: Text("Place your personal order and make your day more delicious.",textScaleFactor: 1.0, textAlign: TextAlign.center, style: TextStyle(color: Colors.blueGrey, fontSize: 18.0, fontFamily: 'Product Sans')),
              image: _buildImage('slide2'),
              decoration: pageDecoration,
            ),
            PageViewModel(
              titleWidget: Text("Pickup or Delivery",textScaleFactor: 1.0, style: TextStyle(color: Colors.black87, fontSize: 25.0, fontFamily: 'Product Sans', fontWeight: FontWeight.w600)),
              bodyWidget: Text("We make food ordering fast, simple and free - no matter if you order online or cash.",textScaleFactor: 1.0, textAlign: TextAlign.center, style: TextStyle(color: Colors.blueGrey, fontSize: 18.0, fontFamily: 'Product Sans')),
              image: _buildImage('slide3'),
              decoration: pageDecoration,
            ),
            PageViewModel(
              titleWidget: Text("Authentic Food",textScaleFactor: 1.0, style: TextStyle(color: Colors.black87, fontSize: 25.0, fontFamily: 'Product Sans', fontWeight: FontWeight.w600)),
              bodyWidget: Text(" Authentic Food",textScaleFactor: 1.0, textAlign: TextAlign.center, style: TextStyle(color: Colors.blueGrey, fontSize: 18.0, fontFamily: 'Product Sans')),
              image: _buildImage('slide4'),
              decoration: pageDecoration,
            ),
          ],
          onDone: () {
            _onIntroEnd(context);
          },
          onSkip: () => _onIntroEnd(context), // You can override onSkip callback
          showSkipButton: true,
          skipFlex: 0,
          nextFlex: 0,
          skip: const Text('Skip',textScaleFactor: 1.0, style: TextStyle(fontFamily: 'Product Sans', fontSize: 20.0)),
          next: const Icon(Icons.arrow_forward),
          done: const Text('Done', textScaleFactor: 1.0, style: TextStyle(fontFamily: 'Product Sans', fontSize: 20.0)),
          dotsDecorator: const DotsDecorator(
            size: Size(10.0, 10.0),
            color: Color(0xFFBDBDBD),
            activeSize: Size(22.0, 10.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
          ),
        )
      )
    );
  }
}
