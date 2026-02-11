import 'package:firebase_auth/firebase_auth.dart';
import 'package:safe_space/controller/firestore_chat_repository.dart';
import 'package:safe_space/controller/gemini_service.dart';
import 'package:safe_space/model/chat_message.dart';
import 'package:safe_space/model/system_prompt.dart';

class ChatService {
  final FirestoreChatRepository _repository = FirestoreChatRepository();
  final GeminiService _geminiService = GeminiService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const int MESSAGE_THRESHOLD = 15;

  /// Get current user ID
  String get _userId => _auth.currentUser?.uid ?? '';

  /// Build formatted conversation string from messages
  String _formatConversation(List<ChatMessage> messages) {
    return messages
        .map((msg) => '${msg.role == "user" ? "User" : "Assistant"}: ${msg.content}')
        .join('\n');
  }

  /// Check if summary should be generated
  Future<bool> _shouldGenerateSummary() async {
    final messageCount = await _repository.getMessageCount(userId: _userId);
    final profile = await _repository.getUserProfile(userId: _userId);

    return messageCount > 0 && messageCount % MESSAGE_THRESHOLD == 0 ||
        (profile?.profileSummary.isEmpty ?? true);
  }

  /// Generate and save summary
  Future<void> _generateAndSaveSummary() async {
    try {
      final allMessages = await _repository.getAllMessages(userId: _userId);
      if (allMessages.isEmpty) return;

      final conversationText = _formatConversation(allMessages);
      final summary = await _geminiService.generateSummary(
        conversationText: conversationText,
      );

      await _repository.updateProfileSummary(
        userId: _userId,
        summary: summary,
      );
    } catch (e) {
      print('Error generating summary: $e');
    }
  }

  /// Send message and get response with memory
  Future<String> sendMessage({required String userMessage}) async {
    if (_userId.isEmpty) {
      throw Exception('User not authenticated');
    }

    // 1. Save user message
    await _repository.saveMessage(
      userId: _userId,
      role: 'user',
      content: userMessage,
    );

    // 2. Fetch recent messages
    final recentMessages = await _repository.fetchRecentMessages(
      userId: _userId,
      limit: 10,
    );

    // 3. Get user profile summary
    final userProfile = await _repository.getUserProfile(userId: _userId);
    final profileSummary = userProfile?.profileSummary ?? '';

    // 4. Format conversation
    final formattedConversation = _formatConversation(recentMessages);

    // 5. Generate response with context
    final response = await _geminiService.generateResponse(
      systemPrompt: systemPrompt,
      userMessage: userMessage,
      recentConversation: formattedConversation,
      userProfile: profileSummary.isEmpty
          ? 'No profile data yet. Learning about user...'
          : profileSummary,
    );

    // 6. Save assistant response
    await _repository.saveMessage(
      userId: _userId,
      role: 'assistant',
      content: response,
    );

    // 7. Check if summary should be generated
    if (await _shouldGenerateSummary()) {
      await _generateAndSaveSummary();
    }

    return response;
  }

  /// Get chat history
  Future<List<ChatMessage>> getChatHistory({int limit = 10}) async {
    if (_userId.isEmpty) {
      throw Exception('User not authenticated');
    }

    return await _repository.fetchRecentMessages(
      userId: _userId,
      limit: limit,
    );
  }

  /// Clear chat history
  Future<void> clearChatHistory() async {
    if (_userId.isEmpty) {
      throw Exception('User not authenticated');
    }

    await _repository.clearChatHistory(userId: _userId);
  }

  /// Get user emotional profile
  Future<String> getUserProfile() async {
    if (_userId.isEmpty) {
      throw Exception('User not authenticated');
    }

    final profile = await _repository.getUserProfile(userId: _userId);
    return profile?.profileSummary ?? '';
  }

  /// Reload user profile (manual refresh)
  Future<void> refreshProfile() async {
    if (_userId.isEmpty) {
      throw Exception('User not authenticated');
    }

    await _generateAndSaveSummary();
  }
}
