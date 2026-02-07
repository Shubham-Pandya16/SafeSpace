import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safe_space/model/colors.dart';
import 'package:safe_space/view/screens/assessment_page.dart';
import 'package:safe_space/view/screens/channels_page.dart';
import 'package:safe_space/view/screens/chatbot_page.dart';
import 'package:safe_space/view/screens/relax_and_reset_page.dart';
import 'package:safe_space/view/widgets/cLogo.dart';
import 'package:safe_space/view/widgets/mindful_resources_page.dart';

import '../../controller/auth_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning!';
    } else if (hour < 17) {
      return 'Good Afternoon!';
    } else {
      return 'Good Evening!';
    }
  }

  final AuthController _authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brown,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGreetingSection(),
                    const SizedBox(height: 16),

                    _buildMoodCard(),
                    const SizedBox(height: 24),

                    _buildDailyQuoteCard(),
                    const SizedBox(height: 28),

                    _buildHeadingText('What you need right now'),
                    const SizedBox(height: 12),
                    _buildSelfAssessmentCard(context),
                    const SizedBox(height: 28),

                    _buildHeadingText('Find support'),
                    const SizedBox(height: 12),
                    _buildTwoActionCards(context),
                    const SizedBox(height: 28),

                    _buildHeadingText('Other resources'),
                    const SizedBox(height: 12),
                    _buildSubtleChatOption(context),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildRelaxResetFAB(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: GestureDetector(
        onLongPress: () {
          _authController.signOut(context);
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: cLogo(fontSize: 32),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
      ),
      backgroundColor: AppColors.mediumBrown,
    );
  }

  Widget _buildGreetingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getGreeting(),
          style: GoogleFonts.urbanist(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          'How are you feeling today?',
          style: GoogleFonts.urbanist(
            fontSize: 16,
            color: AppColors.lightGrey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildHeadingText(String text) {
    return Text(
      text,
      style: GoogleFonts.urbanist(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.lightGrey,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildMoodCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightBrown,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'How are you feeling today?',
                style: GoogleFonts.urbanist(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _MoodSelector(),
          const SizedBox(height: 12),
          Text(
            'Track your mood to understand yourself better.',
            style: GoogleFonts.urbanist(
              fontSize: 12,
              color: AppColors.lightGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyQuoteCard() {
    final quotes = [
      '"There is hope, even when your brain tells you there isn\'t."',
      '"You don\'t have to see the whole staircase, just take the first step."',
      '"Progress is not about perfection."',
      '"You are stronger than you think."',
      '"This moment is an opportunity to choose peace."',
      '"Healing is not linear, but it is possible."',
      '"Your mental health is a priority, not a luxury."',
    ];

    final dayIndex = DateTime.now().weekday - 1;
    final quote = quotes[dayIndex % quotes.length];

    return Container(
      width: double.infinity,
      height: 280,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.mediumBrown,
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.mediumBrown, AppColors.lightestBrowm],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Center(
              child: Text(
                quote,
                textAlign: TextAlign.center,
                style: GoogleFonts.urbanist(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 1.6,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                .asMap()
                .entries
                .map((entry) {
                  final isActive = entry.key == dayIndex;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: Text(
                      entry.value,
                      style: GoogleFonts.urbanist(
                        fontSize: 12,
                        color: isActive
                            ? Colors.white
                            : Colors.white.withOpacity(0.5),
                        fontWeight: isActive
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  );
                })
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSelfAssessmentCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.lightBrown,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.mediumBrown,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.assessment_outlined,
                  color: AppColors.green,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Self Assessment Questionnaire',
                      style: GoogleFonts.urbanist(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Understand your wellbeing with\npsychological screening tools',
                      style: GoogleFonts.urbanist(
                        fontSize: 12,
                        color: AppColors.lightGrey,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: Material(
              color: AppColors.mediumBrown,
              borderRadius: BorderRadius.circular(25),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AssessmentPage()),
                  );
                },
                borderRadius: BorderRadius.circular(25),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'GET STARTED',
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTwoActionCards(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            context,
            icon: Icons.people_outline,
            label: 'Community',
            description: 'Connect with others',
            page: const ChannelsPage(),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionCard(
            context,
            icon: Icons.play_circle_outline,
            label: 'Resources',
            description: 'Learn & cope',
            page: const MindfulResourcesPage(),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String description,
    required Widget page,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.lightBrown,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.green, size: 36),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.urbanist(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              textAlign: TextAlign.center,
              style: GoogleFonts.urbanist(
                fontSize: 11,
                color: AppColors.lightGrey,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubtleChatOption(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightBrown.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.mediumBrown.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.mediumBrown.withOpacity(0.6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.smart_toy_outlined,
              color: AppColors.green.withOpacity(0.8),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Need a conversation?',
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Chat with SafeSpace.AI anytime',
                  style: GoogleFonts.urbanist(
                    fontSize: 12,
                    color: AppColors.lightGrey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            Icons.arrow_forward_ios,
            color: AppColors.green.withOpacity(0.8),
            size: 16,
          ),
        ],
      ),
    ).userTap(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ChatBotPage()),
      );
    });
  }

  Widget _buildRelaxResetFAB(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RelaxAndResetPage()),
          );
        },
        backgroundColor: AppColors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        label: Text(
          'Relax & Reset',
          style: GoogleFonts.urbanist(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.brown,
          ),
        ),
        icon: Icon(Icons.spa_outlined, color: AppColors.brown, size: 22),
      ),
    );
  }
}

extension TapableWidget on Widget {
  Widget userTap(VoidCallback onTap) {
    return GestureDetector(onTap: onTap, child: this);
  }
}

class _MoodSelector extends StatefulWidget {
  @override
  State<_MoodSelector> createState() => _MoodSelectorState();
}

class _MoodSelectorState extends State<_MoodSelector> {
  String? _selected;

  void _select(String mood) {
    setState(() => _selected = mood);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mood saved: $mood'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.mediumBrown,
      ),
    );
  }

  Widget _moodButton(String mood, IconData icon) {
    final isSelected = _selected == mood;
    return Expanded(
      child: GestureDetector(
        onTap: () => _select(mood),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.mediumBrown
                    : Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.green : Colors.transparent,
                  width: isSelected ? 2 : 0,
                ),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.green : Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              mood,
              style: GoogleFonts.urbanist(
                fontSize: 12,
                color: isSelected ? Colors.white : AppColors.lightGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _moodButton('Great', Icons.sentiment_very_satisfied),
        const SizedBox(width: 10),
        _moodButton('Good', Icons.sentiment_satisfied),
        const SizedBox(width: 10),
        _moodButton('Okay', Icons.sentiment_neutral),
        const SizedBox(width: 10),
        _moodButton('Low', Icons.sentiment_dissatisfied),
      ],
    );
  }
}
