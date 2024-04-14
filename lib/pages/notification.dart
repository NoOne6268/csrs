import 'package:flutter/material.dart';
import 'package:csrs/utils/custom_widgets.dart';
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key , required this.email});
  final String? email;
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kBackAppbar(context, color: const Color(0xFFEB5151)),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No Notifications',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
