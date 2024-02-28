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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kBackAppbar(
        context,
        color: const Color(0xFF506D85),
        isTitle: true,
        titleText: 'Your Contacts',
      ),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return kContactTile(
              name: 'Name', imageUri: null, phoneNo: '1234567890');
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF506D85),
        onPressed: () async {
          Contact? contact = await _contactPicker.selectContact();
          takeContact(contact!);
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
