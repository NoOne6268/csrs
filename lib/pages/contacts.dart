import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:csrs/services/contact_services.dart';
import 'package:csrs/utils/custom_dialogue_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:go_router/go_router.dart';
import 'package:csrs/models/contact.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/custom_widgets.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key , required this.email});
  final String? email;

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final FlutterContactPicker _contactPicker = FlutterContactPicker();
  bool isLoading = true;

  //array of contacts
  List<MyContact> contacts = [];

  void getContact() async {

      SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.remove('contacts');
      if(prefs.getString('contacts') == null){
        var response = await ContactServices.getContacts(widget.email!);
        setState(() {
          var responseData = response['data'];
          contacts =
              createContactsFromData(responseData.cast<Map<String, dynamic>>());
          isLoading = false;
        });
        print('response is : ${response['data']}');
      }
      else{
        setState(() {
          var responseData = prefs.getString('contacts');
          var data = jsonDecode(responseData!);
          data = data['data'];
          print('response data is : $data');
          contacts =
              createContactsFromData(data.cast<Map<String, dynamic>>());
          isLoading = false;
        });
      }

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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : contacts.isNotEmpty
              ? ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: contacts.length,
                  itemBuilder: (BuildContext context, int index) {
                    return kContactTile(
                      name: contacts[index].contactName!,
                      imageUri: contacts[index].contactImageUrl ?? '',
                      phoneNo: contacts[index].contactPhone!,
                      isDelete : true,
                      onPress: () async {
                        CoolAlert.show(
                          context: context,
                          type: CoolAlertType.confirm,
                          title: ' Delete ${contacts[index].contactName} ?',
                          text: 'Are you sure you want to delete this contact?',
                          confirmBtnText: 'Yes',
                          cancelBtnText: 'No',
                          onConfirmBtnTap: () async {
                            await ContactServices.deleteContact(
                                widget.email!,
                                contacts[index].contactPhone!);
                            setState(() {
                              contacts.removeAt(index);
                            });
                            CoolAlert.show(
                                context: context,
                                type: CoolAlertType.success,
                                title: 'Contact Deleted',
                                text:
                                    'The contact has been deleted successfully');
                          },
                          onCancelBtnTap: () {
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    );
                  },
                )
              : const Center(
                  child: Text(
                    'No contacts added yet',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
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
            // kshowDialogue(context, 'contact is already added',
            //     'The contact you are trying to add is already present in the list. Please try adding another contact.');
            CoolAlert.show(
              context: context,
              type: CoolAlertType.error,
              title: 'Contact already added',
              text:
                  'The contact you are trying to add is already present in the list. Please try adding another contact.',
            );
          } else if (contacts.length >= 5) {
            CoolAlert.show(
              context: context,
              type: CoolAlertType.error,
              title: 'Contact limit reached',
              text:
                  'You can only add upto 5 contacts. Please delete some contacts to add more.',
            );

            // kshowDialogue(context, 'contact limit reached',
            //     'You can only add 5 contacts. Please delete some contacts to add more.');
          } else {
            setState(() {
              contacts.add(myContact);
            });
            // if +91 is present in the phone number then remove it
            if (myContact.contactPhone!.startsWith('+91')) {
              myContact.contactPhone = myContact.contactPhone!.substring(3);
            }
            var response = await ContactServices.saveContact(
                widget.email!,
                myContact.contactName!,
                myContact.contactPhone);
            print('response is : ${response['message']}');

            CoolAlert.show(
              context: context,
              type: CoolAlertType.success,
              title: response['status'].toString()! == 'true' ? 'success' : 'failed',
              text: response['message']!,
            );
          }
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
