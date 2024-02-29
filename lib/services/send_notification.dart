
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:csrs/services/location.dart';
import 'package:flutter/foundation.dart';

class NotificationServices{
  // Future<void> sendNotificationSafe(String token, User currentUser) async {
  //   try {
  //     Location location = Location();
  //     Map locationData = await location.getLocation();
  //     // User? currentUser = FirebaseAuth.instance.currentUser;
  //     print('current user is $currentUser');
  //     var data = {
  //       "notification": {
  //         "body": "See ${currentUser.displayName}'s last location",
  //         "title": "${currentUser.displayName} is safe now",
  //       },
  //       "priority": "high",
  //       "data": {
  //         "type": "msj",
  //         "id": "uniqueId",
  //         "status": "done",
  //         "langitude": locationData['langitude'].toString(),
  //         "longitude": locationData['longitude'].toString(),
  //       },
  //       "to": token,
  //     };
  //     try {
  //       await http.post(
  //         Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //         body: jsonEncode(data),
  //         headers: {
  //           'Content-Type': 'application/json; charset=UTF-8',
  //           'Authorization':
  //           'key=AAAAuZ-mf_w:APA91bEAdeM38FUcuwwZl07Pkqn7x7DlrRQ1zItXryfTmIUIOKOgYQ-483JogeY5d0q7crAj4VY4dfRL7TU-p4Vyd7NRCA7QyzOOiQDLuMyT2_5AIdaQDmIIO_c3Zfu8xkYVVLytH4Bg'
  //         },
  //       );
  //       if (kDebugMode) {
  //         print(data);
  //       }
  //     } catch (e) {
  //       if (kDebugMode) {
  //         print('Error sending FCM message: $e');
  //       }
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('Error sending FCM message: $e');
  //     }
  //   }
  // }

  // Future<void> sendNotification(String token, User currentUser) async {
  //   try {
  //     Location location = Location();
  //     Map locationData = await location.getLocation();
  //     // User? currentUser = FirebaseAuth.instance.currentUser;
  //     print('current user is $currentUser');
  //     var data = {
  //       "notification": {
  //         "body":
  //         "Click on this notification to get ${currentUser.displayName}'s location",
  //         "title": "${currentUser.displayName} needs help",
  //       },
  //       "priority": "high",
  //       "data": {
  //         "type": "msj",
  //         "id": "uniqueId",
  //         "status": "done",
  //         "langitude": locationData['langitude'].toString(),
  //         "longitude": locationData['longitude'].toString(),
  //       },
  //       "to": token,
  //     };
  //     try {
  //       await http.post(
  //         Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //         body: jsonEncode(data),
  //         headers: {
  //           'Content-Type': 'application/json; charset=UTF-8',
  //           'Authorization':
  //           'key=AAAAuZ-mf_w:APA91bEAdeM38FUcuwwZl07Pkqn7x7DlrRQ1zItXryfTmIUIOKOgYQ-483JogeY5d0q7crAj4VY4dfRL7TU-p4Vyd7NRCA7QyzOOiQDLuMyT2_5AIdaQDmIIO_c3Zfu8xkYVVLytH4Bg'
  //         },
  //       );
  //       if (kDebugMode) {
  //         print(data);
  //       }
  //     } catch (e) {
  //       if (kDebugMode) {
  //         print('Error sending FCM message: $e');
  //       }
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('Error sending FCM message: $e');
  //     }
  //   }
  // }
}