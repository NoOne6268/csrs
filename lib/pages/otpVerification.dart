import 'package:flutter/material.dart';
import 'package:csrs/utils/custom_widgets.dart';
import 'package:go_router/go_router.dart';
class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key, String?  loginOrRegister, String? nextRoute});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
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
                    kAuthOtpButton(context ,
                        textColor: Colors.white,
                        bgColor: Colors.black,
                        text: 'verify',
                        onPress: (){
                          if (_formKey.currentState!.validate()) {
                           context.go('/home');
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
