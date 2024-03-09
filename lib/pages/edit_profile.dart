import 'dart:convert';
import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:csrs/utils/custom_snackbar.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:csrs/utils/custom_widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:csrs/services/node_authorization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  const EditProfile(
      {super.key,
      required this.email,
      required this.rollNo,
      required this.name,
      required this.imageUrl});

  final String? email;
  final String? rollNo;
  final String? name;
  final String? imageUrl;

  // final String initials;
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? _image;
  bool state = false;
  final _formKey = GlobalKey<FormState>();
  NodeApis nodeApis = NodeApis();
  TextEditingController nameController = TextEditingController();
  TextEditingController rollNoController = TextEditingController();
  bool isLoading = false;
  late Directory directory;
  late SharedPreferences prefs;

  void saveImage(CroppedFile image) async {
    final path = directory.path;
    final fileName = basename(image.path);
    final fileExtension = extension(image.path);

    File tmpFile = File(image.path);

    tmpFile = await tmpFile.copy('$path/$fileName$fileExtension');

    //TODO: save image in db.

    setState(() {
      prefs.setString('profile_photo', '$path/$fileName$fileExtension');
    });
  }

  void getFilePath() async {
    prefs = await SharedPreferences.getInstance();
    directory = await getApplicationDocumentsDirectory();
    setState(() {});
  }

  @override
  void initState() {
    nameController.text = widget.name!;
    rollNoController.text = widget.rollNo!;

    getFilePath();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.cyan,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(24),
            bottomLeft: Radius.circular(24),
          )),
          title: const Center(
            child: Text(
              'Profile Update',
              style: TextStyle(color: Colors.white, fontSize: 27),
            ),
          ),
          backgroundColor: const Color(0xFF506D85),
        ),
      ),

      body: isLoading
          ? const Center(
        heightFactor: 10,
              widthFactor: 10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Text('Please wait...'),
                SizedBox(height: 20),
                CircularProgressIndicator(),
              ],
            ))
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 80,
                              backgroundImage:
                                  const AssetImage('assets/static_profile.png'),
                              foregroundImage: (prefs
                                          .getString('profile_photo') ==
                                      null
                                  ? widget.imageUrl == null
                                      ? null as ImageProvider<Object>?
                                      : NetworkImage(widget.imageUrl!)
                                  : FileImage(
                                      File(prefs.getString('profile_photo')!))),
                            ),
                            Positioned(
                              bottom: 1,
                              right: 1,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    elevation: 6.0,
                                    padding: const EdgeInsets.all(10.0),
                                    shape: const CircleBorder(
                                      side: BorderSide.none,
                                    )),
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

                                  saveImage(croppedFile!);
                                },
                                child: const Icon(
                                  Icons.edit,
                                  size: 20,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextButton(
                        onPressed: () async {
                          final file = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
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

                          saveImage(croppedFile!);
                        },
                        child: const Text(
                          "Upload from Gallery",
                          style: TextStyle(
                            fontSize: 23,
                            color: const Color(0xFF506D85),
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
                      kAuthFormField(
                        rollNoController,
                        'Roll No',
                        'Roll No can\'t be empty',
                        key: const ValueKey('rollNo'),
                        onLogin: true,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        textBaseline: TextBaseline.alphabetic,
                        textDirection: TextDirection.ltr,
                        children: [
                          TextButton(
                            style: ElevatedButton.styleFrom(
                              visualDensity: VisualDensity.comfortable,
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 26.0, vertical: 4.0),
                            ),
                            onPressed: () async {
                              context.pop();
                            },
                            child: const Text(
                              'Back',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TextButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF506D85),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 26.0, vertical: 4.0),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                if (prefs.getString('profile_photo') == null &&
                                    widget.imageUrl == null) {
                                  kSnackBar(
                                      context,
                                      'Please upload a profile photo',
                                      'false',
                                      ContentType.warning);
                                  return;
                                }
                                setState(() {
                                  isLoading = true;
                                });
                                Map<String, dynamic> response;
                                //change in currentUser cookie the new name and roll no

                                // prefs.setString('currentUser', jsonEncode({
                                //   'data': {
                                //     'username': nameController.text,
                                //     'rollNo': rollNoController.text,
                                //     'email': widget.email,
                                //     'imageUrl': widget.imageUrl,
                                //   }
                                // }));
                                response = await nodeApis.saveProfile(
                                    widget.email!,
                                    nameController.text,
                                    File(prefs.getString('profile_photo')!),
                                    rollNoController.text);
                                // CoolAlert.show(
                                //   context: context,
                                //   type: CoolAlertType.success,
                                //   title: 'Profile updated successfully',
                                //   text: 'Your profile has been updated successfully',
                                //   onConfirmBtnTap: () {
                                //     context.pop();
                                //   },
                                // );
                                setState(() {
                                  isLoading = false;
                                });
                                  context.push('/home');
                                kSnackBar(
                                    context,
                                    response['status'] == 'success'
                                        ? 'profile updated successfully'
                                        : "Something went wrong!!",
                                    response['status'],
                                    response['status'] == 'success'
                                        ? ContentType.success
                                        : ContentType.failure);
                                if (response['status'] == 'success') {
                                }
                              }
                            },
                            child: const Text(
                              'Save',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
