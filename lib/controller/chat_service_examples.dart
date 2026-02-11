import 'package:safe_space/controller/chat_service.dart';

void exampleBasicIntegration() async {
  final chatService = ChatService();

  try {
    final response = await chatService.sendMessage(
      userMessage: "I'm feeling overwhelmed with my assignments",
    );

    print('AI Response: $response');
  } catch (e) {
    print('Error: $e');
  }
}

void exampleLoadHistory() async {
  final chatService = ChatService();

  try {
    final messages = await chatService.getChatHistory(limit: 50);

    print('Found ${messages.length} previous messages');

    for (final msg in messages) {
      final sender = msg.role == 'user' ? 'You' : 'Assistant';
      final time = msg.createdAt.toString();
      print('[$time] $sender: ${msg.content}');
    }
  } catch (e) {
    print('Failed to load history: $e');
  }
}

void exampleDisplayProfile() async {
  final chatService = ChatService();

  try {
    final profile = await chatService.getUserProfile();

    if (profile.isEmpty) {
      print('No profile yet. Start the conversation!');
    } else {
      print('Your Emotional Profile:');
      print('$profile');
    }
  } catch (e) {
    print('Error fetching profile: $e');
  }
}

void exampleRefreshProfile() async {
  final chatService = ChatService();

  try {
    print('Regenerating profile...');
    await chatService.refreshProfile();
    print('Profile regenerated successfully!');
  } catch (e) {
    print('Error refreshing profile: $e');
  }
}

void exampleClearHistory() async {
  final chatService = ChatService();

  try {
    print('Clearing chat history...');
    await chatService.clearChatHistory();
    print('All messages deleted from Firestore');
  } catch (e) {
    print('Error clearing history: $e');
  }
}

void exampleErrorHandling() async {
  final chatService = ChatService();
  final userMessage = "I need help";

  try {
    final response = await chatService.sendMessage(userMessage: userMessage);
    print('Success: $response');
  } catch (e) {
    final errorMessage = _parseError(e);
    print('Error: $errorMessage');
  }
}

String _parseError(dynamic error) {
  final message = error.toString().toLowerCase();

  if (message.contains('not authenticated')) {
    return 'Please log in to continue chatting';
  } else if (message.contains('failed to save')) {
    return 'Could not save message. Check your connection.';
  } else if (message.contains('failed to fetch')) {
    return 'Could not load messages. Try again.';
  } else if (message.contains('failed to generate')) {
    return 'AI response failed. Try again.';
  } else if (message.contains('firestore')) {
    return 'Database error. Please try again later.';
  } else if (message.contains('gemini')) {
    return 'AI service error. Please try again.';
  } else {
    return 'An unexpected error occurred. Try again.';
  }
}

void exampleBatchDisplay() async {
  final chatService = ChatService();

  try {
    final messages = await chatService.getChatHistory(limit: 20);

    final displayMessages = messages.map((msg) {
      return {
        'sender': msg.role == 'user' ? 'You' : 'SafeSpace AI',
        'text': msg.content,
        'timestamp': msg.createdAt,
        'isUser': msg.isUser,
      };
    }).toList();

    print('Display messages: ${displayMessages.length}');
  } catch (e) {
    print('Error preparing messages: $e');
  }
}

/*
Stream<List<ChatMessage>> watchChatHistory({required String userId}) {
  return _firestore
      .collection('users')
      .doc(userId)
      .collection('chats')
      .doc('messages')
      .collection('messages')
      .orderBy('createdAt', descending: false)
      .limit(10)
      .snapshots()
      .map((snapshot) {
        return snapshot.docs
            .map((doc) => ChatMessage.fromFirestore(doc))
            .toList();
      });
}


StreamBuilder<List<ChatMessage>>(
  stream: watchChatHistory(userId: currentUserId),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return ListView.builder(
        itemCount: snapshot.data!.length,
        itemBuilder: (context, i) {
          final msg = snapshot.data![i];
          return MessageBubble(
            isUser: msg.isUser,
            text: msg.content,
          );
        },
      );
    }
    return CircularProgressIndicator();
  },
);
*/

void exampleConversationScenario() async {
  final chatService = ChatService();

  print('=== Day 1 ===');

  var response = await chatService.sendMessage(
    userMessage: 'I feel really stressed lately',
  );
  print('Bot: $response');

  response = await chatService.sendMessage(
    userMessage: 'Especially about school deadlines',
  );
  print('Bot: $response');

  print('=== Message 15 ===');

  response = await chatService.sendMessage(
    userMessage: 'I feel like I am drowning in work',
  );
  print('Bot: $response');

  print('=== Day 2 ===');

  response = await chatService.sendMessage(
    userMessage: 'I had a better day today',
  );
  print('Bot: $response');
}

void exampleMaintenance() async {
  final chatService = ChatService();

  await chatService.clearChatHistory();
  print('Chat history cleared for fresh start');

  await chatService.refreshProfile();
  print('Profile updated with new context');

  final profile = await chatService.getUserProfile();
  if (profile.isNotEmpty) {
    print('Current understanding of you:');
    print(profile);
  }
}

/*
Before deploying to production, ensure:

[ ] 1. Authentication
    - User is authenticated before any ChatService call
    - Handles logout gracefully (clear UI state)
    - Firebase Auth properly configured

[ ] 2. Firestore Security Rules
    - Users can only access their own data
    - No cross-user data access
    - Reads/writes properly restricted

[ ] 3. Error Handling
    - All ChatService methods wrapped in try-catch
    - User sees friendly error messages
    - Network errors handled
    - API rate limits respected

[ ] 4. UI/UX
    - Loading states shown (typing indicator)
    - Sent messages appear immediately
    - Received messages update async
    - Profile summary displayed if available

[ ] 5. Performance
    - History limited to 50 messages for UI
    - Only last 10 messages sent to Gemini
    - Summary trimmed to 500 chars
    - No blocking operations on main thread

[ ] 6. Privacy
    - Clear history option available
    - Confirm before deleting data
    - User owns all their data
    - No analytics on sensitive messages

[ ] 7. Testing
    - Test with new user (no messages)
    - Test with 15+ messages (summary generation)
    - Test with poor network connection
    - Test after app restart (history persists)
    - Test logout/login flow

[ ] 8. Monitoring
    - Log errors for debugging
    - Monitor Firestore usage
    - Monitor Gemini API usage
    - Alert if API errors spike
*/
