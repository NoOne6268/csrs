import 'package:csrs/utils/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;
  String? name = 'Jane Doe';
  String? phoneNo = '1234567890';
  bool editName = false;
  bool editPhone = false;

  TextEditingController nameC = TextEditingController();
  TextEditingController phoneC = TextEditingController();
  @override
  void initState() {
    nameC.text = name!;
    phoneC.text = phoneNo!;
    super.initState();
  }

  @override
  void dispose() {
    nameC.dispose();
    phoneC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: kBackAppbar(
        context,
        color: const Color(0xFF506D85),
        isTitle: true,
        titleText: 'Profile',
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 100,
              backgroundImage: const AssetImage('assets/static_profile.png'),
              foregroundImage: (_image != null ? FileImage(_image!) : null),
            ),
            SizedBox(height: 20,),
            kProfileField(
              controller: nameC,
              inputType: TextInputType.name,
              check: editName,
              onPress: () {
                setState(() {
                  editName = !editName;
                });
              },
            ),
            kProfileField(
              controller: phoneC,
              inputType: TextInputType.phone,
                check: editPhone,
                onPress: () {
                  setState(() {
                    editPhone = !editPhone;
                  });
                },
            ),
          ],
        ),
      ),
    );
  }
}
