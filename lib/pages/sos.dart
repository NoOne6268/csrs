import 'package:cool_alert/cool_alert.dart';
import 'package:csrs/services/local_notification_service.dart';
import 'package:csrs/services/receive_notification.dart';
import 'package:csrs/services/send_notification.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:csrs/utils/custom_widgets.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  late StatelessWidget emergencyList;

  @override
  void initState() {
    // emergencyList = await _showContacts(context);
    super.initState();
    LocalNotificationService.showLocalNotification(
        'SOS is ON!!', 'Help is on the way.');
    SendNotificationServices.sendNotificationToContacts(
        'title', 'body', true, 'harsagra3478@gmail.com');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: kBackAppbar(
        context,
        color: const Color(0xFFEB5151),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ksosText(
                    showText: 'Emergency signal Received.',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ksosText(
                    showText: 'Help is on the way.',
                  ),
                  Image.asset(
                    'assets/help.png',
                    height: 150,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 6.0,
                      backgroundColor: Color(0xFF7ACAA6),
                    ),
                    onPressed: () {
                      CoolAlert.show(
                        context: context,
                        type: CoolAlertType.confirm,
                        title: 'Are you sure you are safe?',
                        confirmBtnText: 'Yup!!',
                        cancelBtnText: 'Miss Tap',
                        onConfirmBtnTap: () {
                          context.push('/home');
                        },
                        onCancelBtnTap: () {
                          Navigator.of(context).pop();
                        },
                      );

                    },
                    child: const Text(
                      'Safe now',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0x99EB5151),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(24),
                    topLeft: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Center(
                        child: Text(
                          'Your Emergency Contacts',
                          style: kHighlightTextStyle,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: 5,
                        itemBuilder: (BuildContext context, int index) {
                          return kContactTile(
                              name: 'Name',
                              imageUri: null,
                              phoneNo: '1234567890',
                              onPress: () {});
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
