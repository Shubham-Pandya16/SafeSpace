import 'package:flutter/material.dart';

import '../../model/colors.dart';

class cMaterialButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final bool isLoading;

  const cMaterialButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: isLoading ? null : () => onPressed(),
      minWidth: double.infinity,
      height: 65,
      color: AppColors.accentTeal,
      disabledColor: AppColors.accentTeal.withOpacity(0.6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: isLoading
          ? SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white.withOpacity(0.8),
                ),
                strokeWidth: 3,
              ),
            )
          : Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
    );
  }
}
