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
  final ScrollController _scrollController = ScrollController();

  final List<Message> _messages = [];
  bool _isThinking = false;

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> geminiResponseCall() async {
    final userInputMessage = _userInput.text.trim();
    if (userInputMessage.isEmpty || _isThinking) return;

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
      _isThinking = true;
    });

    _userInput.clear();
    _scrollToBottom();

    try {
      final model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: apikey);

      final content = Content.text(finalPrompt);
      final response = await model.generateContent([content]);

      setState(() {
        _messages.add(
          Message(
            isUser: false,
            message: response.text ?? "I’m here with you.",
            date: DateTime.now(),
          ),
        );
      });
    } catch (e) {
      setState(() {
        _messages.add(
          Message(
            isUser: false,
            message: "Something went wrong. Try again in a moment.",
            date: DateTime.now(),
          ),
        );
      });
    } finally {
      setState(() {
        _isThinking = false;
      });
      _scrollToBottom();
    }
  }

  @override
  void dispose() {
    _userInput.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.brown,

      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: Colors.grey,
          ),
        ),
        toolbarHeight: 75,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            cLogo(fontSize: 30, text: "SafeSpace.AI"),
            cText(
              fontSize: 13,
              text: "Your Mental Health Companion",
              color: Colors.white30,
            ),
          ],
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
        ),
        backgroundColor: AppColors.mediumBrown,
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length + (_isThinking ? 1 : 0),
              itemBuilder: (context, i) {
                if (_isThinking && i == 0) {
                  return const Messages(isUser: false, message: "Typing…");
                }

                final index =
                    _messages.length - 1 - (i - (_isThinking ? 1 : 0));
                final message = _messages[index];

                return Messages(
                  isUser: message.isUser,
                  message: message.message,
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: GlowingTextField(
                    borderColor: AppColors.lightBrown,
                    hint: "How are you feeling today?",
                    icon: Icons.edit,
                    textController: _userInput,
                  ),
                ),
                const SizedBox(width: 6),
                MaterialButton(
                  onPressed: _isThinking ? null : geminiResponseCall,
                  color: AppColors.accentTeal,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(14),
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
