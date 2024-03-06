import 'package:csrs/services/node_authorization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:flutter_sms/flutter_sms.dart';

Drawer kSideDrawer(BuildContext context, String name, String rollNo,
    String imageUrl, String email) {
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
                foregroundImage: (imageUrl != null || imageUrl != ''
                    ? NetworkImage(imageUrl)
                    : null),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                    Text(
                      rollNo,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 2, horizontal: 15),
          title: const Text(
            'Profile',
            style: TextStyle(fontSize: 30),
          ),
          leading:const Icon(
            Icons.person,
            color: Colors.black,
            size: 30,
          ),
          onTap: () {
            context.pushNamed('profile/edit', queryParameters: {
              'email': email,
              'name': name,
              'rollNo': rollNo,
              'imageUrl': imageUrl
            });
          },
        ),
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 2, horizontal: 15),
          title: const Text(
            'Contacts',
            style: TextStyle(fontSize: 30),
          ),
          leading:const Icon(
            Icons.contact_page,
            size: 30,
            color: Colors.black,
          ),
          onTap: () {
            context.push('/contacts');
          },
        ),
        const ListTile(
          contentPadding:
              EdgeInsets.symmetric(vertical: 2, horizontal: 15),
          title: Text(
            'Settings',
            style: TextStyle(fontSize: 30),
          ),
          leading: Icon(
            Icons.settings,
            size: 30,
            color: Colors.black,
          ),
        ),
        const ListTile(
          contentPadding:
               EdgeInsets.symmetric(vertical: 2, horizontal: 15),
          title: Text(
            'Help',
            style: TextStyle(fontSize: 30),
          ),
          leading: Icon(
            Icons.help,
            size: 30,
            color: Colors.black,
          ),
        ),
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 2, horizontal: 15),
          onTap: () {
            //clear the cookies and go to login page
            NodeApis nodeApis = NodeApis();
            nodeApis.logout(context);
            context.go('/login');
          },
          title: const Text(
            'Logout',
            style: TextStyle(fontSize: 30),
          ),
          leading: const Icon(
            Icons.logout,
            size: 30,
            color: Colors.black,
          ),
        )
      ],
    ),
  );
}
