import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:safe_space/model/questionnaire.dart';

class AssessmentState extends ChangeNotifier {
  int currentQuestionIndex = 0;
  final Map<String, int> answers = {};
  bool isLoading = false;
  String? errorMessage;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  int get totalQuestions => mentalHealthQuestionnaire.length;
  Question? get currentQuestion => currentQuestionIndex < totalQuestions
      ? mentalHealthQuestionnaire[currentQuestionIndex]
      : null;

  bool get isAnswered =>
      answers.containsKey(currentQuestion?.id) &&
      answers[currentQuestion?.id] != null;

  bool get isLastQuestion => currentQuestionIndex == totalQuestions - 1;

  /// Move to the next question
  void nextQuestion() {
    if (currentQuestionIndex < totalQuestions - 1) {
      currentQuestionIndex++;
      notifyListeners();
    }
  }

  /// Move to the previous question
  void previousQuestion() {
    if (currentQuestionIndex > 0) {
      currentQuestionIndex--;
      notifyListeners();
    }
  }

  /// Save an answer for the current question
  void saveAnswer(int value) {
    if (currentQuestion != null) {
      answers[currentQuestion!.id] = value;
      notifyListeners();
    }
  }

  /// Get the answer for the current question (if any)
  int? getCurrentAnswer() {
    return answers[currentQuestion?.id];
  }

  /// Calculate mental health score based on answers
  /// Score range: 0-100 (normalized across all three scales)
  int _calculateMentalHealthScore(Map<String, int> answers) {
    // Initialize scores for each scale
    int phq9Score = 0;
    int gad7Score = 0;
    int dassScore = 0;

    // Aggregate scores by scale
    answers.forEach((questionId, value) {
      final question = mentalHealthQuestionnaire.firstWhere(
        (q) => q.id == questionId,
        orElse: () => Question(
          id: '',
          text: '',
          options: const [],
          scale: ScaleType.phq9,
        ),
      );

      switch (question.scale) {
        case ScaleType.phq9:
          phq9Score += value;
          break;
        case ScaleType.gad7:
          gad7Score += value;
          break;
        case ScaleType.dassDepression:
        case ScaleType.dassAnxiety:
        case ScaleType.dassStress:
          dassScore += value;
          break;
      }
    });

    // PHQ-9: max 27, GAD-7: max 21, DASS-21: max 63
    final phq9Normalized = (phq9Score / 27 * 33.33).toInt();
    final gad7Normalized = (gad7Score / 21 * 33.33).toInt();
    final dassNormalized = (dassScore / 63 * 33.34).toInt();

    final totalScore = phq9Normalized + gad7Normalized + dassNormalized;

    return totalScore.clamp(0, 100);
  }

  Future<int> submitAssessment() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final score = _calculateMentalHealthScore(answers);

      await _firestore.collection('assessments').add({
        'uid': user.uid,
        'score': score,
        'timestamp': FieldValue.serverTimestamp(),
      });

      isLoading = false;
      notifyListeners();

      return score;
    } catch (e) {
      isLoading = false;
      errorMessage = 'Failed to submit assessment: ${e.toString()}';
      notifyListeners();
      rethrow;
    }
  }

  void reset() {
    currentQuestionIndex = 0;
    answers.clear();
    isLoading = false;
    errorMessage = null;
    notifyListeners();
  }

  double get progressPercentage => (currentQuestionIndex + 1) / totalQuestions;
}
