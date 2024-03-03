import 'dart:convert';

import 'package:csrs/services/contact_services.dart';
import 'package:csrs/utils/custom_dialogue_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:go_router/go_router.dart';
import 'package:csrs/models/contact.dart';
import '../utils/custom_widgets.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final FlutterContactPicker _contactPicker = FlutterContactPicker();
  bool isLoading = true;

  //array of contacts
  List<MyContact> contacts = [];

  void getContact() async {
    var response = await ContactServices.getContacts('harsagra3478@gmail.com');
    setState(() {
      var responseData = response['data'];
      contacts =
          createContactsFromData(responseData.cast<Map<String, dynamic>>());
      isLoading = false;
    });
    print('response is : ${response['data']}');
  }

  @override
  void initState() {
    super.initState();
    getContact();
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
      body: isLoading ?
      const Center(
        child: CircularProgressIndicator(),
      )
          :
      ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: contacts.length,
        itemBuilder: (BuildContext context, int index) {
          return kContactTile(
              name: contacts[index].contactName!,
              imageUri: contacts[index].contactImageUrl ?? '',
              phoneNo: contacts[index].contactPhone!,
              onPress : ()
          async {
           await ContactServices.deleteContact('harsagra3478@gmail.com', contacts[index].contactPhone!);
            setState(() {
              contacts.removeAt(index);
            });
          },);
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF506D85),
        onPressed: () async {
          Contact? contact = await _contactPicker.selectContact();
          MyContact myContact = MyContact.fromContact(contact!);
          //push the picked contact to the array
          // if the contact is already present in array then show a dialogue box to the user

          if (contacts
              .map((item) => item.contactPhone![0])
              .contains(contact!.phoneNumbers![0])) {
            kshowDialogue(context, 'contact is already added',
                'The contact you are trying to add is already present in the list. Please try adding another contact.');
          }else if(contacts.length >= 5){
            kshowDialogue(context, 'contact limit reached',
                'You can only add 5 contacts. Please delete some contacts to add more.');
          }
          else {
            setState(() {
              contacts.add(myContact);
            });
            var response = await ContactServices.saveContact(
                'harsagra3478@gmail.com', myContact.contactName!,
                myContact.contactPhone);
            print('response is : ${response['message']}');
            kshowDialogue(context,
                response['status'].toString()! == 'true' ? 'success' : 'failed',
                response['message']!);
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


