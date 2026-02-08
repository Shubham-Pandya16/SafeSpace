import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:safe_space/view/widgets/message.dart';

import '../../model/colors.dart';
import '../widgets/cText.dart';
import '../widgets/cTextField.dart';

class GroupchatPage extends StatefulWidget {
  final String groupId;
  final String groupName;

  const GroupchatPage({
    super.key,
    required this.groupId,
    required this.groupName,
  });

  @override
  State<GroupchatPage> createState() => _GroupchatPageState();
}

class _GroupchatPageState extends State<GroupchatPage> {
  bool _isUser(String msgUid) {
    if (FirebaseAuth.instance.currentUser?.uid == msgUid) {
      return true;
    } else {
      return false;
    }
  }

  final TextEditingController _userInput = TextEditingController();

  void _sendMessage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final text = _userInput.text.trim();
    if (text.isEmpty) return;
    _userInput.clear();
    await FirebaseFirestore.instance
        .collection('community')
        .doc(widget.groupId)
        .collection('messages')
        .add({
          'text': text,
          'senderID': user.uid,
          'timestamp': FieldValue.serverTimestamp(),
        });
    scrollToBottom();
  }

  final ScrollController _scrollController = ScrollController();
  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildChatBackground() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.brown, // base color
          image: DecorationImage(
            image: AssetImage('assets/chat_doodle.png'),
            repeat: ImageRepeat.repeat,
            // opacity: 1, // VERY important
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // var sWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
          children: [cText(fontSize: 22, text: widget.groupName)],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
        ),
        backgroundColor: AppColors.mediumBrown,
      ),

      body: Stack(
        children: [
          _buildChatBackground(),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Messages list
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('community')
                      .doc(widget.groupId)
                      .collection('messages')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text("No messages yet"));
                    }

                    final messages = snapshot.data!.docs;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (_scrollController.hasClients) {
                        _scrollController.jumpTo(0);
                      }
                    });

                    return ListView.builder(
                      reverse: true,
                      controller: _scrollController,
                      padding: const EdgeInsets.all(8),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final data =
                            messages[index].data() as Map<String, dynamic>;

                        return Messages(
                          message: data['text'] ?? '',
                          isUser: _isUser(data['senderID']),
                          date: data['timestamp'] != null
                              ? DateFormat('hh:mm aa • dd MMM').format(
                                  (data['timestamp'] as Timestamp).toDate(),
                                )
                              : null,
                        );
                      },
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 8),
                  Expanded(
                    flex: 5,
                    child: GlowingTextField(
                      borderColor: AppColors.lightBrown,
                      hint: "Type to start chatting.. ",
                      icon: Icons.edit,
                      isChatBot: true,
                      textController: _userInput,
                    ),
                  ),
                  SizedBox(width: 6),

                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      child: MaterialButton(
                        onPressed: () {
                          _sendMessage();
                        },
                        color: AppColors.accentTeal,
                        height: 65,
                        shape: CircleBorder(),
                        child: Icon(Icons.send),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                ],
              ),
              SizedBox(height: 15),
            ],
          ),
        ],
      ),
    );
  }
}
