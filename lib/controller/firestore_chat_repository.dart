import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safe_space/model/chat_message.dart';

class FirestoreChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  
  Future<String> saveMessage({
    required String userId,
    required String role,
    required String content,
  }) async {
    try {
      final messageRef = await _firestore
          .collection('users')
          .doc(userId)
          .collection('chats')
          .doc('messages')
          .collection('messages')
          .add({
        'role': role,
        'content': content,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return messageRef.id;
    } catch (e) {
      throw Exception('Failed to save message: $e');
    }
  }

  
  Future<List<ChatMessage>> fetchRecentMessages({
    required String userId,
    int limit = 10,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('chats')
          .doc('messages')
          .collection('messages')
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      final messages = snapshot.docs
          .map((doc) => ChatMessage.fromFirestore(doc))
          .toList()
          .reversed
          .toList();

      return messages;
    } catch (e) {
      throw Exception('Failed to fetch messages: $e');
    }
  }

  
  Future<int> getMessageCount({required String userId}) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('chats')
          .doc('messages')
          .collection('messages')
          .count()
          .get();

      return snapshot.count ?? 0;
    } catch (e) {
      throw Exception('Failed to get message count: $e');
    }
  }

  
  Future<UserProfile?> getUserProfile({required String userId}) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .get();

      if (!doc.exists) {
        return null;
      }

      return UserProfile.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  
  Future<void> updateProfileSummary({
    required String userId,
    required String summary,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'profileSummary': summary,
        'summaryUpdatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update profile summary: $e');
    }
  }

  
  Future<List<ChatMessage>> getAllMessages({required String userId}) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('chats')
          .doc('messages')
          .collection('messages')
          .orderBy('createdAt', descending: false)
          .get();

      return snapshot.docs
          .map((doc) => ChatMessage.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get all messages: $e');
    }
  }

  
  Future<void> clearChatHistory({required String userId}) async {
    try {
      final collection = _firestore
          .collection('users')
          .doc(userId)
          .collection('chats')
          .doc('messages')
          .collection('messages');

      final docs = await collection.get();
      for (var doc in docs.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception('Failed to clear chat history: $e');
    }
  }
}
