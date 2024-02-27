import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

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
    ), onPressed: onEvent,
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
      validator: (value) {
        if (value!.isEmpty) {
          return isEmpty;
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
          fillColor: (onLogin ? const Color(0x8090BDDB) : const Color(0x80FFFFFF)),
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 25,
          ),
          suffixText:
              hintText == 'Institute mail' ? '@kgpian.iitkgp.ac.in' : '',
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

    return Column(mainAxisSize: MainAxisSize.min,
        children: widgetList);
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

Padding kContactTile({required String name, required Uri? imageUri, required String phoneNo}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5.0),
    child: Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: (imageUri == null ? Image.asset(
            'assets/static_profile.png',
                height: 55,
            ) : Image.network(imageUri.toString())),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
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
      ],
    ),
  );
}

List<Padding> contacts = [
  kContactTile(name: 'Name', imageUri: null, phoneNo: '1234567890'),
  kContactTile(name: 'Name', imageUri: null, phoneNo: '1234567890'),
  kContactTile(name: 'Name', imageUri: null, phoneNo: '1234567890'),
];
