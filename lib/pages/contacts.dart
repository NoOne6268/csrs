import 'dart:convert';

import 'package:csrs/services/contact_services.dart';
import 'package:csrs/utils/custom_dialogue_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:go_router/go_router.dart';

import '../utils/custom_widgets.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final FlutterContactPicker _contactPicker = FlutterContactPicker();

  void takeContact(Contact contact) {
    String? name = contact.fullName;
    String? phoneNo = contact.phoneNumbers?[0];
    // TODO: Add backend function
  }

  //array of contacts
  List<Contact> contacts = [];
@override
void initState() {
  super.initState();
 var response = ContactServices.getContacts('harsagra3478@gmail.com');
  print('contacts are' + response.toString());
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kBackAppbar(
        context,
        color: const Color(0xFF506D85),
        isTitle: true,
        titleText: 'Your Contacts',
      ),
      // rendering the list of contacts using listview builder
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: contacts.length,
        itemBuilder: (BuildContext context, int index) {
          return kContactTile(
              name: contacts[index].fullName!,
              imageUri: null,
              phoneNo: contacts[index].phoneNumbers![0]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF506D85),
        onPressed: () async {
          Contact? contact = await _contactPicker.selectContact();
          takeContact(contact!);
          //push the picked contact to the array
          // if the contact is already present in array then show a dialogue box to the user

          if (contacts
              .map((item) => item.phoneNumbers![0])
              .contains(contact.phoneNumbers![0])) {
            kshowDialogue(context, 'contact is already added',
                'The contact you are trying to add is already present in the list. Please try adding another contact.');

          } else {
            setState(() {
              contacts.add(contact);
            });
            var response = await ContactServices.saveContact('harsagra3478@gmail.com', contact.fullName!, contact.phoneNumbers![0]);
            print('response is : ${response['message']}');
            kshowDialogue(context, response['status'].toString()! == 'true' ? 'success' : 'failed', response['message']!);
          }
          // setState(() {
          //   contacts.add(contact);
          // });
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color(0xFFBBE1FA),
    );
  }
}


