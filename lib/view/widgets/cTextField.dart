import 'package:flutter/material.dart';
import 'package:safe_space/model/colors.dart';

class GlowingTextField extends StatefulWidget {
  final String hint;
  final IconData icon;
  final TextEditingController textController;
  final bool isPassword;
  final Color borderColor;

  const GlowingTextField({
    super.key,
    required this.hint,
    required this.icon,
    required this.textController,
    this.isPassword = false,
    this.borderColor = AppColors.green,
  });

  @override
  State<GlowingTextField> createState() => _GlowingTextFieldState();
}

class _GlowingTextFieldState extends State<GlowingTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _hasFocus = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
    // AnimatedContainer(
    // duration: const Duration(milliseconds: 250),
    // decoration: BoxDecoration(
    //   borderRadius: BorderRadius.circular(30),
    //   boxShadow: _hasFocus
    //       ? [
    //           BoxShadow(
    //             color: AppColors.green.withOpacity(0.8),
    //             blurRadius: 8,
    //             spreadRadius: 2,
    //           ),
    //         ]
    //       : [],
    // ),
    // child:
    TextFormField(
      // focusNode: _focusNode,
      controller: widget.textController,
      keyboardType: TextInputType.emailAddress,
      obscureText: widget.isPassword,
      style: const TextStyle(color: Colors.white, fontSize: 16),

      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: TextStyle(
          color: Colors.white54,
          fontWeight: FontWeight.bold,
        ),

        prefixIcon: Icon(widget.icon, color: Colors.white70, size: 20),
        filled: true,
        fillColor: AppColors.mediumBrown.withOpacity(0.7),

        contentPadding: const EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 20,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.15)),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: widget.borderColor, width: 3),
        ),
      ),
      // ),
    );
  }
}
