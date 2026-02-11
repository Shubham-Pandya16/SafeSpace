import 'package:flutter/material.dart';
import 'package:safe_space/controller/chat_service.dart';
import 'package:safe_space/model/colors.dart';
import 'package:safe_space/view/widgets/cLogo.dart';
import 'package:safe_space/view/widgets/cTextField.dart';

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
  final ChatService _chatService = ChatService();

  final List<Message> _messages = [];
  bool _isThinking = false;

  @override
  void initState() {
    super.initState();
    // Chat history is loaded internally by ChatService for context
    // but not displayed in the UI - fresh start for each session
  }

  Widget _buildChatBackground() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.brown,
          image: DecorationImage(
            image: AssetImage('assets/chat_doodle.png'),
            repeat: ImageRepeat.repeat,
            opacity: 0.7,
          ),
        ),
      ),
    );
  }

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

  void _showErrorSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> geminiResponseCall() async {
    final userInputMessage = _userInput.text.trim();
    if (userInputMessage.isEmpty || _isThinking) return;

    setState(() {
      _messages.add(
        Message(
          isUser: true,
          message: userInputMessage,
          date: DateTime.now(),
        ),
      );
      _isThinking = true;
    });

    _userInput.clear();
    _scrollToBottom();

    try {
      final response = await _chatService.sendMessage(
        userMessage: userInputMessage,
      );

      if (mounted) {
        setState(() {
          _messages.add(
            Message(
              isUser: false,
              message: response,
              date: DateTime.now(),
            ),
          );
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add(
            Message(
              isUser: false,
              message: "Something went wrong. Try again in a moment.",
              date: DateTime.now(),
            ),
          );
        });
        _showErrorSnackbar('Error: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isThinking = false;
        });
      }
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
        leading: Container(),
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
      body: Stack(
        children: [
          _buildChatBackground(),
          Column(
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
                        isChatBot: true,
                        icon: Icons.edit,
                        textController: _userInput,
                      ),
                    ),
                    const SizedBox(width: 0),
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
        ],
      ),
    );
  }
}
