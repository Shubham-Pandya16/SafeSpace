import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class cLogo extends StatelessWidget {
  final double fontSize;

  const cLogo({super.key, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Text(
      "SafeSpace.",
      style: GoogleFonts.calSans(fontSize: fontSize, letterSpacing: -2),
    );
  }
}
