import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safe_space/model/colors.dart';

class AssessmentResultPage extends StatefulWidget {
  final int score;

  const AssessmentResultPage({
    super.key,
    required this.score,
  });

  @override
  State<AssessmentResultPage> createState() => _AssessmentResultPageState();
}

class _AssessmentResultPageState extends State<AssessmentResultPage> {
  late final _ResultData _resultData;

  @override
  void initState() {
    super.initState();
    _resultData = _getResultData(widget.score);
  }

  _ResultData _getResultData(int score) {
    if (score <= 20) {
      return _ResultData(
        category: 'Coping well',
        categoryColor: AppColors.green,
        largeMessage:
            'You\'re managing well right now. You\'re taking steps to look after yourself, and that matters. Keep doing what\'s working for you.',
      );
    } else if (score <= 40) {
      return _ResultData(
        category: 'Mild emotional strain',
        categoryColor: const Color(0xFFC7D86D),
        largeMessage:
            'You\'re experiencing some stress, and that\'s completely normal. Many of us go through phases like this. Small steps—like talking it out or taking a break—can help.',
      );
    } else if (score <= 60) {
      return _ResultData(
        category: 'Noticeable distress',
        categoryColor: const Color(0xFFE6B66F),
        largeMessage:
            'You\'re dealing with more than usual right now. It\'s important to reach out and find support. There\'s no shame in needing help—we all do sometimes.',
      );
    } else if (score <= 80) {
      return _ResultData(
        category: 'High emotional burden',
        categoryColor: const Color(0xFFDC8B4B),
        largeMessage:
            'Things feel heavy at the moment. Please consider talking to someone—a friend, family member, or counselor. You don\'t have to carry this alone. Support is available.',
      );
    } else {
      return _ResultData(
        category: 'Very high distress',
        categoryColor: const Color(0xFFD97A5D),
        largeMessage:
            'You\'re going through a really difficult time. Please reach out for support now. Talking to someone—whether it\'s a trusted person or a professional—can make a real difference.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brown,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Headline
                const SizedBox(height: 16),
                Text(
                  'Thanks for checking in\nwith yourself',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.calSans(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 32),

                // Score Visualization
                _buildScoreCard(context),

                const SizedBox(height: 36),

                // Explanation Text
                Text(
                  'This reflects how much emotional strain you may be experiencing recently.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.calSans(
                    fontSize: 14,
                    color: Colors.white70,
                    letterSpacing: 0.3,
                  ),
                ),

                const SizedBox(height: 32),

                // Category and Message
                _buildInterpretationSection(context),

                const SizedBox(height: 36),

                // Action Section
                _buildActionSection(context),

                const SizedBox(height: 32),

                // Disclaimer
                _buildDisclaimer(context),

                const SizedBox(height: 24),

                // Close/Continue Button
                _buildCloseButton(context),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScoreCard(BuildContext context) {
    final progress = widget.score / 100.0;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.lightBrown,
            AppColors.mediumBrown,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          // Circular progress indicator
          SizedBox(
            height: 140,
            width: 140,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background circle
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
                // Progress ring
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 8,
                  backgroundColor: Colors.white.withOpacity(0.15),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _resultData.categoryColor,
                  ),
                ),
                // Score text in center
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.score.toString(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.calSans(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'out of 100',
                      style: GoogleFonts.calSans(
                        fontSize: 12,
                        color: Colors.white70,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.15),
              valueColor: AlwaysStoppedAnimation<Color>(
                _resultData.categoryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterpretationSection(BuildContext context) {
    return Column(
      children: [
        // Category badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _resultData.categoryColor.withOpacity(0.2),
            border: Border.all(
              color: _resultData.categoryColor.withOpacity(0.5),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _resultData.category,
            style: GoogleFonts.calSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _resultData.categoryColor,
              letterSpacing: 0.3,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Message
        Text(
          _resultData.largeMessage,
          textAlign: TextAlign.center,
          style: GoogleFonts.calSans(
            fontSize: 15,
            color: Colors.white,
            letterSpacing: 0.3,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildActionSection(BuildContext context) {
    final actions = [
      _ActionItem(
        icon: '🧘',
        title: 'Try a calming exercise',
        description: 'Breathing techniques and guided pauses can help.',
      ),
      _ActionItem(
        icon: '💬',
        title: 'Talk with others',
        description: 'Share in community spaces when you\'re ready.',
      ),
      _ActionItem(
        icon: '📚',
        title: 'Explore resources',
        description: 'At your own pace, whenever it feels right.',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'You might find these helpful:',
          style: GoogleFonts.calSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 16),
        ...actions.map((action) => _buildActionItem(action)).toList(),
      ],
    );
  }

  Widget _buildActionItem(_ActionItem action) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.lightBrown.withOpacity(0.5),
          border: Border.all(
            color: AppColors.mediumBrown,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Text(
              action.icon,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    action.title,
                    style: GoogleFonts.calSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    action.description,
                    style: GoogleFonts.calSans(
                      fontSize: 12,
                      color: Colors.white70,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisclaimer(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightestBrowm.withOpacity(0.3),
        border: Border.all(
          color: AppColors.lightestBrowm.withOpacity(0.5),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Text(
        'This is a self-assessment, not a diagnosis.\nIt reflects how you\'ve been feeling recently.',
        textAlign: TextAlign.center,
        style: GoogleFonts.calSans(
          fontSize: 12,
          color: Colors.white70,
          // letterspacing: 0.2,
        ),
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: MaterialButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        color: AppColors.lightestBrowm,
        child: Text(
          'Close',
          style: GoogleFonts.calSans(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}

class _ActionItem {
  final String icon;
  final String title;
  final String description;

  _ActionItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class _ResultData {
  final String category;
  final Color categoryColor;
  final String largeMessage;

  _ResultData({
    required this.category,
    required this.categoryColor,
    required this.largeMessage,
  });
}
