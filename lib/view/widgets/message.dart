import 'package:flutter/material.dart';
import 'package:safe_space/model/colors.dart';

class Message {
  final bool isUser;
  final String message;
  final DateTime date;

  Message({required this.isUser, required this.message, required this.date});
}

class Messages extends StatelessWidget {
  final bool isUser;
  final String message;
  final String? date;
  final String? username;

  const Messages({
    super.key,
    required this.isUser,
    required this.message,
    this.date,
    this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      margin: EdgeInsets.symmetric(
        vertical: 15,
      ).copyWith(left: isUser ? 30 : 10, right: isUser ? 10 : 30),
      decoration: BoxDecoration(
        color: isUser ? AppColors.lightBrown : AppColors.lightestBrowm,

        borderRadius: BorderRadius.only(
          bottomRight: isUser ? Radius.circular(0) : Radius.circular(30),
          bottomLeft: isUser ? Radius.circular(30) : Radius.circular(0),
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
              letterSpacing: 1,
              wordSpacing: 0,
              color: isUser ? Colors.white70 : Colors.white,
            ),
          ),
          if (date != null || (username != null && !isUser))
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (username != null && !isUser)
                    Text(
                      username!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        color: Colors.white70,
                      ),
                    ),
                  if (date != null)
                    Text(
                      date!,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isUser ? Colors.white54 : Colors.white70,
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
