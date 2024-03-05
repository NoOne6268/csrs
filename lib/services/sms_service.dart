import 'package:csrs/services/contact_services.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:permission_handler/permission_handler.dart';

class SMSService {
  const SMSService._();

  static Future<void> _sendSMS(String message, List<String> recipients) async {
    // permission is required for sending sms
    Permission.sms.request();
    if (await Permission.sms.isRestricted) {
      await Permission.sms.request();
    }

    String _result = await sendSMS(
      message: message,
      recipients: recipients,
      sendDirect: true,
    ).catchError((onError) {
      print(onError);
      // Ensure to return a value or rethrow the error here
      // return ''; // For example, if you want to return a default value
      throw onError; // Or rethrow the error
    });
    print(_result);
  }

  static void sendSMSToContacts(String email, String message) async {
    try {
      List<String> recipients = [];
      var response = await ContactServices.getContacts(email);
      var contacts = response['data'];
      print('contacts are $contacts');
      for (var contact in contacts) {
        if (contact['contactPhone'] != null) {
          recipients.add(contact['contactPhone']);
        }
      }

      await _sendSMS(message, recipients);
      print('sms sent to contacts : $recipients');
    } catch (e) {
      print('error in sending sms is : $e');
    }
  }
}
