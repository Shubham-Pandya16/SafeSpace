import 'package:flutter/material.dart';

import '../../model/colors.dart';

class cMaterialButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const cMaterialButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      minWidth: double.infinity,
      height: 65,
      color: AppColors.accentTeal,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Text(
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
