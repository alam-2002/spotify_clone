import 'package:flutter/material.dart';
import 'package:spotify_clone/core/config/theme/app_color.dart';

class RowButton extends StatelessWidget {
  final void Function() onPressed;
  final String infoText;
  final String buttonTitle;

  const RowButton({
    super.key,
    required this.onPressed,
    required this.infoText,
    required this.buttonTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            // 'Already have an account?',
            infoText,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          TextButton(
            onPressed: onPressed,
            child: Text(
              buttonTitle,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}