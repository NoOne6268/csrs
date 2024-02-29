import 'dart:io';

import 'package:flutter/material.dart';
import 'package:csrs/services/image_helper.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:csrs/services/node_authorization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:csrs/services/firebase_helper.dart';
import 'package:permission_handler/permission_handler.dart';

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
  bool isLoading = false;
  String image = '';
  late final ImagePicker _picker;
  XFile? xFile;
@override
  void initState() {
    super.initState();
    _picker = ImagePicker();
  }
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
                child: CircleAvatar(
                  radius: 100,
                  child: InkWell(
                    onTap: () async {
                      isLoading = true;
                      setState(() {});
                      // take gallery permission if not given
                      if(await Permission.camera.isDenied) {
                        await Permission.camera.request();
                      }
                      xFile =
                      await _picker.pickImage(source: ImageSource.gallery);
                      if (xFile != null) {
                        setState(() {});
                  
                        ///Upload to fire storage
                        final String? url =
                        await FirebaseHelper.uploadImage(File(xFile!.path));
                  
                        if (url != null) {
                          image = url;
                          isLoading = false;
                          setState(() {});
                          return;
                        }
                      }
                  
                      isLoading = false;
                      setState(() {});
                    },
                    child: CircleAvatar(
                      radius: 50,
                      child: Container(
                        height: 300,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          border: Border.all(width: 8, color: Colors.black12),
                          borderRadius: BorderRadius.circular(12.0),
                          image: xFile?.path != null
                              ? DecorationImage(
                            image: FileImage(
                              File(xFile!.path),
                            ),
                            fit: BoxFit.cover,
                          )
                              : null,
                        ),
                        child: xFile?.path != null
                            ? null
                            : const Center(
                          child: Icon(Icons.photo),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // TextButton(
              //   onPressed: () async {
              //
              //     final file = await imageHelper.pickImage();
              //     if(file != null){
              //       final cropFile = await imageHelper.crop(file: file , cropStyle: CropStyle.circle);
              //       if(cropFile != null){
              //         setState(() {
              //           _image = File(cropFile.path);
              //         });
              //       }
              //     }
              //   }, child: const Text("upload profile"),
              // ),
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
                onPressed: () {
                },
                child: const Text('Save'),
              )
            ],
          ),
        ),
      )
    );
  }
}
