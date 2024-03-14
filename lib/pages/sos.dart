import 'package:cool_alert/cool_alert.dart';
import 'package:csrs/services/contact_services.dart';
import 'package:csrs/services/local_notification_service.dart';
import 'package:csrs/services/node_authorization.dart';
import 'package:csrs/services/receive_notification.dart';
import 'package:csrs/services/send_notification.dart';
import 'package:csrs/services/sms_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:csrs/utils/custom_widgets.dart';

import '../models/contact.dart';
import '../services/location.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({super.key, required this.email, required this.name});

  final String? email;
  final String? name;

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  late StatelessWidget emergencyList;
  List<MyContact> contacts = [];
  bool isLoading = false;
  bool isContactLoading = true;

  void getContact() async {
    var response = await ContactServices.getContacts(widget.email!);
    setState(() {
      var responseData = response['data'];
      contacts =
          createContactsFromData(responseData.cast<Map<String, dynamic>>());
      isContactLoading = false;
    });
    print('response is : ${response['data']}');
  }

  void sosInitiate() async {
    setState(() {
      isLoading = true;
    });
    LocalNotificationService.showLocalNotification(
        'SOS is ON!!', 'Help is on the way.');
    //send location coordinates via sms
    Location location = Location();
    var loc = await location.getLocation();
    print(loc);
    String langitude = loc['langitude'].toString();
    String longitude = loc['longitude'].toString();
    String message = '${widget.name} is in trouble please help him out!!'
        ' This alert is generated through CSRS app and sent to you because you are in ${widget.name}\'s emergency contact list. Click to see ${widget.name}\'s'
        ' location : https://www.google.com/maps/place/$langitude,$longitude';
    print(message);

    SendNotificationServices.sendNotificationToContacts(
        '${widget.name} is in trouble!!',
        'Click on this notification see ${widget.name}\'s location ',
        true,
        widget.email!);
    NodeApis().createEmergency(widget.email!);
    SMSService.sendSMSToContacts(widget.email!, message);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> sosResolved() async {
    setState(() {
      isLoading = true;
    });
    LocalNotificationService.showLocalNotification(
        'SOS is resolved!!', 'It\'s great relief to know that you are safe.');
    //send location coordinates via sms
    Location location = Location();
    var loc = await location.getLocation();
    print(loc);
    String langitude = loc['langitude'].toString();
    String longitude = loc['longitude'].toString();
    String message = '${widget.name} is now out of danger!!'
        ' This alert is generated through CSRS app and sent to you because you are in ${widget.name}\'s emergency contact list. Click to see ${widget.name}\'s'
        ' location : https://www.google.com/maps/place/$langitude,$longitude';
    print(message);
    SendNotificationServices.sendNotificationToContacts(
        '${widget.name} Is Safe Now!!',
        'Click on this notification see ${widget.name}\'s last location',
        true,
        widget.email!);
    NodeApis().resolveEmergency();
    SMSService.sendSMSToContacts(widget.email!, message);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // emergencyList = await _showContacts(context);
    sosInitiate();
    super.initState();
    getContact();
  }

  void showAlert(){
    CoolAlert.show(
      context: context,
      type: CoolAlertType.confirm,
      title: 'Are you sure you are safe?',
      confirmBtnText: 'Yup!!',
      cancelBtnText: 'Miss Tap',
      onConfirmBtnTap: () async {
        await sosResolved();
        context.pushReplacementNamed('/home');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: kBackAppbar(
        context,
        color: const Color(0xFFEB5151),
        isBack: false,
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ksosText(
                          showText: 'Emergency signal Received.',
                        ),
                        const SizedBox(
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
                            showAlert();
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
                          // ElevatedButton(
                          //     onPressed: () {
                          //       sosInitiate();
                          //     },
                          //     child: Text('Send SOS again')),
                          // ElevatedButton(
                          //   onPressed: () {
                          //     sosResolved();
                          //   },
                          //   child: Text('safe sos button'),
                          // ),
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
                            child: isContactLoading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : contacts.isNotEmpty
                                    ? ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: contacts.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return kContactTile(
                                            name: contacts[index].contactName!,
                                            imageUri: contacts[index]
                                                    .contactImageUrl ??
                                                '',
                                            phoneNo:
                                                contacts[index].contactPhone!,
                                            isDelete: false,
                                            onPress: () {},
                                          );
                                        },
                                      )
                                    : const Center(
                                        child: Text(
                                          'No contacts added yet',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
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
