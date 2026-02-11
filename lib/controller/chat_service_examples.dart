import 'package:firebase_auth/firebase_auth.dart';
import 'package:safe_space/controller/chat_service.dart';
import 'package:safe_space/model/chat_message.dart';

/// EXAMPLE USAGE & PRODUCTION PATTERNS
///
/// This file demonstrates how to use ChatService in various scenarios
/// with proper error handling and edge case management.

// ============================================================================
// EXAMPLE 1: BASIC CHAT INTEGRATION (Already in chatbot_page.dart)
// ============================================================================

void exampleBasicIntegration() async {
  final chatService = ChatService();

  try {
    // Send message (automatically handles everything)
    final response = await chatService.sendMessage(
      userMessage: "I'm feeling overwhelmed with my assignments",
    );

    // Response already has:
    // ✓ User message saved to Firestore
    // ✓ Last 10 messages fetched as context
    // ✓ User emotional profile included
    // ✓ Generated with Gemini AI
    // ✓ Assistant response saved to Firestore
    // ✓ Summary generated (if 15 messages total)

    print('AI Response: $response');
  } catch (e) {
    print('Error: $e');
    // Handle: User not authenticated, network error, Gemini API error
  }
}

// ============================================================================
// EXAMPLE 2: LOAD CHAT HISTORY ON APP STARTUP
// ============================================================================

void exampleLoadHistory() async {
  final chatService = ChatService();

  try {
    // Get last 50 messages for display
    final messages = await chatService.getChatHistory(limit: 50);

    print('Found ${messages.length} previous messages');

    for (final msg in messages) {
      final sender = msg.role == 'user' ? 'You' : 'Assistant';
      final time = msg.createdAt.toString();
      print('[$time] $sender: ${msg.content}');
    }

    // Expected output:
    // [2025-02-11 10:15:30] You: How do I manage anxiety?
    // [2025-02-11 10:15:45] Assistant: Anxiety often stems from...
    // [2025-02-11 10:16:10] You: What if it gets worse?
    // ...etc
  } catch (e) {
    print('Failed to load history: $e');
    // Handle: Network error, Firestore error, user not authenticated
  }
}

// ============================================================================
// EXAMPLE 3: DISPLAY USER EMOTIONAL PROFILE
// ============================================================================

void exampleDisplayProfile() async {
  final chatService = ChatService();

  try {
    final profile = await chatService.getUserProfile();

    if (profile.isEmpty) {
      print('No profile yet. Start the conversation!');
      // This happens on first few messages or if never generated
    } else {
      print('Your Emotional Profile:');
      print('$profile');

      // Example output (after ~15 messages):
      // Your Emotional Profile:
      // User is an engineering student experiencing stress from deadlines
      // and perfectionism. Shows anxiety about social interactions and public
      // speaking. Family is supportive. Finds comfort in programming and
      // music. Tends to procrastinate when overwhelmed.
    }
  } catch (e) {
    print('Error fetching profile: $e');
  }
}

// ============================================================================
// EXAMPLE 4: MANUALLY REGENERATE PROFILE (Force Summary Update)
// ============================================================================

void exampleRefreshProfile() async {
  final chatService = ChatService();

  try {
    print('Regenerating profile...');
    await chatService.refreshProfile();
    print('Profile regenerated successfully!');

    // Use case: User requests update after sharing new info
    // This forces summary generation even if message count < 15
  } catch (e) {
    print('Error refreshing profile: $e');
  }
}

// ============================================================================
// EXAMPLE 5: CLEAR CHAT HISTORY (Privacy/Reset)
// ============================================================================

void exampleClearHistory() async {
  final chatService = ChatService();

  try {
    print('Clearing chat history...');
    await chatService.clearChatHistory();
    print('All messages deleted from Firestore');

    // Reset the conversation
    // ✓ All messages deleted
    // ✓ Profile summary still exists (user can see what was learned)
    // ✓ summaryUpdatedAt NOT cleared

    // Next message will:
    // - Have no recent conversation context (empty)
    // - Still include the previous profile summary
    // - Start fresh learning with new messages
  } catch (e) {
    print('Error clearing history: $e');
  }
}

// ============================================================================
// EXAMPLE 6: ERROR HANDLING IN UI
// ============================================================================

void exampleErrorHandling() async {
  final chatService = ChatService();
  final userMessage = "I need help";

  try {
    final response = await chatService.sendMessage(
      userMessage: userMessage,
    );
    print('Success: $response');
  } catch (e) {
    final errorMessage = _parseError(e);
    print('Error: $errorMessage');
    // Display error to user in UI
  }
}

/// Parse error and return user-friendly message
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

// ============================================================================
// EXAMPLE 7: BATCH MESSAGE DISPLAY (UI Rendering)
// ============================================================================

void exampleBatchDisplay() async {
  final chatService = ChatService();

  try {
    final messages = await chatService.getChatHistory(limit: 20);

    // Convert to display format
    final displayMessages = messages.map((msg) {
      return {
        'sender': msg.role == 'user' ? 'You' : 'SafeSpace AI',
        'text': msg.content,
        'timestamp': msg.createdAt,
        'isUser': msg.isUser,
      };
    }).toList();

    // Use displayMessages for ListView.builder in UI
    print('Display messages: ${displayMessages.length}');
  } catch (e) {
    print('Error preparing messages: $e');
  }
}

// ============================================================================
// EXAMPLE 8: STREAM-BASED MONITORING (Real-time Updates)
// ============================================================================

// Note: Not implemented in current ChatService, but here's how you could extend it:

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

// Usage in UI:
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

// ============================================================================
// EXAMPLE 9: CONVERSATION FLOW SCENARIO
// ============================================================================

void exampleConversationScenario() async {
  final chatService = ChatService();

  // Scenario: First-time user with anxiety

  print('=== Day 1 ===');

  // Message 1
  var response = await chatService.sendMessage(
    userMessage: 'I feel really stressed lately',
  );
  print('Bot: $response');
  // Profile: Empty (first time)
  // Context: None yet

  // Message 2
  response = await chatService.sendMessage(
    userMessage: 'Especially about school deadlines',
  );
  print('Bot: $response');
  // Profile: Empty (only 2 messages)
  // Context: Previous message included

  // ... messages 3-14 sent over time ...

  print('=== Message 15 ===');

  // Message 15
  response = await chatService.sendMessage(
    userMessage: 'I feel like I am drowning in work',
  );
  print('Bot: $response');
  // Profile: GENERATED! ✓
  // Context: 10 previous messages + profile + system prompt
  // Summary saved: "User is a student with academic anxiety..."

  print('=== Day 2 ===');

  // Message 16
  response = await chatService.sendMessage(
    userMessage: 'I had a better day today',
  );
  print('Bot: $response');
  // Profile: USED! ✓ (Gemini remembers background)
  // Context: Last 10 messages + profile from yesterday

  // The conversation is now more coherent and contextual!
}

// ============================================================================
// EXAMPLE 10: DATABASE MAINTENANCE & CLEANUP
// ============================================================================

void exampleMaintenance() async {
  final chatService = ChatService();

  // 1. Clear old chat history for privacy
  // (Call this on "New Conversation" button)
  await chatService.clearChatHistory();
  print('Chat history cleared for fresh start');

  // 2. Refresh profile after significant life event
  // (User shares new context)
  await chatService.refreshProfile();
  print('Profile updated with new context');

  // 3. Get profile and show to user
  final profile = await chatService.getUserProfile();
  if (profile.isNotEmpty) {
    print('Current understanding of you:');
    print(profile);
  }
}

// ============================================================================
// PRODUCTION CHECKLIST
// ============================================================================

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

// ============================================================================
// NO ACTUAL RUNNING CODE IN THIS FILE - EXAMPLES ONLY
// ============================================================================
