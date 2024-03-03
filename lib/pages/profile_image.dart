import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImage extends StatefulWidget {
  const ProfileImage({Key? key}) : super(key: key);

  @override
  _ProfileImageState createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  XFile? _image;
  TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile Update',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () => _pickImage(ImageSource.gallery),
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Colors.grey[300],
                backgroundImage: _image != null
                    ? FileImage(File(_image!.path))
                    : AssetImage('assets/placeholder_image.png') as ImageProvider,
                child: Icon(
                  Icons.camera_alt,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement save logic here
                String username = _usernameController.text.trim();
                if (_image != null && username.isNotEmpty) {
                  // Save profile and navigate to home or another page
                } else {
                  // Show error message or handle incomplete data
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {
      final croppedImage = await ImageCropper().cropImage(
        sourcePath: pickedImage.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        uiSettings: [ AndroidUiSettings(
          toolbarTitle: 'Crop Image', toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
        ),
          IOSUiSettings(
            minimumAspectRatio: 1.0,
          ),
        ],
      );

      if (croppedImage != null) {
        setState(() {
          _image = croppedImage as XFile?;
        });
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }
}
