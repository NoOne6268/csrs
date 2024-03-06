import 'dart:async';
import 'package:csrs/services/local_notification_service.dart';
import 'package:csrs/services/send_notification.dart';
import 'package:csrs/services/sms_service.dart';
import 'package:csrs/utils/side_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:csrs/services/node_authorization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';
import 'package:popover/popover.dart';
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
    user = await nodeApis.getCurrentUser();
    print('current user got is : $user');

    setState(() {
      user = user['data'];
    });
    print('currentuser is  : ${user.toString()}');
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
                context.push('/cnt');
              },
              icon: SvgPicture.asset('assets/sos_main.svg'),
            ),
            const SizedBox(
              height: 30.0,
            ),
            ElevatedButton(
              onPressed: () {
                // LocalNotificationService.showLocalNotification(
                //     'SOS is ON!!', 'Help is on the way.');
                // SendNotificationServices.sendNotificationToContacts(
                //     'title', 'body', true, 'harsagra3478@gmail.com');
                SMSService.sendSMSToContacts(
                    'harsagra3478@gmail.com', 'message');
              },
              child: const Text('testing button'),
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
                  context.push('/contacts');
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

class ListItems extends StatelessWidget {
  const ListItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          InkWell(
            onTap: () {},
            child: Container(
              height: 50,
              color: Colors.amber[100],
              child: const Center(child: Text('Entry A')),
            ),
          ),
          const Divider(),
          Container(
            height: 50,
            color: Colors.amber[200],
            child: const Center(child: Text('Entry B')),
          ),
          const Divider(),
          Container(
            height: 50,
            color: Colors.amber[300],
            child: const Center(child: Text('Entry C')),
          ),
        ],
      ),
    );
  }
}

_initiateSOSAlert(BuildContext context, int time) async {
  if (time == 0) {
    if (kDebugMode) {
      print('times is 0 now ');
    }
    // fetchContacts();
    Navigator.of(context).pop(); // Dismiss alert dialog
  }

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    // false = user must tap button, true = tap outside dialog
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('SOS will be initiated in ...',
            style: TextStyle(
              fontSize: 30.0,
              color: Colors.black,
            )),
        content: Container(
          margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Text('$time',
              style: const TextStyle(
                  fontSize: 50.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto')),
        ),
        contentPadding: const EdgeInsets.all(10.0),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'cancel',
              style: TextStyle(fontSize: 30, color: Colors.pinkAccent),
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              Navigator.of(context).pop(); // Dismiss alert dialog
            },
          ),
        ],
      );
    },
  );
}
