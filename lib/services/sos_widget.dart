import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';

class SOSWidget {
  static const platform = MethodChannel('datsol.flutter.dev/widget');

  Future<void> showWidget(BuildContext context) async {
    try{
      final response = await platform.invokeMethod<String>('showWidget');
      // if(response == 'SendNotification'){
      //
      //
      // }
    } catch (e) {
      print(e);
    }
  }

  Future<void> hideWidget(BuildContext context) async {
    try{
      final response = await platform.invokeMethod<String>('hideWidget');
    } catch(e) {
      debugPrint("$e");
    }
  }
}


