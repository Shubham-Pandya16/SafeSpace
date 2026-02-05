import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:safe_space/model/colors.dart';
import 'package:safe_space/view/widgets/cLogo.dart';
import 'package:safe_space/view/widgets/cTextField.dart';

import '../../controller/apiKey.dart';
import '../../model/system_prompt.dart';
import '../widgets/cText.dart';
import '../widgets/message.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final TextEditingController _userInput = TextEditingController();

  final List<Message> _messages = [];

  Future<void> geminiResponseCall() async {
    final userInputMessage = _userInput.text;
    final finalPrompt =
        """
    $systemPrompt
    
    User Message: 
    $userInputMessage
    """;

    setState(() {
      _messages.add(
        Message(isUser: true, message: userInputMessage, date: DateTime.now()),
      );
    });

    _userInput.clear();

    final model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: apikey);
    final content = Content.text(finalPrompt);
    final response = await model.generateContent([content]);

    // print("Response from Gemini API: ${response.text}");

    setState(() {
      _messages.add(
        Message(
          isUser: false,
          message: response.text ?? "",
          date: DateTime.now(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var sWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.brown,

      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.grey),
        ),
        toolbarHeight: 75,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            cLogo(fontSize: 30, text: "SafeSpace.AI"),
            cText(
              fontSize: 13,
              text: "Your Mental Health Companion",
              color: Colors.white30,
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
        ),
        backgroundColor: AppColors.mediumBrown,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 25),
          //   child: cText(fontSize: 14, text: "How are you feeling today?"),
          // ),
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, i) {
                final message = _messages[i];
                return Messages(
                  isUser: message.isUser,
                  message: message.message,
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: sWidth * 0.75,

                child: GlowingTextField(
                  borderColor: AppColors.lightBrown,
                  hint: "How are you feeling today?",
                  icon: Icons.edit,
                  textController: _userInput,
                ),
              ),
              SizedBox(
                child: MaterialButton(
                  onPressed: geminiResponseCall,
                  color: const Color(0xFF926247),
                  height: sWidth * 0.15,
                  shape: CircleBorder(),
                  child: Icon(Icons.send),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}
