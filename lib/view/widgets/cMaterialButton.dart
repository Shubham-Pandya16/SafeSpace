import 'package:flutter/material.dart';

class cMaterialButton extends StatefulWidget {
  final Function() buttonFunction;
  final text;
  const cMaterialButton({
    super.key,
    required this.buttonFunction,
    required this.text,
  });

  @override
  State<cMaterialButton> createState() => _cMaterialButtonState();
}

class _cMaterialButtonState extends State<cMaterialButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: widget.buttonFunction,
      minWidth: double.infinity,
      height: 65,
      color: Color(0xFF926247),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Text(
        widget.text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
