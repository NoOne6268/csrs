import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

void kSnackBar(BuildContext context, String message,String title,
    ContentType contentType) {
  final snackBar = SnackBar(
    padding: const EdgeInsets.symmetric(horizontal: 10 , vertical: 5),
    margin: const EdgeInsets.symmetric(horizontal: 2 , vertical: 2),
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      inMaterialBanner: false,
      titleFontSize: 30,
      messageFontSize: 20,
      title: title,
      message: message,
      contentType: contentType,
    ),
  );
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
