import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:csrs/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:csrs/utils/custom_widgets.dart';
import 'package:csrs/services/node_authorization.dart';
import 'package:go_router/go_router.dart';

import '../utils/custom_snackbar.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({
    super.key,
  });

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // AuthService authService = AuthService();
  NodeApis nodeApis = NodeApis();
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController rollNoController = TextEditingController();

  void CheckLogin() async {
    if (await nodeApis.checkLogin()) {
      context.pushNamed('/home');
    }
  }

  @override
  void initState() {
    super.initState();
    CheckLogin();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Color(0xFF90BDDB),
              size: 35,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: 'logo',
              child: Image.asset(
                'assets/icon_flutter.png',
                height: 175,
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24)),
                  color: Color(0xFF90BDDB),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      kAuthFormFieldRollNo(rollNoController,
                          key: const ValueKey('rollNo')),
                      kAuthFormField(emailController, 'Institute mail',
                          'Email cannot be empty.',
                          key: const ValueKey('email')),
                      const SizedBox(
                        height: 10.0,
                      ),
                      kAuthOtpButton(context,
                          textColor: Colors.black,
                          bgColor: Colors.white,
                          text: 'Send OTP', onPress: () async {
                        if (_formKey.currentState!.validate()) {
                          var response = await nodeApis.sendOtp(
                              'signup/email',
                              '${emailController.text}@kgpian.iitkgp.ac.in',
                              true);
                          print('response is $response');
                          if (response['success'] == true) {
                            context.pushNamed('verifyotp', queryParameters: {
                              'loginOrRegister': 'register',
                              'nextRoute': 'signup/phone',
                              'isEmail': 'true',
                              'to':
                                  '${emailController.text}@kgpian.iitkgp.ac.in',
                              'isSignup': 'true',
                              'rollNo': rollNoController.text,
                              'email':
                                  '${emailController.text}@kgpian.iitkgp.ac.in',
                            });
                          }
                          kSnackBar(
                              context,
                              response['message'],
                              response['success'].toString(),
                              response['success'] == true
                                  ? ContentType.success
                                  : ContentType.warning);
                        }
                      }),
                      const HorizontalOrLine(
                        label: "OR",
                        height: 4.0,
                        color: Colors.white,
                      ),
                      GestureDetector(
                        onTap: () {
                          context.push('/login');
                        },
                        child: const Center(
                          child: Text(
                            'Login Instead',
                            style: TextStyle(
                              fontSize: 25,
                              shadows: [
                                Shadow(
                                    color: Colors.black, offset: Offset(0, -5))
                              ],
                              color: Colors.transparent,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
