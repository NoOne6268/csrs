import 'package:csrs/services/node_authorization.dart';
import 'package:flutter/material.dart';
import 'package:csrs/utils/custom_widgets.dart';
import 'package:go_router/go_router.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen(
      {super.key,
      this.loginOrRegister,
      this.nextRoute,
      this.isEmail,
      this.email,
      this.rollNo,
      this.phone,
      this.isSignup});

  final String? loginOrRegister;
  final String? nextRoute;
  final String? isEmail;
  final String? email;
  final String? rollNo;
  final String? phone;
  final String? isSignup;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  NodeApis nodeApis = NodeApis();
  TextEditingController otpController = TextEditingController();

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
              'assets/logo1.png',
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
                      otpController,
                      'OTP',
                      'otp cannot be empty',
                      key: const ValueKey('otp'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    kAuthOtpButton(context,
                        textColor: Colors.white,
                        bgColor: Colors.black,
                        text: widget.loginOrRegister!, onPress: () {
                      if (_formKey.currentState!.validate()) {
                        // print('to is ${widget.email!} ${widget.phone!}');
                        print('isEmail is ${widget.isEmail!}');
                        if (widget.nextRoute == 'signup/phone') {
                          nodeApis
                              .verifyOtp('signup/verify', widget.email!,
                                  otpController.text, true)
                              .then((value) {
                            print('value is $value');
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${value['message']}')));
                            print('value of succes is , ${value['success']}');
                            if (value['success'] == true) {
                              context
                                  .pushNamed('signup/phone', queryParameters: {
                                'email': widget.email!,
                                'rollNo': widget.rollNo!,
                              });
                            }
                          });
                        }
                        else if (widget.nextRoute == 'home') {
                          print('otp is ${otpController.text}');

                          String to = widget.isEmail == 'true'
                              ? widget.email!
                              : widget.phone!;
                          bool isEmail =
                              widget.isEmail == 'true' ? true : false;
                          nodeApis
                              .verifyOtp(
                                  'login/verify', to, otpController.text, isEmail)
                              .then((value) {
                            print('value is $value');
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${value['message']}')));
                            if(value['success'] == true) {
                              context.push('/home');
                            }
                          });
                        }
                        else if (widget.nextRoute == 'profile') {
                          nodeApis
                              .signUp('setyourname', widget.rollNo!,
                                  widget.email!, widget.phone!, context)
                              .then((value) {
                            print('sign up api is called');
                          });
                          context.push('/profile');
                        }
                        // context.go('/home');
                      }
                    })
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
