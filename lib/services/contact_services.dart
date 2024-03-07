import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ContactServices {
  const ContactServices._();

  static const String baseUrl =
      'https://csrsserver.onrender.com';

  static Future<Map<String, dynamic>> saveContact(String email,
      String contactName, String contactPhone) async {
    try {
      print(
          "this is email $email and contact name $contactName and contact phone $contactPhone");
      final response = await http.put(
        Uri.parse('$baseUrl/add/contact'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<dynamic, dynamic>{
          'email': email,
          'contactphone': contactPhone,
          'contactname': contactName,
        }),
      );
      print('this is response after saving the contact ${response.body}');
      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove('contacts');
        return {
          'message': jsonDecode(response.body)['message'],
          'status': true
        };
      } else {
        return {
          'message': jsonDecode(response.body)['message'],
          'status': false
        };
      }
    } catch (e) {
      print(e);
      return {'message': 'error : $e', 'status': false};
    }
  }

  static Future<String> deleteContact(String email, String contactPhone) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/delete/contact'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<dynamic, dynamic>{
          'email': email,
          'contactphone': contactPhone,
        }),
      );
      print('this is response after deleting the contact ${response.body}');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('contacts');
      return 'true';
    }
    catch (e) {
      print(e);
      return 'false';
    }
  }
 static Future<Map<String , dynamic>> getContacts(String email)async{
    try {
      final response =await http.get(
        Uri.parse('$baseUrl/getcontacts'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'email': email,
        },
      );
      print('this is response after getting the contacts ${response.body}');
      SharedPreferences prefs= await SharedPreferences.getInstance();
      prefs.setString('contacts', response.body);
      print('contacts is saved in contacts shared preferences');
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return {};
    }
  }
 }

// class ContactServices {
//   Future<void> fetchContacts(bool isAlert) async {
//     try {
//       CollectionReference contacts =
//       FirebaseFirestore.instance.collection('emergency_contacts');
//       User? currentUser = FirebaseAuth.instance.currentUser;
//       QuerySnapshot emergencyContactsQuery =
//       await contacts.where('username', isEqualTo: currentUser!.email).get();
//       if (emergencyContactsQuery.docs.isNotEmpty) {
//         // Update existing document with the new contact
//         Map<String, dynamic> data =
//         emergencyContactsQuery.docs[0].data() as Map<String, dynamic>;
//         var contacts = data['contacts'];
//         print('contacts found $contacts');
//
//         List<dynamic> tokens = data['tokens'];
//         print(
//             'tokens found $tokens , and type of tokens is ${tokens.runtimeType}');
//         // converting tokens in string to list of strings
//
//         for (dynamic token in tokens) {
//           token.toString();
//           print('type of token is ${token.runtimeType}');
//           if (isAlert) {
//             sendNotification(token, currentUser);
//           } else {
//             sendNotificationSafe(token, currentUser);
//           }
//         }
//       } else {
//         print('you dont have any emergency contacts');
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error sending FCM message: $e');
//       }
//     }
//   }
// }
