import 'package:flutter/material.dart';
import 'package:safe_space/model/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safe_space/view/screens/home_page.dart';
import 'package:safe_space/view/screens/chatbot_page.dart';
import 'package:safe_space/view/screens/channels_page.dart';

/// MainNavigation provides intent-driven navigation for users who know what they want.
/// 
/// Design Philosophy:
/// - Always visible bottom navigation for habitual access
/// - Icon-first, minimal visual weight
/// - Functional, not promotional
/// - Three tabs: Home, Chat (SafeSpace.AI), Community
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  late final List<Widget> _pages = [
    const HomePage(),
    const ChatBotPage(),
    const ChannelsPage(),
  ];

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  /// Builds a clean, minimal bottom navigation bar
  /// 
  /// Design decisions:
  /// - Icon-only, no labels (reduces visual weight)
  /// - Soft color treatment (not bold/neon)
  /// - Exactly 3 tabs (prevents cognitive overload)
  /// - Selected state uses AppColors.green for consistency
  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onNavTapped,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.mediumBrown,
      selectedItemColor: AppColors.green,
      unselectedItemColor: Colors.white.withOpacity(0.6),
      elevation: 8,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined, size: 28),
          activeIcon: Icon(Icons.home_filled, size: 28),
          label: 'Home',
          tooltip: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.smart_toy_outlined, size: 28),
          activeIcon: Icon(Icons.smart_toy, size: 28),
          label: 'Chat',
          tooltip: 'Chat with SafeSpace.AI',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_outline, size: 28),
          activeIcon: Icon(Icons.people, size: 28),
          label: 'Community',
          tooltip: 'Community',
        ),
      ],
    );
  }
}
