import 'package:flutter/material.dart';

class User {
  late String email;
  late String phoneNo;
  late String rollNo;
  String name = '';
  String imageUrl = '';

  User({
    required this.email,
    required this.phoneNo,
    required this.rollNo
});
}

class UserProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  void updateUser(String mail, String roll, String phone){
    _user = User(email: mail, phoneNo: phone, rollNo: roll);
    notifyListeners();
  }

  void updateInfo(String username, String url){
    _user?.name = username;
    _user?.imageUrl = url;
    notifyListeners();
  }
}
