import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:csrs/utils/custom_widgets.dart';
import 'package:csrs/services/node_authorization.dart';
import 'package:go_router/go_router.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    kAuthFormField(
                      rollNoController,
                      'Roll No',
                      'Name cannot be empty',
                      key: const ValueKey('username'),
                    ),
                    kAuthFormField(
                        emailController, 'Insti mail', 'Email cannot be empty.',
                        key: const ValueKey('email')),
                    const SizedBox(
                      height: 10.0,
                    ),
                    kAuthOtpButton(context,
                        textColor: Colors.black,
                        bgColor: Colors.white,
                        text: 'Send OTP', onPress: () async {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Sending otp')));
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
                            'to': '${emailController.text}@kgpian.iitkgp.ac.in',
                            'isSignup': 'true',
                            'rollNo': rollNoController.text,
                            'email' : '${emailController.text}@kgpian.iitkgp.ac.in',
                          });
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(response['message'])));
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
                              Shadow(color: Colors.black, offset: Offset(0, -5))
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
    );
  }
}
