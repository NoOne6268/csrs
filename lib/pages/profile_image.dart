import 'dart:io';

import 'package:flutter/material.dart';
import 'package:csrs/services/image_helper.dart';
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
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Colors.cyan,
        appBar: AppBar(
          title: const Text('Profile Image'),
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
                      foregroundImage: _image != null ? FileImage(_image!) : Image.asset('assets/images/5939837.jpg',
                      semanticLabel: "profile", colorBlendMode: BlendMode.lighten, fit: BoxFit.cover,).image,
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
                    if(file != null){
                      final cropFile = await imageHelper.crop(file: file , cropStyle: CropStyle.circle);
                      if(cropFile != null){
                        setState(() {
                          _image = File(cropFile.path);
                        });
                      }
                    }
                  }, child: const Text("upload profile"),
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
                      }
                                  ),
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
                    if(_formKey.currentState!.validate()){
                      if(_image == null){
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
      ),
    );
  }
}
