import 'package:flutter/material.dart';
import 'package:spotify_clone/common/helper/extension/is_dark_mode.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextInputType? keyboardType;
  final TextEditingController controller;
  const CustomTextField({
    super.key,
    required this.hintText,
    this.keyboardType,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: context.isDarkMode ? Colors.white : Colors.black,
      keyboardType: keyboardType ?? TextInputType.text,
      decoration: InputDecoration(
        label: Text(
          hintText,
          style: TextStyle(
            color: context.isDarkMode ? Color(0xffA7A7A7) : Color(0xff383838),
            fontWeight: FontWeight.w500,
          ),
        ),
        // hintText: hintText,
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }
}
