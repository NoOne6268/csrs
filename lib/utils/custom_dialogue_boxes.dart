import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void kshowDialogue(BuildContext context, String title, String content) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
_confirmDialog(BuildContext context , String title, String content , void Function() onYes ) {
  return showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      backgroundColor: Colors.white,
      title: const Center(
          child: Text(
            'Confirm',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,),
          )),
      content: const Text('Are you sure you are safe?', style: TextStyle(
        fontSize: 20,
      ),),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: const Color(0x99EB5151),
          ),
          child: const Text(
            'No',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xFFEB5151),
          ),
          child: const Text(
            'Yes',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onPressed: () {
           onYes();
          },
        ),
      ],
    ),
  );
}