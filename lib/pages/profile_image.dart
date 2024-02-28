import 'dart:io';

import 'package:flutter/material.dart';
import 'package:csrs/services/image_helper.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:csrs/services/node_authorization.dart';

final imageHelper = ImageHelper();

class ProfileImage extends StatefulWidget {
  const ProfileImage({super.key});
  // final String initials;
  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  File? _image;
  final _formKey = GlobalKey<FormState>();
  NodeApis nodeApis = NodeApis();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.cyan,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(24),
              bottomLeft: Radius.circular(24),
            ),
          ),
          title: const Center(
            child: Text(
              'Profile Update',
              style: TextStyle(color: Colors.white, fontSize: 27),
            ),
          ),
          backgroundColor: const Color(0xFF506D85),
        ),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: CircleAvatar(
                      radius: 64,
                      backgroundColor: Colors.grey[300],
                      foregroundImage: _image != null
                          ? FileImage(_image!)
                          : Image.asset(
                              'assets/static_profile.jpg',
                              semanticLabel: "profile",
                              colorBlendMode: BlendMode.lighten,
                              fit: BoxFit.cover,
                            ).image,
                      child: null
                      // _image == null
                      //     ? Image.asset(
                      //    'assets/images/profile.png',
                      // )
                      //     : null,

                      ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () async {
                  final file = await imageHelper.pickImage();

                },
                child: const Text("upload profile"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    key: const ValueKey('name'),
                    enabled: true,
                    decoration: InputDecoration(
                      labelText: 'name',
                      hintText: 'Enter your name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onFieldSubmitted: (value) {},
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    }),
              ),
              const SizedBox(
                height: 10,
              ),
              MaterialButton(
                // style: ElevatedButton.styleFrom(
                //   primary: Colors.lightGreenAccent,
                //
                // ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (_image == null) {
                      setState(() {
                        _image = File('assets/images/5939837.jpg');
                      });
                    }
                    // nodeApis.updateProfile(_image!, "email");
                    // Navigator.pushNamed(context, '/home');
                  }
                  // Navigator.pushNamed(context, '/home');
                },
                child: const Text('Save'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
