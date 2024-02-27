import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:csrs/utils/custom_widgets.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  late StatelessWidget emergencyList;
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
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ksosText(
                    showText: 'Emergency signal Received.',
                  ),
                  const SizedBox(height: 20,),
                  ksosText(
                    showText: 'Help is on the way.',
                  ),
                  Image.asset(
                    'assets/help.png',
                    height: 150,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0x99EB5151),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(24),
                    topLeft: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    Text('Your Emergency Contacts'),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
