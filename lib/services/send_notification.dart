import 'dart:convert';
import 'package:csrs/services/contact_services.dart';
import 'package:http/http.dart' as http;
import 'package:csrs/services/location.dart';
import 'package:flutter/foundation.dart';

class SendNotificationServices {
  const SendNotificationServices._();

  static Location location = Location();
  static String baseUrl = 'https://csrs-server-3928af365723.herokuapp.com';

  static void sendNotification(
      String token, String title, String body, bool isSafe) async {
    try {
      Map locationData = await location.getLocation();
      var response = await http.post(Uri.parse('$baseUrl/send/notification'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<dynamic, dynamic>{
            'token': token,
            'title': title,
            'body': body,
            'isSafe': isSafe,
            'langtiude': locationData['langitude'].toString(),
            'longitude': locationData['longitude'].toString(),
          }));
      if (kDebugMode) {
        print('this is response body : ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error sending FCM message: $e');
      }
    }
  }

  static Future<void> sendNotificationToContacts(
      String title, String body, bool isSafe, String email) async {
    try {
      ContactServices.getContacts(email).then((value) {
        var contacts = value['data'];
        print("sending notification to contacts $contacts");
        for (var contact in contacts) {
          if (contact['userId'] != null) {
            sendNotification(contact['userId'], title, body, isSafe);
            print(contact);
          }
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('error in fetching contacts is : $e');
      }
    }
  }
}
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
// }
