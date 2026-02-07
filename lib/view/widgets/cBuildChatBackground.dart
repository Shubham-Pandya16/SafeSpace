import 'package:flutter/material.dart';

import '../../model/colors.dart';

Widget _buildChatBackground() {
  return Positioned.fill(
    child: Container(
      decoration: BoxDecoration(
        color: AppColors.brown, // base color
        image: DecorationImage(
          image: AssetImage('assets/chat_doodle.png'),
          repeat: ImageRepeat.repeat,
          opacity: 0.05, // VERY important
        ),
      ),
    ),
  );
}
