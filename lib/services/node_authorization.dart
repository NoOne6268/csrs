import 'dart:io';
import 'dart:typed_data';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:csrs/utils/custom_snackbar.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'dart:convert';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:csrs/services/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NodeApis {
  Location location = Location();
  final String baseUrl = 'https://csrsserver.onrender.com';

  Future<void> signUp(String username, String rollNo, String email,
      String phone, BuildContext context) async {
    try {
      String? userID = await FirebaseMessaging.instance.getToken();
      print('user id is $userID');
      if (!context.mounted) return;
      final response = await http.post(
        Uri.parse('$baseUrl/signup'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<dynamic, dynamic>{
          'username': username,
          'rollNo': rollNo,
          'email': email,
          'userId': userID,
          'phone': phone
        }),
      );
      print('this is response body : ${response.body}');
      if (!context.mounted) return;
      if (response.statusCode == 200) {
        kSnackBar(context, 'Registered successfully!', 'Success!',
            ContentType.success);
        // Navigator.pushReplacementNamed(context, '/login');
        context.pushNamed('profile/create', queryParameters: {
          'email': email,
          'rollNo': rollNo,
        });
      } else if (response.statusCode == 410) {
        kSnackBar(context, 'Email Provided already Exists!','Failure!', ContentType.warning);
      } else if (response.statusCode == 411 && response.statusCode == 500) {
        kSnackBar(context, 'Something went wrong!!', 'Failure!', ContentType.failure);
      }
    } catch (e) {
      print('error in signup is $e');
  kSnackBar(context, 'Error $e', 'Failure!', ContentType.failure);
    }
  }

  Future<void> logout(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('cookie');
    // Navigator.pushReplacementNamed(context, '/login');
  }

  Future<Map> getContacts(String email) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/getcontacts'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'email': email,
        },
      );
      print('this is response after getting the contacts ${response.body}');
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return {};
    }
  }

  Future<Map> sendOtp(String route, String to, bool isEmail) async {
    try {
      String through = 'phone';
      if (isEmail) {
        through = 'email';
      }
      print('through is $through and sending to $to ');
      final response = await http.post(
        Uri.parse('$baseUrl/$route'),
        body: jsonEncode(<String, String>{
          through: to,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print('this is response after sending the otp ${response.body}');
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return {'message': 'error : $e '};
    }
  }

  Future<Map> verifyOtp(
      String route, String to, String otp, bool isEmail) async {
    try {
      String through = 'phone';
      if (isEmail) {
        through = 'email';
      }
      print('through is $through');
      final response = await http.post(
        Uri.parse('$baseUrl/$route'),
        body: jsonEncode(<String, String>{
          through: to,
          'otp': otp,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      final String cookies = response.headers['set-cookie'] ?? '';
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('cookie', cookies);
      print('this is response after verifying the otp ${response.body}');

      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return {};
    }
  }

  Future<bool> checkLogin() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      dynamic data = {};
      if(prefs.getString('currentUser') != null){
        data = jsonDecode(prefs.getString('currentUser')!);
        print('getting user from shared prefs and it is : $data');
      }
      else{
        data = await getCurrentUser();
      }
      // print('data is $data');
      data = data['data'];
      if (data == null || data == '' || data == {}) {
        print('returning false');
        return false;
      } else {
        print('returning true');
        return true;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<dynamic> getCurrentUser() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? cookie = pref.getString('cookie');
      if (cookie != null) {
        final response = await http.get(
          Uri.parse('$baseUrl/getcurrentuser'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Cookie': cookie,
          },
        );
        var data = jsonDecode(response.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('currentUser', jsonEncode(data));
        return data;
      } else {
        print('cookie is empty');
        return;
      }
    } catch (e) {
      print('error in getting the user is : $e');
      return '';
    }
  }

  Future<dynamic> saveProfile(
      String email, String name, File image, String rollNo) async {
    print('email is $email and name is $name');
    try {
      var formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(image.path, filename: name),
        "email": email,
        "name": name,
        "rollNO": rollNo,
      });
      var response = await Dio().post(
        '$baseUrl/update',
        data: formData,
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.setString('currentUser', jsonEncode(response.data));
      prefs.remove('currentUser');
      print('current user form shared prefs is : ${prefs.getString('currentUser')}');
      print(
          'this is response after saving the profile ${response.data.toString()}');
      return response.data;
    } catch (e) {
      print('error in saving profile is: $e');
      return {};
    }
  }

  Future<List<int>> compressImage(List<int> imageBytes) async {
    // Decode image bytes to Image object
    img.Image image = img.decodeImage(imageBytes as Uint8List)!;
    // Resize the image to reduce dimensions
    image = img.copyResize(image,
        width:
            800); // Resize to a width of 800 pixels, maintaining aspect ratio
    // Encode the image to JPEG format with specified quality (0-100)
    List<int> compressedImageBytes = img.encodeJpg(image, quality: 80);
    return compressedImageBytes;
  }
}
