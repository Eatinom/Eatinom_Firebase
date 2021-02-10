
import 'package:eatinom/Pages/App/AppConfig.dart';
import 'package:eatinom/Util/GlobalActions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

class PushNotifications{
    static void initialize()
    {
      try
      {
        AppConfig.firebaseMessaging = FirebaseMessaging();
        AppConfig.firebaseMessaging.configure(
          onMessage: (Map<String, dynamic> message) async {
            print("onMessage: $message");
            try {
              if (message.isNotEmpty) {
                dynamic notification = message['notification'];
                if (notification != null) {
                  GlobalActions.showToast_Notification(
                      notification['title'].toString(),
                      notification['body'].toString(), AppConfig.context);
                }
              }
            }catch(err){
              print(err.toString());
            }
          },
          onLaunch: (Map<String, dynamic> message) async {
            print("onLaunch: $message");
            //_navigateToItemDetail(message);
          },
          onResume: (Map<String, dynamic> message) async {
            print("onResume: $message");
            //_navigateToItemDetail(message);
          },
        );

        if(AppConfig.userID == null ||AppConfig.userID == ''){
          AppConfig.firebaseMessaging.getToken().then((String token) {
            print('FCM token -- '+token);
            AppConfig.fcmToken = token;
          });
        }
      }catch(err){

      }
    }
}