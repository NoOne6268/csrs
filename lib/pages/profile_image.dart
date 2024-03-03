import 'dart:io';

import 'package:flutter/material.dart';
import 'package:csrs/utils/custom_widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:csrs/services/node_authorization.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/custom_widgets.dart';

class ProfileImage extends StatefulWidget {
  const ProfileImage({super.key, required String rollNo, required String email});
  // final String initials;
  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  XFile? _image;
  final _formKey = GlobalKey<FormState>();
  NodeApis nodeApis = NodeApis();
  TextEditingController nameController = TextEditingController();

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
              )
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
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: CircleAvatar(
                radius: 100,
                backgroundImage: const AssetImage('assets/static_profile.png'),
                child: (_image != null
                    ?
                    Image(
                  image: FileImage(
                    File(_image!.path),
                  ),
                )
                : Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    IconButton(
                      padding: const EdgeInsets.all(12.0),
                      onPressed: () async {
                        final file = await ImagePicker()
                            .pickImage(source: ImageSource.camera);
                        final croppedFile =
                        await ImageCropper().cropImage(
                          sourcePath: file!.path,
                          uiSettings: [
                            AndroidUiSettings(
                              lockAspectRatio: true,
                              initAspectRatio:
                              CropAspectRatioPreset.square,
                              hideBottomControls: true,
                            ),
                            IOSUiSettings(
                              aspectRatioLockEnabled: true,
                              aspectRatioPickerButtonHidden: true,
                            )
                          ],
                        );

                        setState(() {
                          _image = croppedFile as XFile;
                        });
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0x66FFFFFF),
                      ),
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        size: 35,
                        color: Colors.purple,
                      ),
                    ),
                    const Text(
                      'Select from\nCamera',
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () async {
                final file =
                await ImagePicker().pickImage(source: ImageSource.gallery);
                final croppedFile = await ImageCropper().cropImage(
                  sourcePath: file!.path,
                  uiSettings: [
                    AndroidUiSettings(
                      lockAspectRatio: true,
                      initAspectRatio: CropAspectRatioPreset.square,
                      hideBottomControls: true,
                    ),
                    IOSUiSettings(
                      aspectRatioLockEnabled: true,
                      aspectRatioPickerButtonHidden: true,
                    )
                  ],
                );

                setState(() {
                  _image = croppedFile as XFile?;
                });
              },
              child: const Text(
                "Upload Profile",
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
            kAuthFormField(
              nameController,
              'Name',
              'Name',
              key: const ValueKey('name'),
              onLogin: true,
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton(
              // style: ElevatedButton.styleFrom(
              //   primary: Colors.lightGreenAccent,
              //
              // ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (_image == null) {
                    setState(() {});
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
    );
  }
}