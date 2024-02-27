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
      this.to,
      this.rollNo,
      this.phone,
      this.isSignup});

  final String? loginOrRegister;
  final String? nextRoute;
  final String? isEmail;
  final String? to;
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
                        print('to is ${widget.to!}');
                        print('isEmail is ${widget.isEmail!}');
                        if (widget.isSignup == 'true') {
                          nodeApis
                              .verifyOtp(
                                  'signup/verify',
                                  widget.to!,
                                  otpController.text,
                                  widget.isEmail! == 'true' ? true : false)
                              .then((value) {
                            if (value['success'] == false) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('OTP verification failed')));
                            }else {
                              if(widget.isEmail == 'true') {
                                context.pushNamed(widget.nextRoute!,
                                    queryParameters: {
                                      'isEmailVerified': 'true',
                                      'email': widget.to!,
                                      'rollNo': widget.rollNo!
                                    });
                              }else {
                                context.pushNamed(widget.nextRoute!,
                                    queryParameters: {
                                      'phone' : '${widget.to}'
                                    });
                              }

                            }
                          });
                        } else {
                          nodeApis
                              .verifyOtp(
                                  'login/verify',
                                  widget.to!,
                                  otpController.text,
                                  widget.isEmail! == 'true' ? true : false)
                              .then((value) {
                            if (value['success'] == false) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('OTP verification failed')));
                            } else {
                              context.pushNamed(widget.nextRoute!,
                                  queryParameters: {
                                    'isEmailVerified': 'true',
                                    'email': widget.to,
                                    'rollNo': widget.rollNo
                                  });
                            }
                          });
                        }
                        nodeApis
                            .verifyOtp(
                                'signup/verify',
                                '${widget.to!}@kgpian.iitkgp.ac.in',
                                otpController.text,
                                widget.isEmail! == 'true' ? true : false)
                            .then((value) {
                          if (value['success'] == false) {
                            print('otp verification failed');
                          }
                          context
                              .pushNamed(widget.nextRoute!, queryParameters: {
                            'isEmailVerified': 'true',
                            'email': '${widget.to}@kgpian.iitkgp.ac.in',
                            'rollNo': '${widget.rollNo}'
                          });
                        });
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
