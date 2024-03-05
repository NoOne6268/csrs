import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:csrs/services/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NodeApis {
  var currentUser = '';
  var currentEmail = '';
  Location location = Location();
  final String baseUrl = 'https://csrsserver.onrender.com';

  Future<String?> getUserID() async {
    String? userID;
    try {
      OneSignal.shared.getDeviceState().then((value) {
        print(
            'user id is : ${value!.userId} , and device state is ${value.jsonRepresentation()}');
        userID = value.userId;
      });
      return userID.toString();
    } catch (e) {
      print('error in getting user id  is $e');
      return 'error';
    }
  }

  Future<void> signUp(String username, String rollNo, String email,
      String phone, BuildContext context) async {
    try {
      String? userID = await getUserID();
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
        // ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text('Registered successfully')));
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Success!',
            message: 'Registered Successfully!',
            contentType: ContentType.success,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
        Navigator.pushReplacementNamed(context, '/login');
      } else if (response.statusCode == 410) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text('Email Provided already Exists')));
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Failure!',
            message: 'Email Provided already Exists!',
            contentType: ContentType.failure,
          ),
        );
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      } else if (response.statusCode == 411 && response.statusCode == 500) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text('Something went wrong')));
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Failure!',
            message: 'Something went wrong!!',
            contentType: ContentType.failure,
          ),
        );
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
    } catch (e) {
      print('error in signup is $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> logIn(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      final String cookies = response.headers['set-cookie'] ?? '';
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('cookie', cookies);
      print('login request body is  : ${jsonDecode(response.body)}');
      if (!context.mounted) return;
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Logged in succesfully')));
        Navigator.pushReplacementNamed(context, '/home');

        print(jsonDecode(response.body));
        print(
            'after login currentuser and currentemail is $currentUser and $currentEmail');
      } else if (response.statusCode == 410) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          'Invalid Password',
          style: TextStyle(color: Colors.pinkAccent),
        )));
      } else if (response.statusCode == 500) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Something went wrong')));
      } else if (response.statusCode == 411) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('User not found')));
      }
    } catch (e) {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text('login function\'s error is ${e.toString()}')));
      print('login function\'s error is ${e.toString()}');
    }
  }

  Future<void> logout(BuildContext context) async {
    currentEmail = '';
    currentUser = '';
    Navigator.pushReplacementNamed(context, '/login');
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
      print('this is response after verifying the otp ${response.body}');
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return {};
    }
  }

  Future<bool> checkLogin() async {
    try {
      final dynamic data = await getCurrentUser();
      print('data is $data');
      if (data == null || data == '' || data == {}) {
        print('returning false');
        return false;
      }
      else {
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
}
