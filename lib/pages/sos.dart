import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/node_authorization.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {

  late StatelessWidget emergencyList;

  Future<StatelessWidget> _showContacts(BuildContext context) async {
    NodeApis nodeApis = NodeApis();
    bool isLoggedin = await nodeApis.checkLogin();
    Map currentUser;
    if(isLoggedin){
      currentUser = await nodeApis.getCurrentUser();

      var email = currentUser['email'].toString();
      var data;
      print('current user is ${currentUser.toString()}');
      await nodeApis.getContacts(email).then((value) {
        print('value is $value');
        data = value;
      });
      if(data.isNotEmpty){
        var contacts = data['data'];
        print('contacts found $contacts');
        print('contact is ${contacts[0]['contact'].toString()}');
        if (!context.mounted) return Text('Error');
        return ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(contacts[index]['contact'].toString()),
            );
          },
        );
      }
      else {
        print('you dont have any emergency contacts');
        return Text('You dont any emergency contacts');
      }
    }
    else{
      print('you are not logged in');
      return Text('you are not logged in');
    }
  }

  @override
  void initState() {
    // emergencyList = await _showContacts(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
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
          backgroundColor: const Color(0xFFEB5151),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Emergency signal Received.',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            Text(
              'Help is on the way.',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            Image.asset(
                'assets/help.png',
                height: 160,
            ),
            // Expanded(
            //   child: Container(
            //     decoration: const BoxDecoration(
            //       color: Color(0x66EB5151),
            //     ),
            //     child: Column(
            //       children: [
            //         Text('Your Emergency Contacts'),
            //         emergencyList,
            //       ],
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
