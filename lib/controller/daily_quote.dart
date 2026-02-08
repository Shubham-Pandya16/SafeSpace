import 'package:cloud_firestore/cloud_firestore.dart';

class DailyQuoteService {
  static List<String>? _cachedQuotes;

  static int _getTodayIndex() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return today.millisecondsSinceEpoch ~/ Duration.millisecondsPerDay;
  }

  static Future<List<String>> _fetchAllQuotes() async {
    if (_cachedQuotes != null) return _cachedQuotes!;

    final snapshot = await FirebaseFirestore.instance
        .collection('quotes')
        .get();

    _cachedQuotes = snapshot.docs
        .map((doc) => doc.data()['text'] as String)
        .toList();

    return _cachedQuotes!;
  }

  static Future<String> getTodayQuote() async {
    try {
      final quotes = await _fetchAllQuotes();

      if (quotes.isEmpty) {
        return "Take a moment for yourself today.";
      }

      final dayIndex = _getTodayIndex();
      final quoteIndex = dayIndex % quotes.length;

      return quotes[quoteIndex];
    } catch (_) {
      return "It’s okay to go at your own pace.";
    }
  }
}
