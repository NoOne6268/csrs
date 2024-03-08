import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:csrs/pages/home.dart';
import 'package:go_router/go_router.dart';

import '../utils/custom_widgets.dart';

class CountdownScreen extends StatefulWidget {
  const CountdownScreen({super.key, required this.email, required this.name});

  final String? email;
  final String? name;

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: kBackAppbar(
        context,
        color: const Color(0xFFEB5151),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Please Wait...',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            const Text(
              'Generating SOS in',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            CircularCountDownTimer(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 2,
              strokeWidth: 15.0,
              duration: 10,
              fillColor: const Color(0xFFEB5151),
              ringColor: Colors.white,
              textFormat: CountdownTextFormat.MM_SS,
              textStyle: const TextStyle(
                fontSize: 33,
                fontWeight: FontWeight.bold,
              ),
              isReverse: true,
              isReverseAnimation: true,
              autoStart: true,
              onComplete: () {
                context.pushNamed('/sos', queryParameters: {
                  'email': widget.email,
                  'name': widget.name
                });
              },
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB6A4A4),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFFEB5151),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void ConfirmationAlert(BuildContext context) {
  var alertDialog = AlertDialog(
    title: const Text('Confirmation'),
    content: const Text('Are you sure you are safe?'),
    actions: [
      ElevatedButton(
        onPressed: () {
          // fetchContacts(false);
          Navigator.pushReplacementNamed(context, '/home');
        },
        child: const Text('Yes'),
      ),
      ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('No'),
      ),
    ],
  );
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      });
}
