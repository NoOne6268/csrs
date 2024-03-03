
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';

class MyContact {
  String contactName;
  String? userId;
  String contactPhone;
  String? contactImageUrl;
  bool isUser;


  MyContact({
    required this.contactName,
    required this.contactPhone,
    this.userId,
    this.contactImageUrl,
    this.isUser = false,
  });

  factory MyContact.fromJson(Map<String, dynamic> json) {
    return MyContact(
      contactName: json['contactName'],
      userId: json['userId'],
      contactPhone: json['contactPhone'],
      contactImageUrl: json['contactImageUrl'],
      isUser: json['isUser'] ?? false,
    );
  }
  factory MyContact.fromContact(Contact contact) {
    return MyContact(
      contactName: contact.fullName ?? '',
      userId: null,
      contactPhone: contact.phoneNumbers![0] ?? '',
      contactImageUrl: null,
      isUser: false ,

    );
  }
}


// Function to convert raw data into Contact objects
List<MyContact> createContactsFromData(List<Map<String, dynamic>> rawData) {
  return rawData.map((data) => MyContact.fromJson(data)).toList();
}