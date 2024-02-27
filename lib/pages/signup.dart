import 'package:flutter/material.dart';
import 'package:csrs/utils/custom_widgets.dart';
import 'package:csrs/services/firebase_authorization.dart';
import 'package:csrs/services/node_authorization.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen(
      {super.key, String? isEmailVerified, String? email, String? rollNo});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  AuthService authService = AuthService();
  NodeApis nodeApis = NodeApis();
  bool isOtp = false;
  bool obscureText = true;
  bool isEmail = false;
  bool isOtpMatched = true;
  String oTP = 'blhabl';
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController userController = TextEditingController();
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
                      userController,
                      'Full Name',
                      'Name cannot be empty',
                      key: const ValueKey('username'),
                    ),
                    kAuthPassFormField(
                      'Password',
                      passwordController,
                    ),
                    kAuthFormField(emailController, 'Institute Email',
                        'Email cannot be empty.',
                        key: const ValueKey('email')),
                    const SizedBox(
                      height: 10.0,
                    ),
                    kAuthOtpButton(context,
                        textColor: Colors.black,
                        bgColor: Colors.white,
                        text: 'Sign Up', onPress: () async {
                      if (_formKey.currentState!.validate()) {
                        final userId = await nodeApis.getUserID();
                        if (!context.mounted) return;
                        await nodeApis.signUp(
                            userController.text,
                            passwordController.text,
                            emailController.text,
                            userId,
                            context);
                      }
                      context.push('home');
                    }
                        // context.push('/home');
                        ),
                    const HorizontalOrLine(
                      label: "OR",
                      height: 4.0,
                      color: Colors.white,
                    ),
                    GestureDetector(
                      onTap: () {
                        context.go('/login');
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

  Padding kAuthPassFormField(
      String hintText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextFormField(
        key: const ValueKey('password'),
        obscureText: obscureText,
        controller: controller,
        style: const TextStyle(
          fontSize: 25,
        ),
        decoration: InputDecoration(
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  obscureText = !obscureText;
                });
              },
              child:
                  Icon(obscureText ? Icons.visibility : Icons.visibility_off),
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.5),
            hintText: hintText,
            hintStyle: const TextStyle(
              fontSize: 25,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.black),
            )),
      ),
    );
  }
}

// Scaffold(
// appBar: AppBar(
// title: const Text(
// 'Sign up',
// style: TextStyle(
// color: Colors.white,
// fontWeight: FontWeight.bold,
// fontSize: 25,
// letterSpacing: 1.0,
// ),
// ),
// centerTitle: true,
// backgroundColor: Colors.blueAccent,
// ),
// body: Container(
// color: Colors.blueGrey,
// child: Center(
// child: Padding(
// padding: const EdgeInsets.all(16.0),
// child: Card(
// shadowColor: Colors.black,
// child: Padding(
// padding: const EdgeInsets.all(8.0),
// child: SizedBox(
// width: double.infinity,
// child: Form(
// key: _formKey,
// child: Column(
// children: <Widget>[
// Padding(
// padding: const EdgeInsets.all(8.0),
// child: TextFormField(
// key: const ValueKey('username'),
// controller: userController,
// autofocus: true,
// decoration: const InputDecoration(
// prefixIcon: Icon(Icons.person),
// border: UnderlineInputBorder(),
// labelText: 'username',
// ),
// validator: (value) {
// if (value!.isEmpty) {
// return "username can't be empty";
// } else if (value.length < 4) {
// return "min allowed length is 4 chars";
// }
// return null;
// },
// ),
// ),
// Padding(
// key: const ValueKey('password'),
// padding: const EdgeInsets.all(8.0),
// child: TextFormField(
// controller: passwordController,
// autofocus: true,
// obscureText: obscureText,
// decoration: InputDecoration(
// prefixIcon: const Icon(Icons.password),
// suffixIcon:
// validator: (value) {
// if (value!.isEmpty || value.length < 6) {
// return "min length for password is 6 chars";
// }
// return null;
// },
// ),
// ),
// Padding(
// key: const ValueKey('email'),
// padding: const EdgeInsets.all(8.0),
// child: TextFormField(
// controller: emailController,
// autofocus: true,
// decoration: const InputDecoration(
// prefixIcon: Icon(Icons.email),
// border: UnderlineInputBorder(),
// labelText: 'Insti mail id',
// labelStyle: TextStyle(
// fontWeight: FontWeight.w400,
// ),
// ),
// onFieldSubmitted: (value) {},
// validator: (value) {
// if (value!.isEmpty) {
// return 'email can not be empty';
// }
// return null;
// },
// ),
// ),
// SizedBox(
// height: isOtp ? 0 : 20,
// child: isEmail
// ? Text(
// 'please enter  valid information',
// style: TextStyle(
// color: Colors.pink[300],
// fontStyle: FontStyle.italic,
// fontSize: 15,
// ),
// )
//     : null),
// Padding(
// padding: const EdgeInsets.all(8.0),
// child: isOtp
// ? TextFormField(
// controller: otpController,
// autofocus: true,
// decoration: const InputDecoration(
// prefixIcon: Icon(Icons.lock_outlined),
// border: UnderlineInputBorder(),
// labelText: 'OTP',
// labelStyle: TextStyle(
// fontWeight: FontWeight.w400,
// ),
// ),
// )
//     : null),
// Padding(
// padding: const EdgeInsets.all(8.0),
// child: isOtpMatched
// ? null
//     : Text(
// 'otp is invalid',
// style: TextStyle(
// color: Colors.pink[400],
// fontStyle: FontStyle.italic,
// fontSize: 15,
// ),
// ),
// ),
// Center(
// child: Padding(
// padding: const EdgeInsets.all(8.0),
// child: Row(
// mainAxisAlignment: MainAxisAlignment.spaceAround,
// children: [
// TextButton(
// onPressed: () {
// context.pop();
// },
// child: const Text('Login instead')),
// Container(
// child: isOtp ?  ElevatedButton(
// onPressed: () async {
// if (_formKey.currentState!.validate()) {
// ScaffoldMessenger.of(context)
//     .showSnackBar(
// const SnackBar(
// content: Text('Processing Data')),
// );
// print('otp filled by user is ${otpController.text}');
// if(otpController.text == oTP){
// // await authService
// //   .signUpWithEmailAndPassword(
// //       emailController.text,
// //       passwordController.text,
// //       userController.text,
// //       context);
// final userId = await nodeApis.getUserID();
// if (!context.mounted) return;
// await nodeApis.signUp(
// userController.text,
// passwordController.text,
// emailController.text,
// userId,
// context);
// }
// else{
// setState(() {
// isOtpMatched = false;
// });
// }
//
// }
// },
// style: ElevatedButton.styleFrom(
// backgroundColor: Colors.blue,
// foregroundColor: Colors.white,
// minimumSize: const Size(88, 36),
// padding: const EdgeInsets.symmetric(
// horizontal: 16),
// shape: const RoundedRectangleBorder(
// borderRadius:
// BorderRadius.all(Radius.circular(5)),
// ),
// ),
// child: const Text('Sign up'),
// ) :
// ElevatedButton(
// onPressed: () async {
//
// if (_formKey.currentState!
//     .validate()) {
// setState(() {
// isOtp = true;
// });
// ScaffoldMessenger.of(context)
//     .showSnackBar(
// const SnackBar(
// content: Text(
// 'Processing Data')),
// );
// String otp = await sendOtpEmail(
// emailController.text);
// print('otp received is $otp');
// setState(() {
//
// oTP = otp;
// });
// }
// },
// style: ElevatedButton.styleFrom(
// backgroundColor: Colors.blue,
// foregroundColor: Colors.white,
// minimumSize: const Size(88, 36),
// padding: const EdgeInsets.symmetric(
// horizontal: 16),
// shape: const RoundedRectangleBorder(
// borderRadius: BorderRadius.all(
// Radius.circular(5)),
// ),
// ),
// child: const Text('Send OTP'),
// ),
// ),
// ],
// ),
// ),
// )
// ],
// ),
// ),
// ),
// ),
// ),
// ),
// ),
// ),
// )
