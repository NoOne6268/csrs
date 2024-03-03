import "package:flutter_sms/flutter_sms.dart";
class UserModel {
  final String email;
  final String name;
  final String rollNO;
  final String token;
  final String createdAt;

  const UserModel({
    required this.createdAt,
    required this.name,
    required this.email,
    required this.token,
    required this.rollNO,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    email: json['email'],
    createdAt: json['createdAt'],
    rollNO: json['rollNo'],
    token: json['token'],
    name: json['name'],
  );

  Map<String, dynamic> toJson() => {
    'email': email,
    'token': token,
    'name': name,
    'rollNO': rollNO,
    'createdAt': createdAt,
  };
}