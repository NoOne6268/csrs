import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:flutter_sms/flutter_sms.dart';



Drawer kSideDrawer(BuildContext context) {
  String? name = "Dummy Name";
  String? rollNo = "20AS10223";
  File? image;

  return Drawer(
    backgroundColor: const Color(0xFFBBE1FA),
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          margin: EdgeInsets.zero,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(24),
              bottomLeft: Radius.circular(24),
            ),
            color: Color(0xFF506D85),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: const AssetImage('assets/static_profile.png'),
                foregroundImage: (image != null ? FileImage(image!) : null),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    Text(name, style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),),
                    Text(rollNo, style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),),
                  ],
                ),
              ),
            ],
          ),
        ),
        ListTile(
          title: Text('Profile'),
          leading: Icon(
            Icons.person,
            color: Colors.black,
          ),
          onTap: () {
            context.push('/profile');
          },
        ),
        ListTile(
          title: const Text('Contacts'),
          leading: Icon(
            Icons.contact_page,
            color: Colors.black,
          ),
          onTap: () {
            context.push('/contact');
          },
        ),
        ListTile(
          title: Text('Settings'),
          leading: Icon(
            Icons.settings,
            color: Colors.black,
          ),
        ),
        ListTile(
          title: Text('Help'),
          leading: Icon(
            Icons.help,
            color: Colors.black,
          ),
        ),
        ListTile(
          onTap: () {
            context.go('/login');
          },
          title: const Text('Logout'),
          leading: const Icon(
            Icons.logout,
            color: Colors.black,
          ),
        )
      ],
    ),
  );
}