import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String id;
  final String role;
  final String content;
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
  });

  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatMessage(
      id: doc.id,
      role: data['role'] ?? 'user',
      content: data['content'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'role': role,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  bool get isUser => role == 'user';
  bool get isAssistant => role == 'assistant';
}

class UserProfile {
  final String uid;
  final String profileSummary;
  final DateTime? summaryUpdatedAt;

  UserProfile({
    required this.uid,
    this.profileSummary = '',
    this.summaryUpdatedAt,
  });

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      uid: doc.id,
      profileSummary: data['profileSummary'] ?? '',
      summaryUpdatedAt: data['summaryUpdatedAt'] != null
          ? (data['summaryUpdatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'profileSummary': profileSummary,
      'summaryUpdatedAt': summaryUpdatedAt != null
          ? Timestamp.fromDate(summaryUpdatedAt!)
          : null,
    };
  }
}
