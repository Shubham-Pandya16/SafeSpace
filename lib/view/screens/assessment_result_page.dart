import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safe_space/model/colors.dart';

class AssessmentResultPage extends StatefulWidget {
  final int score;

  const AssessmentResultPage({super.key, required this.score});

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
            'Things may feel heavy right now. When you\'re ready, talking with a friend, family member, or someone you trust can help. You don\'t have to carry this alone.',
      );
    } else {
      return _ResultData(
        category: 'Very high distress',
        categoryColor: const Color(0xFFD97A5D),
        largeMessage:
            'You\'re going through a very hard time. It may help to reach out to someone you trust or to explore support options when you\'re ready. Many people find talking to others helpful.',
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
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 20.0,
            ),
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
                    letterSpacing: -0.2,
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
    final int segmentIndex;
    final int s = widget.score;
    if (s <= 20) {
      segmentIndex = 0;
    } else if (s <= 40) {
      segmentIndex = 1;
    } else if (s <= 60) {
      segmentIndex = 2;
    } else if (s <= 80) {
      segmentIndex = 3;
    } else {
      segmentIndex = 4;
    }

    final segmentColors = [
      AppColors.green,
      const Color(0xFFC7D86D),
      const Color(0xFFE6B66F),
      const Color(0xFFDC8B4B),
      const Color(0xFFD97A5D),
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.lightBrown, AppColors.mediumBrown],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Soft label
          Text(
            'How things feel right now',
            style: GoogleFonts.calSans(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 16),

          // Segmented visual indicator (non-numeric)
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: List.generate(5, (i) {
                final isActive = i == segmentIndex;
                return Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.only(left: i == 0 ? 0 : 6),
                    height: isActive ? 20 : 14,
                    decoration: BoxDecoration(
                      color: isActive
                          ? segmentColors[i].withOpacity(0.95)
                          : segmentColors[i].withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 12),

          // Gentle caption
          Text(
            'This reflects how much emotional strain you may be experiencing recently.',
            textAlign: TextAlign.center,
            style: GoogleFonts.calSans(fontSize: 13, color: Colors.white70),
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
          border: Border.all(color: AppColors.mediumBrown, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Text(action.icon, style: const TextStyle(fontSize: 24)),
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
          Navigator.pop(context);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
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
