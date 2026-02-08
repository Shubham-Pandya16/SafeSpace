import 'package:flutter/material.dart';
import 'package:safe_space/controller/assessment_state.dart';
import 'package:safe_space/model/colors.dart';
import 'package:safe_space/view/screens/assessment_result_page.dart';

class AssessmentPage extends StatefulWidget {
  const AssessmentPage({super.key});

  @override
  State<AssessmentPage> createState() => _AssessmentPageState();
}

class _AssessmentPageState extends State<AssessmentPage> {
  late AssessmentState _assessmentState;

  @override
  void initState() {
    super.initState();
    _assessmentState = AssessmentState();
    _assessmentState.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    _assessmentState.removeListener(_onStateChanged);
    _assessmentState.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_assessmentState.currentQuestion == null) {
      return const Scaffold(
        backgroundColor: AppColors.brown,
        body: Center(child: Text('Assessment not available')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.brown,
      body: SafeArea(
        child: Column(
          children: [
            // Header with progress
            _buildHeader(context, _assessmentState),

            // Main content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Disclaimer
                    _buildDisclaimer(),
                    const SizedBox(height: 32),

                    // Current question
                    _buildQuestion(_assessmentState),
                    const SizedBox(height: 32),

                    // Radio options
                    _buildRadioOptions(context, _assessmentState),
                  ],
                ),
              ),
            ),

            // Navigation buttons
            _buildNavigation(context, _assessmentState),
          ],
        ),
      ),
    );
  }

  /// Build header with progress indicator
  Widget _buildHeader(BuildContext context, AssessmentState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.mediumBrown,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress text
          Text(
            '${state.currentQuestionIndex + 1} of ${state.totalQuestions}',
            style: const TextStyle(
              color: AppColors.lightGrey,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: state.progressPercentage,
              minHeight: 8,
              backgroundColor: AppColors.lightBrown,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.green),
            ),
          ),
        ],
      ),
    );
  }

  /// Build disclaimer section
  Widget _buildDisclaimer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightBrown.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.green.withAlpha(50), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.green.withAlpha(80),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'This is a self-assessment, not a diagnosis.',
              style: TextStyle(
                color: AppColors.green.withAlpha(80),
                fontSize: 13,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build current question text
  Widget _buildQuestion(AssessmentState state) {
    final question = state.currentQuestion;
    if (question == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How are you feeling?',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          question.text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  /// Build radio button options
  Widget _buildRadioOptions(BuildContext context, AssessmentState state) {
    final question = state.currentQuestion;
    if (question == null) return const SizedBox.shrink();

    final currentAnswer = state.getCurrentAnswer();

    return Column(
      children: List.generate(question.options.length, (index) {
        final isSelected = currentAnswer == index;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () => state.saveAnswer(index),
            child: _buildOptionCard(
              option: question.options[index],
              isSelected: isSelected,
              index: index,
            ),
          ),
        );
      }),
    );
  }

  /// Build individual option card
  Widget _buildOptionCard({
    required String option,
    required bool isSelected,
    required int index,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.accentBlue.withAlpha(51)
            : AppColors.mediumBrown.withOpacity(0.5),
        border: Border.all(
          color: isSelected
              ? AppColors.accentBlue.withAlpha(200)
              : AppColors.mediumBrown,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.lightestBrowm.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? AppColors.accentTeal.withAlpha(200)
                    : Colors.white.withOpacity(0.3),
                width: isSelected ? 2 : 1,
              ),
              color: isSelected
                  ? AppColors.accentBlue.withAlpha(51)
                  : Colors.transparent,
            ),
            child: isSelected
                ? const Icon(Icons.check, size: 14, color: AppColors.accentBlue)
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              option,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build navigation buttons
  Widget _buildNavigation(BuildContext context, AssessmentState state) {
    final canGoBack = state.currentQuestionIndex > 0;
    final canGoForward = state.isAnswered;
    final isLastQuestion = state.isLastQuestion;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // color: AppColors.mediumBrown,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.1),
        //     blurRadius: 8,
        //     offset: const Offset(0, -2),
        //   ),
        // ],
      ),
      child: Row(
        children: [
          // Back button
          if (canGoBack)
            Expanded(
              child: _buildSecondaryButton(
                // label: ,
                onPressed: () => state.previousQuestion(),
              ),
            )
          else
            const Expanded(child: SizedBox.shrink()),

          if (canGoBack) const SizedBox(width: 12),

          // Next/Finish button
          Expanded(
            child: state.isLoading
                ? _buildLoadingButton()
                : _buildPrimaryButton(
                    label: Icon(
                      Icons.chevron_right_outlined,
                      color: AppColors.brown,
                    ),
                    onPressed: canGoForward
                        ? () async {
                            if (isLastQuestion) {
                              await _handleFinishAssessment(context, state);
                            } else {
                              state.nextQuestion();
                            }
                          }
                        : null,
                  ),
          ),
        ],
      ),
    );
  }

  /// Build primary button
  Widget _buildPrimaryButton({
    required Icon label,
    required VoidCallback? onPressed,
  }) {
    final isEnabled = onPressed != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isEnabled ? onPressed : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isEnabled
                ? AppColors.accentTeal.withAlpha(200)
                : AppColors.lightestBrowm.withOpacity(0.4),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: label,

            // Text(
            //   label,
            //   style: TextStyle(
            //     color: isEnabled ? AppColors.brown : Colors.white54,
            //     fontSize: 15,
            //     fontWeight: FontWeight.w700,
            //     letterSpacing: 0.5,
            //   ),
            // ),
          ),
        ),
      ),
    );
  }

  /// Build secondary button
  Widget _buildSecondaryButton({
    // required IconData label,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: AppColors.lightestBrowm.withOpacity(0.5),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Icon(
              Icons.chevron_left_outlined,
              color: AppColors.lightestBrowm,
            ),

            // Text(
            //   label,
            //   style: const TextStyle(
            //     color: AppColors.lightestBrowm,
            //     fontSize: 15,
            //     fontWeight: FontWeight.w700,
            //     letterSpacing: 0.5,
            //   ),
            // ),
          ),
        ),
      ),
    );
  }

  /// Build loading button
  Widget _buildLoadingButton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.lightestBrowm.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.lightestBrowm),
          ),
        ),
      ),
    );
  }

  /// Handle finish assessment
  Future<void> _handleFinishAssessment(
    BuildContext context,
    AssessmentState state,
  ) async {
    try {
      final int score = await state.submitAssessment();

      if (!mounted) return;

      // Navigate to results page (score used internally only)
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => AssessmentResultPage(score: score)),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.errorMessage ?? 'Failed to submit assessment'),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }
}
