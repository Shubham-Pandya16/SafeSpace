import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:safe_space/controller/apiKey.dart';

class GeminiService {
  late GenerativeModel _model;

  GeminiService() {
    _initializeModel();
  }

  void _initializeModel() async {
    final apiKey = await fetchApiKeyFromFirestore();
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
    );
  }

  /// Generate response with memory context
  Future<String> generateResponse({
    required String systemPrompt,
    required String userMessage,
    required String recentConversation,
    required String userProfile,
  }) async {
    try {
      final fullPrompt = '''$systemPrompt

User Emotional Profile:
$userProfile

Recent Conversation:
$recentConversation

New User Message:
$userMessage
''';

      final content = Content.text(fullPrompt);
      final response = await _model.generateContent([content]);

      return response.text ?? "I'm here with you.";
    } catch (e) {
      throw Exception('Failed to generate response: $e');
    }
  }

  /// Generate conversation summary
  Future<String> generateSummary({
    required String conversationText,
  }) async {
    try {
      final summaryPrompt = '''Summarize this conversation in under 120 words.
Focus on:
- recurring emotional themes
- common stress triggers
- behavioral patterns
- important context to remember
Write in third person.

Conversation:
$conversationText

Summary:''';

      final content = Content.text(summaryPrompt);
      final response = await _model.generateContent([content]);

      final summary = response.text ?? '';
      return summary.length > 500
          ? summary.substring(0, 500)
          : summary;
    } catch (e) {
      throw Exception('Failed to generate summary: $e');
    }
  }
}
