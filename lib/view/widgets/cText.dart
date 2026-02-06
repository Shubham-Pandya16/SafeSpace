import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../model/colors.dart';

class cText extends StatelessWidget {
  final double fontSize;
  final String text;
  final Color color;
  final double letterSpacing;

  const cText({
    super.key,
    this.text = "SafeSpace.",
    required this.fontSize,
    this.color = AppColors.lightGrey,
    this.letterSpacing = 0.8,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.calSans(
        fontSize: fontSize,
        color: color,
        letterSpacing: letterSpacing,
      ),
    );
  }
}
