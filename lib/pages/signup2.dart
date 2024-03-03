import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:csrs/utils/custom_widgets.dart';
import 'package:csrs/services/node_authorization.dart';
import 'package:go_router/go_router.dart';

class SignupScreen2 extends StatefulWidget {
  const SignupScreen2({super.key, this.email, this.rollNo});

  final String? email;
  final String? rollNo;

  @override
  State<SignupScreen2> createState() => _SignupScreen2State();
}

class _SignupScreen2State extends State<SignupScreen2> {
  NodeApis nodeApis = NodeApis();
  bool obscureText = true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();

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
                        phoneController, 'Phone No', 'phone can not be empty',
                        key: const ValueKey('phone')),
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
                                'signup/phone', phoneController.text, false);
                            print('response is $response');
                            if (response['success'] == true) {
                              context.pushNamed('verifyotp', queryParameters: {
                                'loginOrRegister': 'register',
                                'nextRoute': 'profile',
                                'isEmail': 'false',
                                'to': phoneController.text,
                                'isSignup': 'true',
                                'rollNo': widget.rollNo!,
                                'email': widget.email!,
                                'phone' : phoneController.text,
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
                        context.push('profile');
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