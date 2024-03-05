import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:csrs/services/node_authorization.dart';
import 'package:go_router/go_router.dart';
import 'package:csrs/utils/custom_widgets.dart';

import '../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscureText = true;
  bool isPhone = false;

  // AuthService authService = AuthService();
  NodeApis nodeApis = NodeApis();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF90BDDB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 35,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 175,
            child: Center(
                child: Text(
              'Welcome Back!',
              style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.w700,
              ),
            )),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24)),
                color: Colors.white,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    kAuthFormField(
                        emailController,
                        isPhone ? 'Phone No' : 'Institute Email',
                        'email can\'t be empty',
                        key: const ValueKey('email'),
                        onLogin: true),
                    const SizedBox(
                      height: 25.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 4.0,
                      ),
                      child: kAuthOtpButton(
                        context,
                        textColor: Colors.black,
                        bgColor: const Color(0xFF90BDDB),
                        text: 'Send OTP',
                        onPress: () async {
                          if (_formKey.currentState!.validate()) {
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //     const SnackBar(
                            //       content: Text('Processing Data'),
                            //     ),
                            //   );
                            final snackBar = SnackBar(
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: AwesomeSnackbarContent(
                                    title: 'Validating data !! ',
                                    message: '',
                                    contentType: ContentType.help,
                                  ),
                                ),
                              ),
                            );

                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(snackBar);

                            if (isPhone) {
                              var response = await nodeApis.sendOtp(
                                  'login/phone', emailController.text, false);
                              print('response is $response');
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //     const SnackBar(content: Text('Sending otp')));
                              final snackBar = SnackBar(
                                elevation: 0,
                                behavior: SnackBarBehavior.values[1],
                                backgroundColor: Colors.transparent,
                                content: AwesomeSnackbarContent(
                                  title: 'Sending otp!!',
                                  message: '',
                                  contentType: ContentType.help,
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(snackBar);
                              if (response['success'] == true) {
                                context.goNamed('verifyotp', queryParameters: {
                                  'loginOrRegister': 'login',
                                  'nextRoute': 'home',
                                  'isEmail': 'false',
                                  'phone': emailController.text,
                                });
                              }
                            } else {
                              var response = await nodeApis.sendOtp(
                                  'login/email',
                                  '${emailController.text}@kgpian.iitkgp.ac.in',
                                  true);
                              print('response is $response');
                              final snackBar = SnackBar(
                                elevation: 0,
                                behavior: SnackBarBehavior.values[1],
                                backgroundColor: Colors.transparent,
                                content: AwesomeSnackbarContent(
                                  title:
                                      response['success'].toString() == 'false'
                                          ? 'Failed'
                                          : 'True',
                                  message: response['message'],
                                  contentType:
                                      response['success'].toString() == 'false'
                                          ? ContentType.failure
                                          : ContentType.success,
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(snackBar);
                              if (response['success'] == true) {
                                context.goNamed(
                                  'verifyotp',
                                  queryParameters: {
                                    'loginOrRegister': 'login',
                                    'nextRoute': 'home',
                                    'isEmail': 'true',
                                    'email':
                                        '${emailController.text}@kgpian.iitkgp.ac.in',
                                  },
                                );
                              }
                            }
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isPhone = !isPhone;
                        });
                      },
                      child: Center(
                        child: Text(
                          isPhone
                              ? 'Login Through Insti Email'
                              : 'Login Through Phone Number',
                          style: const TextStyle(
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
                    const SizedBox(
                      height: 10,
                    ),
                    const HorizontalOrLine(
                      label: "OR",
                      height: 10.0,
                      color: Colors.black,
                    ),
                    GestureDetector(
                      onTap: () {
                        context.push('/signup/email');
                      },
                      child: const Center(
                        child: Text(
                          'Signup Instead',
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
