import 'dart:async';

import 'package:csrs/pages/signup.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/node_authorization.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  NodeApis nodeApis = NodeApis();
  void CheckLogin()async{

    if(await nodeApis.checkLogin()){
      context.pushNamed('/home');
    }
    else{
      Timer(
        const Duration(seconds: 2),
            () {
          Navigator.of(context).push(_createRoute());
        },
      );
    }
}
  @override
  void initState() {
    super.initState();

      CheckLogin();

  }

  Route _createRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
           const  SignupScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          final tween = Tween(begin: begin, end: end);
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: curve,
          );

          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: child,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(_createRoute());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body:
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'logo',
                  child: Image.asset(
                      'assets/icon_flutter.png',
                    fit: BoxFit.fitWidth
                  ),
                ),
                const Text('CSRS', style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                ),),
                const Text('DATSOL SOLUTIONS', style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey
                ),)
              ],
            ),
      ),
    );
  }
}
