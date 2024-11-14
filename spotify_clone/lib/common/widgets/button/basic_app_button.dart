import 'package:flutter/material.dart';

class BasicAppButton extends StatelessWidget {
  final String title;
  final double? height;
  final Color? textColor;
  final void Function() onPressed;
  const BasicAppButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.height,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(height ?? 70),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: textColor,
        ),
      ),
    );
  }
}
