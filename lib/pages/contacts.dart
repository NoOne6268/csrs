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
  List<Contact>? _contacts;

  _addContact(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: const Color(0xFFBBE1FA),
        title: const Center(
            child: Text(
          'Add Contact',
          style: TextStyle(
            fontSize: 22,
          ),
        )),
        content: TextField(

        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF506D85),
            ),
            child: const Text(
              'Add',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () {
              // TODO: Add backend function
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75.0),
        child: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 35,
            ),
            onPressed: () => context.pop(),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(24),
              bottomLeft: Radius.circular(24),
            ),
          ),
          title: const Center(
            child: Text(
              'Your Contacts',
              style: TextStyle(color: Colors.white, fontSize: 27),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GestureDetector(
                onTap: () {},
                child: const Icon(
                  Icons.more_vert_outlined,
                  color: Colors.white,
                  size: 35,
                ),
              ),
            )
          ],
          backgroundColor: const Color(0xFF506D85),
        ),
      ),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 20,
        itemBuilder: (BuildContext context, int index) {
          return kContactTile(
              name: 'Name', imageUri: null, phoneNo: '1234567890');
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF506D85),
        onPressed: () async {
          Contact? contact = await _contactPicker.selectContact();
          setState(() {
            _contacts = contact == null ? null : [contact];
          });
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
