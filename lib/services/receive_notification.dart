import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:csrs/services/location.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class NotificationServices {
  // const NotificationServices._();
   Location location = Location();
  //initialising firebase message plugin
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  void requestNotificationPermission() async {
      NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('user granted permission');
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('user granted provisional permission');
      }
    } else {
      AppSettings.openAppSettings(type: AppSettingsType.notification);
      if (kDebugMode) {
        print('user denied permission');
      }
    }
  }

  Future<String> getToken() async {
    String? token = await messaging.getToken();
    print('FCM Token: $token');
    return token!;
  }

  void initLocalNotifications(BuildContext context , RemoteMessage message) {
    var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings ,
        onDidReceiveNotificationResponse: (payload) async {
          handleMessage(context , message);
          if (kDebugMode) {
            print('notification payload: ${payload.toString()}');
          }
        });
  }
  void handleMessage(BuildContext context , RemoteMessage message){
    if(message.data['type'] == 'msj'){
      // Navigator.push(context , MaterialPageRoute(builder: (context) => const Home()));
      var langitude = double.parse(message.data['langitude']);
      var longitude = double.parse(message.data['longitude']);
      location.redirect(langitude , longitude );
      print('redirecting to location');
    }

  }
   void firebaseInit(BuildContext context){
     FirebaseMessaging.onMessage.listen((event) {
       try {
         //remove default from the data , because it is added by firebase , and we are not sending it , so it is causing error , slice first 12 chars and last 1 char
         String receivedData = event.data.toString();
         receivedData =    receivedData.substring(17 , receivedData.length - 2);
         Map<String, dynamic> parsedData = json.decode(receivedData);

         // Create RemoteMessage object
         RemoteMessage remoteMessage = RemoteMessage(
           data: parsedData['data'],
           notification: RemoteNotification(
             title: parsedData['notification']['title'],
             body: parsedData['notification']['body'],
           ),
           messageId: parsedData['messageId'],
         );
          event = remoteMessage;
         if (kDebugMode) {
           print(event.notification!.body);
           print(event.notification!.title);
           print(event.data.toString());
           print(event.data['type']);
         }
         if(Platform.isAndroid){
           initLocalNotifications(context , remoteMessage);
           showNotifications(remoteMessage);
         }else if(Platform.isIOS){
           showNotifications(remoteMessage);
         }
       }catch(e){
         print('error is $e');
       }

     });
   }


  Future<void> showNotifications (RemoteMessage message)async {

    AndroidNotificationDetails androidNotificationDetails =const AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notification',
      channelDescription: 'This notification is used to notify the user',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      icon: '@mipmap/ic_launcher',
      largeIcon:  DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
    );
    const  darwinNotificationDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    var notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );
    Future.delayed(Duration.zero , (){
      _flutterLocalNotificationsPlugin.show(
        1,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
      );
    });

  }

  void isTokenRefreshed() {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      if (kDebugMode) {
        print('token refreshed, new token is : $event');

      }
      var response = http.post(
        Uri.parse('https://csrsserver.onrender.com/update/token',
        ),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<dynamic, dynamic>{
          'email' : 'harsagra3478@gmail.com',
          'token' : event
        }),
      );
    });
  }

  void setUpInteractMessage(BuildContext context)async{
    //when app is terminated
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if(initialMessage != null){
      handleMessage(context , initialMessage);
    }
    // when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context , event);
    });
  }
}


// class NotificationService {
//   const NotificationService._();
//
//   static final FlutterLocalNotificationsPlugin _notificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   static const AndroidNotificationChannel _androidChannel =
//   AndroidNotificationChannel(
//     'high_importance_channel',
//     'high_importance_channel',
//     description: 'description',
//     importance: Importance.max,
//     playSound: true,
//   );
//
//   static NotificationDetails _notificationDetails() {
//     return NotificationDetails(
//       android: AndroidNotificationDetails(
//         _androidChannel.id,
//         _androidChannel.name,
//         channelDescription: _androidChannel.description,
//         importance: Importance.max,
//         priority: Priority.max,
//         playSound: true,
//         icon: '@mipmap/ic_launcher',
//       ),
//       iOS: const DarwinNotificationDetails(),
//     );
//   }
//
//   static Future<void> initializeNotification() async {
//     const AndroidInitializationSettings androidInitializationSettings =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     await _notificationsPlugin.initialize(
//       const InitializationSettings(
//           android: androidInitializationSettings,
//           iOS: DarwinInitializationSettings()),
//     );
//   }
//
//   static void onMessage(RemoteMessage message) {
//     RemoteNotification? notification = message.notification;
//     AndroidNotification? androidNotification = message.notification?.android;
//     AppleNotification? appleNotification = message.notification?.apple;
//
//     if (notification == null) return;
//
//     if (androidNotification != null || appleNotification != null) {
//       _notificationsPlugin.show(
//         notification.hashCode,
//         notification.title,
//         notification.body,
//         _notificationDetails(),
//       );
//     }
//   }
//
//   static void onMessageOpenedApp(BuildContext context, RemoteMessage message) {
//     RemoteNotification? notification = message.notification;
//     AndroidNotification? androidNotification = message.notification?.android;
//     AppleNotification? appleNotification = message.notification?.apple;
//
//     if (notification == null) return;
//
//     if (androidNotification != null || appleNotification != null) {
//       showDialog(
//         context: context,
//         builder: (_) => AlertDialog(
//           title: Text(notification.title ?? 'No Title'),
//           content: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(notification.body ?? 'No body'),
//               ],
//             ),
//           ),
//         ),
//       );
//     }
//   }
// }