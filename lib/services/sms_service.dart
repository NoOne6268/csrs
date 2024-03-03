import 'package:csrs/services/contact_services.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:permission_handler/permission_handler.dart';

class SMSService {
  const SMSService._();

  static void _sendSMS(String message, List<String> recipients) async {
    // permission is required for sending sms
    if (await Permission.sms.isRestricted) {
      await Permission.sms.request();
    }

    String _result = await sendSMS(message: message, recipients: recipients ,sendDirect: true)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }

  static void sendSMSToContacts(String email, String message) async {
    try {
      List<String> recipients = [];
      var response = await ContactServices.getContacts(email).then((value) {
        var contacts = value['data'];
        print('contacts are $contacts');
        for (var contact in contacts) {
          if (contact['contactPhone'] != null) {
            recipients.add(contact['contactPhone']);
          }
        }
      }).catchError((e) {
        print('error in fetching contacts is : $e');
      });

      _sendSMS(message, recipients);
    } catch (e) {
      print('error in sending sms is : $e');
    }
  }
}
