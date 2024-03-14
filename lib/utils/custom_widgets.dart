import 'package:csrs/services/contact_services.dart';
import 'package:csrs/utils/custom_dialogue_boxes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:go_router/go_router.dart';

class HorizontalOrLine extends StatelessWidget {
  const HorizontalOrLine({
    super.key,
    required this.label,
    required this.height,
    required this.color,
  });

  final Color color;
  final String label;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20.0,
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                  margin: const EdgeInsets.only(left: 40.0, right: 15.0),
                  child: Divider(
                    color: color,
                    height: height,
                  )),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 25.0,
                color: color,
              ),
            ),
            Expanded(
              child: Container(
                  margin: const EdgeInsets.only(left: 15.0, right: 40.0),
                  child: Divider(
                    color: color,
                    height: height,
                  )),
            ),
          ],
        ),
        const SizedBox(
          height: 30.0,
        ),
      ],
    );
  }
}

TextStyle kHighlightTextStyle = const TextStyle(
    color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold);

Widget kBottomNavItem(
  String iconPath,
  title, {
  double size = 40,
  required void Function() onEvent,
}) {
  return IconButton(
    icon: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          iconPath,
          height: size,
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 15.0),
        )
      ],
    ),
    onPressed: onEvent,
  );
}

TextField kAuthTextField(String hintText, TextEditingController controller) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      filled: true,
      fillColor: const Color(0x8090BDDB),
      hintText: hintText,
      hintStyle: const TextStyle(
        fontSize: 25,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFF90BDDB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFF90BDDB)),
      ),
    ),
  );
}

Padding kAuthOtpButton(BuildContext context,
    {required Color textColor,
    required Color bgColor,
    required String text,
    required void Function()? onPress}) {
  return Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 30.0,
      vertical: 4.0,
    ),
    child: ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        elevation: 8.0,
        padding: const EdgeInsets.symmetric(vertical: 7.0),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 25.0,
        ),
      ),
    ),
  );
}

Padding kAuthFormField(
    TextEditingController controller, String hintText, String isEmpty,
    {required Key key, bool onLogin = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: TextFormField(
      key: key,
      keyboardType: hintText == 'Phone No' || hintText == "OTP"? TextInputType.phone : TextInputType.text,
      validator: (value) {
        if (value!.isEmpty) {
          return isEmpty;
        }
        if(hintText == 'Phone No' && value.length != 10){
          return 'Invalid phone number';
        }
        return null;
      },
      style: const TextStyle(
        fontSize: 25,
        shadows: [
          Shadow(
            color: Colors.black,
            blurRadius: 2.0,
          ),
        ],
      ),

      controller: controller,
      decoration: InputDecoration(
          filled: true,
          fillColor:
              (onLogin ? const Color(0x8090BDDB) : const Color(0x80FFFFFF)),
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 24,
          ),

          suffixText: hintText == 'Institute mail' ? '@kgpian.iitkgp.ac.in' : '',
          suffixStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 23,
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
Padding kAuthFormFieldRollNo(
    TextEditingController controller,
    {required Key key}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: TextFormField(
      key: key,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.isEmpty) {
          return 'This field can\'t be empty';
        }
        final isValid = RegExp(r'^\d{2}[A-Z]{2}\d{5}$').hasMatch(value);
        if (!isValid) {
          return 'Invalid roll number format';
        }
        return null;
      },
      style: const TextStyle(
        fontSize: 25,
        shadows: [
          Shadow(
            color: Colors.black,
            blurRadius: 2.0,
          ),
        ],
      ),

      controller: controller,
      decoration: InputDecoration(
          filled: true,
          fillColor:
           const Color(0x80FFFFFF),
          hintText: "Roll No",
          hintStyle: const TextStyle(
            fontSize: 25,
          ),
          suffixStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 23,
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

Text ksosText({required String showText}) {
  return Text(
    showText,
    style: const TextStyle(
      fontSize: 25.0,
      fontWeight: FontWeight.bold,
    ),
  );
}

List<String> texts = [
  'Go to Home Screen.',
  'Tap and hold an on empty region.',
  'Select Widgets.',
  'Scroll down to find CSRS.',
  'Select the Emergency Button widget.'
];

class Steps extends StatelessWidget {
  Steps(this.texts, {super.key});

  final List<String> texts;

  @override
  Widget build(BuildContext context) {
    var widgetList = <Widget>[];
    var cnt = texts.length;
    for (int i = 0; i < cnt; i++) {
      // Add list item
      widgetList.add(Step(texts[i], i));
      // Add space between items
      widgetList.add(const SizedBox(height: 5.0));
    }

    return Column(mainAxisSize: MainAxisSize.min, children: widgetList);
  }
}

class Step extends StatelessWidget {
  const Step(this.text, this.index, {super.key});

  final String text;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("${index + 1} "),
        Expanded(
          child: Text(text),
        ),
      ],
    );
  }
}

Padding kContactTile(
    {required String name, required String? imageUri, required String phoneNo , required bool isDelete , required void Function() ? onPress }) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: CircleAvatar(
            radius: 35,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: ((imageUri == null) || (imageUri == '' )
                  ? Image.asset(
                      'assets/static_profile.png',
                      height: 55,
                    )
                  : Image.network(imageUri)),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  phoneNo,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ],
            ),
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.call_outlined,
            size: 40,
          ),
          onPressed: () async {
            bool? res = await FlutterPhoneDirectCaller.callNumber(phoneNo);
          },
        ),
        Visibility(
          visible: isDelete,
          child: IconButton(
            onPressed: onPress,
            icon: const Icon(
              Icons.delete_outline_outlined,
              size: 40,
            ),
          ),
        )
      ],
    ),
  );
}

// List<Padding> contacts = [
//   kContactTile(name: 'Name', imageUri: null, phoneNo: '1234567890'),
//   kContactTile(name: 'Name', imageUri: null, phoneNo: '1234567890'),
//   kContactTile(name: 'Name', imageUri: null, phoneNo: '1234567890'),
// ];

PreferredSize kBackAppbar(BuildContext context,
    {required Color color, bool isTitle = false, String titleText = '', bool isBack = true}) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(75.0),
    child: AppBar(
      automaticallyImplyLeading: isBack,
      leading: isBack ? IconButton(
        icon: const Icon(
          Icons.arrow_back_rounded,
          color: Colors.white,
          size: 35,
        ),
        onPressed: () => context.pop(),
      ) : null,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
      ),
      title: (!isTitle
          ? null
          : Center(
              child: Text(
                titleText,
                style: const TextStyle(color: Colors.white, fontSize: 27),
              ),
            )),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GestureDetector(
            onTap: () {},
            child: const Icon(
              Icons.more_vert_outlined,
              color: Colors.white,
              size: 35,
            ),
          ),
        )
      ],
      backgroundColor: color,
    ),
  );
}
Padding kProfileField(
    {required TextEditingController controller,
      required TextInputType inputType,
      required void Function() onPress,
      required bool check}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    child: TextField(
      keyboardType: inputType,
      style: const TextStyle(
        fontSize: 25,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: (!check ? const Color(0x8090BDDB) : Colors.white),
        suffix: IconButton(
          onPressed: onPress,
          icon: const Icon(
            Icons.edit,
            size: 25,
            color: Colors.black,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0x8090BDDB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0x8090BDDB)),
        ),
      ),
      controller: controller,
      readOnly: check,
    ),
  );
}

RoundedRectangleBorder kRoundedBorder() {
  return const RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      bottomRight: Radius.circular(24),
      bottomLeft: Radius.circular(24),
    ),
  );
}