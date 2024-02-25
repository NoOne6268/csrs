import 'package:flutter/material.dart';

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
          height: 100.0,
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

BottomNavigationBarItem kBottomNavItem(String iconPath, title,
    {double size = 40}) {
  return BottomNavigationBarItem(
    icon: GestureDetector(
      child: Column(
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
    ),
    label: title,
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
        'Send OTP',
        style: TextStyle(
          color: textColor,
          fontSize: 25.0,
        ),
      ),
    ),
  );
}

Padding kAuthFormField(
    TextEditingController controller, String hintText, String isEmpty, {required Key key}) {
  return Padding(
    padding: const EdgeInsets.symmetric(
        horizontal: 16.0, vertical: 8.0),
    child: TextFormField(
      key: key,
      validator: (value) {
        if (value!.isEmpty) {
          return isEmpty;
        }
        return null;
      },
      controller: controller,
      decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0x80FFFFFF),
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
