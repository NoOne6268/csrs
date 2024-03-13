import 'dart:async';
import 'dart:convert';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:csrs/services/local_notification_service.dart';
import 'package:csrs/services/receive_notification.dart';
import 'package:csrs/services/send_notification.dart';
import 'package:csrs/services/sms_service.dart';
import 'package:csrs/utils/custom_snackbar.dart';
import 'package:csrs/utils/side_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:csrs/services/node_authorization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';
import 'package:popover/popover.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/location.dart';
import '../utils/custom_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  dynamic user = {};

  Future<void> checkCurrentUser() async {
    NodeApis nodeApis = NodeApis();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('currentUser') != null){
      user = jsonDecode(prefs.getString('currentUser')!);
      print('got user from shared prefs and it is : $user');
    }else{
    user = await nodeApis.getCurrentUser();
    print('got user from node apis');
    }
    setState(() {
      user = user['data'];
    });
    print('currnt user saved in shared prefs is : ${prefs.getString('currentUser')}');
  }

  @override
  void initState() {
    checkCurrentUser();
    setState(() {});
    super.initState();
  }

  _showAddWidget(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: const Color(0xFFBBE1FA),
        title: const Center(
            child: Text(
          'Add Widget to Home Screen',
          style: TextStyle(fontSize: 22),
        )),
        content: Steps(texts),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF506D85),
            ),
            child: const Text(
              'OK',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () {
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
        preferredSize: const Size.fromHeight(100.0),
        child: AppBar(
          leading: Builder(builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(
                Icons.menu,
                size: 35,
                color: Colors.white,
              ),
            );
          }),
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
                onTap: () {
                  showPopover(
                    context: context,
                    backgroundColor: Colors.black,
                    bodyBuilder: (context) => ListView(
                      children: [
                        Hero(tag: 'ajdf', child: Text('sjfjslfdjsljfdklj')),
                      ],
                    ),
                    onPop: () => print('Popover was popped!'),
                    direction: PopoverDirection.right,
                    width: 200,
                    height: 400,
                    arrowHeight: 15,
                    arrowWidth: 30,
                  );
                },
                child: const Icon(
                  Icons.notifications,
                  color: Colors.white,
                  size: 35,
                ),
              ),
            )
          ],
          backgroundColor: const Color(0xFF506D85),
        ),
      ),
      drawer: kSideDrawer(context, user['username'].toString(),
          user['rollNo'].toString(), user['imageUrl'].toString(), user['email'].toString()),
      backgroundColor: const Color(0xFFBBE1FA),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Are you in an Emergency?',
              style: kHighlightTextStyle,
            ),
            const SizedBox(
              height: 30.0,
            ),
            IconButton(
              onPressed: () {
                context.pushNamed('/cnt',  queryParameters: {
                  'email': user['email'].toString(),
                  'name': user['username'].toString(),
                });
              },
              icon: SvgPicture.asset('assets/sos_main.svg'),
            ),
            const SizedBox(
              height: 30.0,
            ),
            ElevatedButton(
              onPressed: ()async {
                NodeApis().createEmergency(user['email']);
              },

              child: const Text('testing button'),
            ),ElevatedButton(
              onPressed: ()async {
            NodeApis().resolveEmergency();

              },
              child: const Text('testing button 2'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 136.0,
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(24),
              topLeft: Radius.circular(24),
            ),
            color: Color(0xFF506D85),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              kBottomNavItem(
                'assets/widget.png',
                'Add Widget',
                onEvent: () {
                  _showAddWidget(context);
                },
              ),
              kBottomNavItem(
                'assets/contact.png',
                'Contacts',
                size: 45,
                onEvent: () {
                  context.pushNamed('contacts',
                    queryParameters: {
                      'email': user['email'].toString(),
                    },);
                },
              ),
              kBottomNavItem(
                'assets/add_contact.png',
                'Profile',
                onEvent: () {
                  context.pushNamed('profile/edit' , queryParameters: {
                    'email' : user['email'].toString(),
                    'name' : user['username'].toString(),
                    'rollNo' : user['rollNo'].toString(),
                    'imageUrl' : user['imageUrl'].toString(),
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}



